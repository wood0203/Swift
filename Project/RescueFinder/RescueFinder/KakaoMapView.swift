import UIKit
import CoreLocation

class KakaoMapView: UIViewController, CLLocationManagerDelegate, MTMapViewDelegate {
    
    let Rescue_data = DataLoader().rescue_data
    
    var mapView: MTMapView!
    var mapPoint1: MTMapPoint?
    var geocoder: MTMapReverseGeoCoder!
    
    var Rescue_loc: [Double] = []
    public var user_lat: Double! = 0
    public var user_lng: Double! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            print("위치 서비스 off 상태")
        }
        
        user_lat = locationManager.location?.coordinate.latitude
        user_lng = locationManager.location?.coordinate.longitude
        
        let Frame = CGRect(x: 20, y: 110, width: 355, height: 540)
        mapView = MTMapView(frame: Frame)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
                latitude: user_lat, longitude: user_lng)), zoomLevel: 8, animated: true)
            
            self.view.addSubview(mapView)
        }
                
        Rescue_loc = FindRescue(lat: user_lat, lng: user_lng)
        
        let Marker1 = MTMapPOIItem()
        Marker1.itemName="현위치"
        Marker1.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: user_lat, longitude: user_lng))
        Marker1.markerType = .bluePin
        
        let Marker2 = MTMapPOIItem()
        Marker2.itemName="응급구조함"
        Marker2.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: Rescue_loc[0], longitude: Rescue_loc[1]))
        Marker2.markerType = .redPin
        
        mapView.addPOIItems([Marker1])
        mapView.addPOIItems([Marker2])
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
    
    @IBAction func NaviStart(_ sender: Any) {
        var user_url = String(user_lat) + "," + String(user_lng)
        var rescue_url = String(Rescue_loc[0]) + "," + String(Rescue_loc[1])
        var total_url = "kakaomap://route?sp=" + user_url + "&ep=" + rescue_url + "&by=FOOT"

        if let openApp = URL(string: total_url), UIApplication.shared.canOpenURL(openApp) {
            UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
            
        } else {
            if let openStore = URL(string: "itms-apps://itunes.apple.com/app/kakaomap"),
               UIApplication.shared.canOpenURL(openStore) {
                UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
            }
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
