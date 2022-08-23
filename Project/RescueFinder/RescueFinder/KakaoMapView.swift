import UIKit
import CoreLocation

class KakaoMapView: UIViewController, MTMapViewDelegate {
    
    let Rescue_data = DataLoader().rescue_data
    var locationManager = CLLocationManager()
    var mapView: MTMapView!
    var geocoder: MTMapReverseGeoCoder!
    public var lat: Double?
    public var lng: Double?
    var adress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Frame = CGRect(x: 20, y: 80, width: 355, height: 540)
        mapView = MTMapView(frame: Frame)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            self.view.addSubview(mapView)
        }
        
        if let openApp = URL(string: "KakaoMap://"), UIApplication.shared.canOpenURL(openApp) {
            UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
        } else {
            if let openStore = URL(string: "itms-apps://itunes.apple.com/app/AppleID"), UIApplication.shared.canOpenURL(openStore) {
                UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
            }
        }

        
        
//            let currentLoc = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLng)
//            let rescue_inform = FindRescue(Loc1: currentLoc)
//            let rescue_loc = rescue_inform.1
//            let rescue_add = rescue_inform.0
//            let rescue_lat = rescue_loc.latitude
//            let rescue_lng = rescue_loc.longitude
//
            
            
            
            
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
    
    
//    func FindRescue(Loc1: CLLocationCoordinate2D) -> (String, CLLocationCoordinate2D) {
//        var result = 10000000000.0
//        var address: String = ""
//        var Loc2 = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//
//        for idx in 1..<Rescue_data.count {
//            var rescue_lat = Double(Rescue_data[idx].FIELD5)!
//            var rescue_lng = Rescue_data[idx].FIELD6
//            var dist = CLLocation.distance(from: Loc1, to: CLLocationCoordinate2D(latitude: rescue_lat, longitude: rescue_lng))
//            if dist < result {
//                result = dist
//                Loc2.latitude = rescue_lat
//                Loc2.longitude = rescue_lng
//                address = Rescue_data[idx].FIELD4
//            }
//        }
//        return (address, Loc2)
//    }
    
    func CanOpenURL
}

                                
extension CLLocation {
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
