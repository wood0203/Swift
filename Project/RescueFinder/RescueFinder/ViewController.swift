import UIKit
import CoreLocation
import MapKit

//class SearchViewController: UIViewController {
//    var RescueList : [[String]] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.loadFromCSV()
//    }
//
//    private func parseCSVAt(url: URL) {
//        do {
//            let data = try Data(contentsOf: url)
//            let dataEncoded = String(data: data, encoding: .utf8)
//            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
//                for item in dataArr {
//                    RescueList.append(item)
//                }
//            }
//
//        } catch {
//            print("Error reading CSV file")
//        }
//    }
//
//    private func loadFromCSV() {
//        let path = Bundle.main.path(forResource: "Kangwondo_Rescue2", ofType: "csv")!
//        parseCSVAt(url: URL(fileURLWithPath: path))
//    }
//
//}


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var LocatinFinder: UIButton!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 델리게이트 설정
        locationManager.delegate = self
        // 거리 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 허용 받기 alert 띄움.
        locationManager.requestWhenInUseAuthorization()
        
        // 아이폰 설정에서의 위치 서비스가 켜진 상태일 때
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation() //위치정보 받아오기 시작
            print(locationManager.location?.coordinate)
        } else {
            print("위치 서비스 Off 상태")
        }
    }
    // 위치 정보 계속 업데이트해서 위도 경도 받아옴.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
        }
    }
    
    // 위치 경도 받아오기 에러
    func locationManger(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}

