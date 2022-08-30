import UIKit
import CoreLocation

class KakaoMapView: UIViewController, CLLocationManagerDelegate, MTMapViewDelegate {
    
    let Rescue_data = DataLoader().rescue_data
    
    var mapView: MTMapView!
    var mapPoint1: MTMapPoint?
    var geocoder: MTMapReverseGeoCoder!
    
    var Rescue_loc: [Double] = []
    public var user_lat: Double = 0
    public var user_lng: Double = 0
    
    @IBOutlet var NaviBtn: UIButton!
    @IBOutlet var TrackBtn: UIButton!
    @IBOutlet var RainNoticeBtn: UIButton!
    @IBOutlet var t1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            print("위치 서비스 off 상태")
        }
        
        user_lat = (locationManager.location?.coordinate.latitude)!
        user_lng = (locationManager.location?.coordinate.longitude)!
        
        let Frame = CGRect(x: 16, y: 93, width: 358, height: 549)
        mapView = MTMapView(frame: Frame)
        if let mapView = mapView {
            
            mapView.delegate = self
            mapView.baseMapType = .standard
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
                latitude: user_lat, longitude: user_lng)), zoomLevel: 7, animated: false)
            
            self.view.addSubview(mapView)
        }
        
        
        let Marker1 = MTMapPOIItem()
        Marker1.itemName="현위치"
        Marker1.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: user_lat, longitude: user_lng))
        Marker1.markerType = .bluePin
        
        Rescue_loc = FindRescue(lat: user_lat, lng: user_lng)
        
        let Marker2 = MTMapPOIItem()
        Marker2.itemName="응급구조함"
        Marker2.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: Rescue_loc[0], longitude: Rescue_loc[1]))
        Marker2.markerType = .redPin
        
        mapView.addPOIItems([Marker1])
        mapView.addPOIItems([Marker2])
//        mapView.fitAreaToShowAllPOIItems()
    }
    
    func FindRescue(lat: Double, lng: Double) -> [Double] {
        var result = 10000000000.0
        var latit: Double = 0
        var longit: Double = 0
        for idx in 0..<Rescue_data.count {
            var rescue_lat = Double(Rescue_data[idx].FIELD5)!
            var rescue_lng = Rescue_data[idx].FIELD6
            var dist = CLLocation.distance(
                from: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                to: CLLocationCoordinate2D(latitude: rescue_lat, longitude: rescue_lng))
            if dist < result {
                result = dist
                latit = rescue_lat
                longit = rescue_lng
            }
        }
//        print("위도: \(latit) 경도: \(longit)")
        return [latit, longit]
    }
    
    @IBAction func NaviStart(_ sender: UIButton) {
        
        var user_url = String(user_lat) + "," + String(user_lng)
        var rescue_url = String(Rescue_loc[0]) + "," + String(Rescue_loc[1])
        var total_url = "kakaomap://route?sp=" + user_url + "&ep=" + rescue_url + "&by=FOOT"
        
        if let openApp = URL(string: total_url), UIApplication.shared.canOpenURL(openApp) {

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(openApp)
            }
            
        }
        
        else {
            if let openStore = URL(string: "itms-apps://itunes.apple.com/app/id304608425"), UIApplication.shared.canOpenURL(openStore) {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
                }
                else {
                    UIApplication.shared.openURL(openStore)
                }
            }
        }
    }
    
    
    @IBAction func TrackStart(_ sender: UIButton) {
        
        // 선택이 되어있지 않은 상태에서 클릭이 됬으므로
        // on 버튼은 조건에 !를 붙여줘야함.
        if !sender.isSelected {
            t1.text = "12312312313"
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            
            TrackBtn.tintColor = UIColor(red: 108/255, green: 189/255, blue: 249/255, alpha: 1)
            // isselected를 true로 바꿔줌으로써 다시 클릭될때
            // else를 실행할수 있게 해줌.
            sender.isSelected = true
        }
        
        else {
            t1.text = "89980890890"
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
