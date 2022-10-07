import UIKit
import CoreLocation
import UserNotifications

class KakaoMapView2: UIViewController, CLLocationManagerDelegate {
    
    let forecast =  WeatherService()
    let Rescue_data = DataLoader().rescue_data
    let Hospital_data = DataLoader().hospital_data
    
    public let locationManager = CLLocationManager()
    public var user_lat: Double = 0     // 사용자 위도
    public var user_lng: Double = 0     // 사용자 경도
    var currentWeather: Current?
    var NextWeather: [Hourly] = []      // 1시간 단위 데이터 배열
    var rescue_lst: [rescue] = []       // 최단거리 5개 응급구조함 배열
    var hospital_lst: [hospital] = []   // 최단거리 병원 배열
    
    @IBOutlet var NowLocation: UILabel! // 현재 위치 가르쳐줌
    @IBOutlet var FindBtn: UIButton!    // 응급구조함 검색 버튼
    @IBOutlet var TrackBtn: UIButton!   // 트래킹 모드 버튼
    @IBOutlet var WeatherView: UIView!
    @IBOutlet var WeatherImg: UIImageView!
    @IBOutlet var WeatherTemp: UILabel!
    @IBOutlet var WeatherTempImg: UIImageView!
    @IBOutlet var WeatherUvi: UILabel!
    @IBOutlet var WeatherNextTime: UILabel!
    @IBOutlet var WeatherNextImg: UIImageView!
    @IBOutlet var WeatherNextTemp: UILabel!
    @IBOutlet var FindRescueBtn: UIButton!
    @IBOutlet var FindHospitalBtn: UIButton!
    
    // 연결문제 겁나 오래 걸렸는데 영어로 읽고 기존의 스토리보드에서 스위프트파일로
    // 드래그하는 방식에서 다른 연결방식으로 해결함.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.WeatherView.layer.cornerRadius = 15
        self.FindRescueBtn.layer.cornerRadius = 15
        self.FindHospitalBtn.layer.cornerRadius = 15
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else { print("위치 서비스 off 상태") }
        
        user_lat = (locationManager.location?.coordinate.latitude ?? 0.0)!
        user_lng = (locationManager.location?.coordinate.longitude ?? 0.0)!
        
        //          지도 구현 **** 삭제
        //        let Frame = CGRect(x: 16, y: 205, width: 358, height: 473)
        //        mapView = MTMapView(frame: Frame)
        //        if let mapView = mapView {
        //            // 델리게이트 설정이 여러개가 가능한가?
        //            mapView.delegate = self
        //            mapView.baseMapType = .standard
        //            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
        //                latitude: user_lat, longitude: user_lng)), zoomLevel: 7, animated: false)
        //
        //            self.view.addSubview(mapView)
        //        }
        
        // 날씨 데이터 받아오기
        fetchWeather()
        
        // 응급구조함/병원 찾기 & 데이터저장
        FindRescue(lat: user_lat, lng: user_lng)
        FindHospital(lat: user_lat, lng: user_lng)
        
    }
    
    
    // 최단거리 응급구조함 5개 찾는 함수
    func FindRescue(lat: Double, lng: Double) {
        var arr: [rescue] = []
        for idx in 0..<Rescue_data.count {
            var rescue_add = Rescue_data[idx].FIELD4            // 주소
            var rescue_lat = Double(Rescue_data[idx].FIELD5)!   // 위도
            var rescue_lng = Rescue_data[idx].FIELD6            // 경도
            
            // 사용자로 부터 거리 계산
            var dist = CLLocation.distance(
                from: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                to: CLLocationCoordinate2D(latitude: rescue_lat, longitude: rescue_lng))
            dist = round((dist/1000.0) * 100) / 100.0
            
            arr.append(rescue(distance: Double(dist), address: rescue_add, latitude: rescue_lat, longitude: rescue_lng))
            /*
             여기서 많은 고민을 함.
             대안1 -> 딕셔너리로 [주소 : 거리]하자 -> 문제점: 최단거리 5개의 응급구조함에 대한 각 요소별 접근이 어려움.
             대안2 -> 리스트로 [주소,거리]로 초기화해서 값을 넣은다음 최단거리 5개만 뽑자. -> 문제점: 이중리스트는 항상 안에 같은 자료형들끼리만 가능함.
             결론: 구조체를 사용해서 해결.
             */
        }
        
        arr.sort()
        rescue_lst.append(contentsOf: arr[0...4])
    }
    
    // 인덱스와 거리데이터만 추출해서 sort?
    func FindHospital(lat: Double, lng: Double) {
        var arr2: [hospital] = []
        print(Hospital_data.count)
        
        for idx2 in 0..<Hospital_data.count {
            var dist2 = CLLocation.distance(
                from: CLLocationCoordinate2D(latitude: Hospital_data[idx2].위도, longitude: Hospital_data[idx2].경도),
                to: CLLocationCoordinate2D(latitude: lat, longitude: lng))
            dist2 = round((dist2/1000.0) * 100) / 100.0
            
            arr2.append(hospital(distance: Double(dist2), address: Hospital_data[idx2].소재지도로명주소, phone_num: Hospital_data[idx2].연락처, name: Hospital_data[idx2].의료기관명, latitude: Hospital_data[idx2].위도, longitude: Hospital_data[idx2].경도))
        }
        
        arr2.sort()
        hospital_lst.append(contentsOf: arr2[0...4])
    }
    
    // 지도에 마커추가 함수 **** 삭제
    // 추가 기능 구현 아이디어 : 마커 클릭시 해당 위치 비치된 응급구조함 사진 출력?
    //    func MakeMarker(number: Int, address: String, lat: Double, lng: Double) -> MTMapPOIItem {
    //
    //        let Marker = MTMapPOIItem()
    //        if number < 5 {
    //            Marker.itemName = "응급구조함 \(number+1)"
    //            Marker.markerType = .redPin }
    //        else {
    //            Marker.itemName = "\(hospital_lst[number-5].name)"
    //            Marker.markerType = .yellowPin }
    //        Marker.tag = number
    //        Marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(
    //            latitude: lat, longitude: lng))
    //        mapView.addPOIItems([Marker])
    //
    //        return Marker
    //    }
    
//    // 현위치 업데이트 메소드
//    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
//        if location != MTMapPoint(geoCoord: MTMapPointGeo(latitude: user_lat, longitude: user_lng)) {
//            let geocoder = MTMapReverseGeoCoder(mapPoint: location, with: self, withOpenAPIKey: kakao_apiKey)
//
//            self.geocoder = geocoder
//            geocoder?.startFindingAddress()
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate {
            user_lat = coor.latitude
            user_lng = coor.longitude
        }
    }
        
    // 트래킹모드에서 받아온 위도 경도 기반 주소 출력 메소드
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
        guard let addressString = addressString else { return }
        NowLocation.text = addressString
    }
        
        
    // 날씨 받아오는 함수.
    func fetchWeather() {
        forecast.getLoc(lat1: user_lat, lng1: user_lng)
        forecast.getWeather() { result in
            switch result {
            case.success(let weatherResponse):
                DispatchQueue.main.async {
                    self.NextWeather.append(contentsOf: weatherResponse.hourly[3...23])
                    
                    // 현재
                    self.currentWeather = weatherResponse.current
                    self.ConvertImg(Wtimg: self.WeatherImg!, Wtmain: (self.currentWeather?.weather[0].main)!)
                    self.WeatherUvi.text = "자외선 \(self.uvitoString(uvi: (self.currentWeather?.uvi)!))"
                    self.WeatherTemp.text = " \(self.currentWeather?.temp ?? 0.0)°"
                    
                    // 현재시간 기준 3~24시간후 날씨 정보중 물놀이하기 힘든 날씨예보가 존재하는지 확인
                    CheckWeather()
                    
                }
            case .failure(_ ):
                print("error")
            }
        }
        
        func CheckWeather() {
            var nextweathervalue: Hourly
            var badweathers = ["Thunderstorm", "Rain", "fog", "haze"]
            
            for idx in 0...20 {
                nextweathervalue = self.NextWeather[idx]
                
                if badweathers.contains(nextweathervalue.weather[0].main)  {
                    self.ConvertImg(Wtimg: self.WeatherNextImg!, Wtmain: nextweathervalue.weather[0].main)
                    self.WeatherNextTime.text = "\(idx)시간 뒤 날씨"
                    self.WeatherNextTemp.text = " \(nextweathervalue.temp ?? 0.0)°"
                } else {
                    self.WeatherNextTime = UILabel(frame: CGRect(x: 213, y: 40, width: 137, height: 21))
                    self.WeatherNextTime.text = "이후 맑거나 구름 예정"
                }
            }
        }
    }
    
    func ConvertImg(Wtimg: UIImageView!, Wtmain: String) {
        switch Wtmain
        {
        case "Thunderstorm":
            Wtimg.image = UIImage(systemName: "cloud.bolt.fill")
        case "drizzle":
            Wtimg.image = UIImage(systemName: "cloud.drizzle.fill")
        case "snow":
            Wtimg.image = UIImage(systemName: "cloud.snow.fill")
        case "Clear":
            Wtimg.image = UIImage(systemName: "sun.max.fill")
        case "Clouds":
            Wtimg.image = UIImage(systemName: "cloud.fill")
        case "Rain":
            Wtimg.image = UIImage(systemName: "cloud.rain.fill")
        case "fog":
            Wtimg.image = UIImage(systemName: "cloud.fog.fill")
        case "haze":
            Wtimg.image = UIImage(systemName: "sun.haze.fill")
        default:
            print(Wtmain)
            Wtimg.image = UIImage(systemName: "questionmark.circle.fill")
        }
    }
    
    func uvitoString(uvi: Double) -> String {
        var uvistr = ""
        
        switch uvi {
        case 0.0..<3.0:
            uvistr = "낮음"
        case 3.0..<6.0:
            uvistr = "보통"
        case 6.0..<8.0:
            uvistr = "높음"
        case 8.0..<11.0:
            uvistr = "매우높음"
        default:
            uvistr = "위험"
        }
        
        return uvistr
    }
    
    //    // 응급구조함 찾기 버튼 함수
    //    @IBAction func NaviStart(_ sender: Any) {
    //
    //        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC2") as? ViewController2 else {return }
    //        vc.hospitals = hospital_lst
    //        vc.rescues = rescue_lst
    //        vc.usr_lat = user_lat
    //        vc.usr_lng = user_lng
    //
    //        self.present(vc, animated: true, completion: nil)
    //    }
    
    @IBAction func ShowRescue(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC2") as? ViewController2 else {return }
        vc.rescues = rescue_lst
        vc.usr_lat = user_lat
        vc.usr_lng = user_lng
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func ShowHospital(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC2") as? ViewController2 else {return }
        vc.hospitals = hospital_lst
        vc.usr_lat = user_lat
        vc.usr_lng = user_lng
        vc.isRescue = false
        
        self.present(vc, animated: true, completion: nil)
    }
        
        //    // 현위치 트래킹 모드 버튼 함수
        //    @IBAction func TrackStart(_ sender: UIButton) {
        //        // 선택이 되어있지 않은 상태에서 클릭이 됬으므로
        //        // on 버튼은 조건에 !를 붙여줘야함.
        //        if !sender.isSelected {
        //            mapView.currentLocationTrackingMode = .onWithoutHeading
        //            mapView.showCurrentLocationMarker = true
        //
        //            TrackBtn.tintColor = UIColor(red: 108/255, green: 189/255, blue: 249/255, alpha: 1)
        //            // isselected를 true로 바꿔줌으로써 다시 클릭될때
        //            // else를 실행할수 있게 해줌.
        //            sender.isSelected = true
        //
        //        } else {
        //            mapView.currentLocationTrackingMode = .off
        //            mapView.showCurrentLocationMarker = false
        //            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
        //                latitude: user_lat, longitude: user_lng)), zoomLevel: 7, animated: true)
        //
        //            TrackBtn.tintColor = UIColor.blue
        //            sender.isSelected = false
        //        }
        //    }
}

// 좌표간 거리계산 메소드
extension CLLocation {
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
