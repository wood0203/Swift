import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var latit: Double?
    var longit: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 응급구조함 위치 데이터 로드
        let Rescue_data = DataLoader().rescue_data
        
        // 델리게이트 설정
        locationManager.delegate = self
        // 거리 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 허용 받기 alert 띄우기
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate)
        } else {
            print("위치 서비스 Off 상태")
        }
        
    }
    
    // 위치 정보 계속 업데이트해서 위도 경도 받아옴.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("didUpdateLocations")
        if let location = locations.first {
            latit = location.coordinate.latitude
            longit = location.coordinate.longitude
            print("위도: \(latit)")
            print("경도: \(longit)")
        }
            
    }
    
    // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
 
//            let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//
//            let marker = GMSMarker()
//            marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//            marker.title = "Sydney"
//            marker.snippet = "Australia"
//            marker.map = mapView
        
        // Do any additional setup after loading the view.
        
