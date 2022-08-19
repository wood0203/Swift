import UIKit
import GoogleMaps
import CoreLocation

class GoogleMapView: UIViewController, CLLocationManagerDelegate {
    
    // 응급구조함 위치 데이터 로드
    let Rescue_data = DataLoader().rescue_data

    var locationManager = CLLocationManager()
    
    //var BtnIndex: Int?
    
    // 도보, 자동차 라디오버튼
    @IBOutlet var TransportBtn: [UIButton]!
    @IBOutlet var NaviBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 델리게이트 설정
        locationManager.delegate = self
        // 거리 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 허용 받기 alert 띄우기
        locationManager.requestWhenInUseAuthorization()

        let settings = UIUserNotificationSettings(types: [.alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)

        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")

            var currentLat = locationManager.location?.coordinate.latitude ?? 0
            var currentLng = locationManager.location?.coordinate.longitude ?? 0
            print("경도: \(currentLat) 위도: \(currentLng)")

            let camera = GMSCameraPosition(latitude: currentLat, longitude: currentLng, zoom: 9)
            let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
            self.view = mapView
                
            let currentLoc = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLng)
            let rescue_inform = FindRescue(Loc1: currentLoc)
            let rescue_loc = rescue_inform.1
            let rescue_add = rescue_inform.0
            
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLng)
            marker.title = "현재 위치"
            marker.map = mapView
            
            let marker2 = GMSMarker()
            marker2.position = CLLocationCoordinate2D(latitude: rescue_loc.latitude, longitude: rescue_loc.longitude)
            marker2.title = "응급구조함 위치"
            marker2.map = mapView
            
        }
        
        
    }
    
    @IBAction func NaviBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "to_2nd_page", sender: sender)
        
    }
    
//    @IBAction func touchBtn(_ sender: UIButton) {
//        // 이미 버튼이 선택되어 있는 경우
//        if BtnIndex != nil {
//
//            // 새로운 버튼 선택
//            if !sender.isSelected {
//                for index in 0...1 {
//                    TransportBtn[index].isSelected = false
//                }
//                sender.isSelected = true
//                BtnIndex = TransportBtn.firstIndex(of: sender)
//
//                    // 기존 선택된 버튼 선택
//                } else {
//                    sender.isSelected = false
//                    BtnIndex = nil
//                    }
//
//            // 버튼이 선택되어 있지 않는 경우
//        } else {
//            sender.isSelected = true
//            BtnIndex = TransportBtn.firstIndex(of: sender)
//        }
//    }
    
    
    func FindRescue(Loc1: CLLocationCoordinate2D) -> (String, CLLocationCoordinate2D) {
        var result = 10000000000.0
        var address: String = ""
        var Loc2 = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        for idx in 1..<Rescue_data.count {
            var rescue_lat = Double(Rescue_data[idx].FIELD5)!
            var rescue_lng = Rescue_data[idx].FIELD6
            var Loc2 = CLLocationCoordinate2D(latitude: rescue_lat, longitude: rescue_lng)
            var dist = CLLocation.distance(from: Loc1, to: Loc2)
            if dist < result {
                result = dist
                address = Rescue_data[idx].FIELD4
            }
        }
        return (address, Loc2)
    }
    
    func addMarker() {
        
    }
    
}

extension CLLocation {
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
