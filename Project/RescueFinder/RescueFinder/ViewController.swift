import UIKit
import MapKit

// 앱 시작과 동시에 위치서비스 켤지 창을 띄워줌 -> 런치스크린 종료시 맵에 현재위치를 띄움.
// -> 제일 가까운 곳을 핀포인트 찍고, 가까운 인명구조함 위치를 맵 바로밑에 보여줌.
// + 최단거리 인명구조함까지 길찾기 기능? 일기예보상 비 있으면 알림 푸시 제공.


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var FinderBtn: UIButton!
    // !를 붙여서 옵셔널 해제.
    
    
    
    // 네비게이션 버튼 동작 후 세번째 페이지
    
    // var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 델리게이트 설정
//        locationManager.delegate = self
//        // 거리 정확도 설정
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        // 사용자에게 허용 받기 alert 띄움.
//        locationManager.requestWhenInUseAuthorization()
        
        // 아이폰 설정에서의 위치 서비스가 켜진 상태일 때
//        if CLLocationManager.locationServicesEnabled() {
//            print("위치 서비스 On 상태")
//            locationManager.startUpdatingLocation() //위치정보 받아오기 시작
//            print(locationManager.location?.coordinate)
//        } else {
//            print("위치 서비스 Off 상태")
//        }
    }
    // 위치 정보 계속 업데이트해서 위도 경도 받아옴.
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> (Double, Double) {
//        print("didUpdateLocations")
//        if let location = locations.first {
//            var lat = location.coordinate.latitude
//            var long = location.coordinate.longitude
//            print("위도: \(location.coordinate.latitude)")
//            print("경도: \(location.coordinate.longitude)")
//            return (lat, long)
//        }
//        return (1.0,1.0)
//    }
//
//    // 위치 경도 받아오기 에러
//    func locationManger(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
    }



