import UIKit
import CoreLocation

//"0640b95f418fe69e7c7a882c71d17482"


class KakaoMapView: UIViewController, CLLocationManagerDelegate, MTMapViewDelegate, MTMapReverseGeoCoderDelegate {
    
    let Rescue_data = DataLoader().rescue_data
    
    var mapView: MTMapView!
    var mapPoint1: MTMapPoint?
    var geocoder: MTMapReverseGeoCoder!
    var forecast: WeatherService!
    
    public var user_lat: Double = 0     // 사용자 위도, 경도, 위치 주소
    public var user_lng: Double = 0
    var user_address: String = ""
    var rescue_lst: [rescue] = []       // 최단거리 5개 응급구조함 배열
    
    var currentWeather: Current?
    var hourWeather: Hourly?
    var temperature: Double = 0.0
    var icon: String = ""
    var hour_weather: String = ""
    let weatherLabel = UILabel()
    let weatherImage = UIImageView()
    
    @IBOutlet var NowLocation: UILabel!
    @IBOutlet var FindBtn: UIButton! // 응급구조함 검색 버튼
    @IBOutlet var TrackBtn: UIButton! // 트래킹 모드 버튼
    @IBOutlet var WeatherView: UIView!
    @IBOutlet var RainNoticeBtn: UIButton! // 우천 알림 버튼
    @IBOutlet var WeatherImg: UIImageView!
    @IBOutlet var WeatherTemp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else { print("위치 서비스 off 상태") }
        
        user_lat = (locationManager.location?.coordinate.latitude)!
        user_lng = (locationManager.location?.coordinate.longitude)!
        
        let Frame = CGRect(x: 16, y: 164, width: 358, height: 549)
        mapView = MTMapView(frame: Frame)
        if let mapView = mapView {
            // 델리게이트 설정이 여러개가 가능한가?
            mapView.delegate = self
            mapView.baseMapType = .standard
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
                latitude: user_lat, longitude: user_lng)), zoomLevel: 7, animated: false)
            
            self.view.addSubview(mapView)
        }
        
        // 응급구조함 찾기 실행
        FindRescue(lat: user_lat, lng: user_lng)
        
        // 지도에 마커 추가 실행
        for i in 0..<5 {
            MakeMarker(number: i, address: rescue_lst[i].address,
                lat: rescue_lst[i].latitude, lng: rescue_lst[i].longitude) }
        
        
        forecast = WeatherService(lat: round(user_lat * 100)/100.0, lng: round(user_lng*100)/100.0)
        fetchWeather()
        
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
    
    
    // 지도에 마커추가 함수
    // 추가 기능 구현 아이디어 : 마커 클릭시 해당 위치 비치된 응급구조함 사진 출력?
    func MakeMarker(number: Int, address: String, lat: Double, lng: Double) -> MTMapPOIItem {
        
        let Marker = MTMapPOIItem()
        Marker.itemName = String(number+1) + "번째"
        Marker.tag = number
        Marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: lat, longitude: lng))
        Marker.markerType = .bluePin
        mapView.addPOIItems([Marker])
        
        return Marker
    }
    
    // 현위치 업데이트 메소드
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let geocoder = MTMapReverseGeoCoder(mapPoint: location, with: self, withOpenAPIKey: "30d0d841c02f99a1f94f7af2c54bee9f")
        
        self.geocoder = geocoder
        geocoder?.startFindingAddress()
    }
    
    
    // 트래킹모드에서 받아온 위도 경도 기반 주소 출력 메소드
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
        guard let addressString = addressString else { return }
        NowLocation.text = addressString
    }
    
    
    // 날씨 받아오는 함수.
    func fetchWeather() {
        forecast.getWeather { result in
            switch result {
                case.success(let weatherResponse):
                    DispatchQueue.main.async {
                        self.currentWeather = weatherResponse.current
                        self.WeatherTemp.text = String(self.currentWeather?.temp ?? 0.0)
                        self.WeatherImg.image = UIImage(named: self.currentWeather?.weather[0].icon ?? "01d")!
                        self.hourWeather = weatherResponse.hourly
                        self.hour_weather = self.hourWeather?.hourly_weather[0].main ?? "데이터 없음" }
                        print(self.hourWeather)
                
                case .failure(_ ):
                    print("error")
            }
        }
    }
    
    
    // 응급구조함 찾기 버튼 함수
    @IBAction func NaviStart(_ sender: Any) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC2") as? ViewController2 else {return }
        vc.rescues = rescue_lst
        vc.usr_lat = user_lat
        vc.usr_lng = user_lng
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    // 현위치 트래킹 모드 버튼 함수
    @IBAction func TrackStart(_ sender: UIButton) {
        // 선택이 되어있지 않은 상태에서 클릭이 됬으므로
        // on 버튼은 조건에 !를 붙여줘야함.
        if !sender.isSelected {
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            
            TrackBtn.tintColor = UIColor(red: 108/255, green: 189/255, blue: 249/255, alpha: 1)
            // isselected를 true로 바꿔줌으로써 다시 클릭될때
            // else를 실행할수 있게 해줌.
            sender.isSelected = true
            
        } else {
            mapView.currentLocationTrackingMode = .off
            mapView.showCurrentLocationMarker = false
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
                latitude: user_lat, longitude: user_lng)), zoomLevel: 7, animated: true)
            
            TrackBtn.tintColor = UIColor.blue
            sender.isSelected = false
        }
    }
}


extension CLLocation {
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}


struct rescue: Comparable {
    var distance: Double
    var address: String
    var latitude: Double
    var longitude: Double
    
    static func < (lhs: rescue, rhs: rescue) -> Bool {
        return lhs.distance < rhs.distance
    }
}
