//import Foundation
//import UIKit
//import CoreLocation
//
//class KakaoMapView: UIViewController, CLLocationManagerDelegate {
//    
//    var locationManager = CLLocationManager()
//    var BtnIndex: Int?
//    
//    // 도보, 자동차 라디오버튼
//    @IBOutlet var TransportBtn: [UIButton]!
//    @IBOutlet var NaviBtn: UIButton!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // 응급구조함 위치 데이터 로드
////        let Rescue_data = DataLoader().rescue_data
////        print(Rescue_data[0])
//        
//        // 델리게이트 설정
//        locationManager.delegate = self
//        // 거리 정확도 설정
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        // 사용자에게 허용 받기 alert 띄우기
//        locationManager.requestWhenInUseAuthorization()
//        
//        let settings = UIUserNotificationSettings(types: [.alert], categories: nil)
//        UIApplication.shared.registerUserNotificationSettings(settings)
//        
//        if CLLocationManager.locationServicesEnabled() {
//            print("위치 서비스 On 상태")
//            
//            var currentLat = locationManager.location?.coordinate.latitude ?? 0
//            var currentLng = locationManager.location?.coordinate.longitude ?? 0
//            print("경도: \(currentLat) 위도: \(currentLng)")
//            
//        }
//        
//        
//    }
//    
//    @IBAction func NaviBtn(_ sender: UIButton) {
//        performSegue(withIdentifier: "to_2nd_page", sender: sender)
//        
//    }
//    
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
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
//    }
//    
//    func FindRescue(data: [String]) {
//        
//        for idx in 0..<data.count {
//            print("\(data[idx])")
//        }
//    }
//    
//}
