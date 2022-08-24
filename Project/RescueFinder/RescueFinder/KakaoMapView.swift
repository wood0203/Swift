import UIKit
import CoreLocation

class KakaoMapView: UIViewController, CLLocationManagerDelegate, MTMapViewDelegate {
    
    let Rescue_data = DataLoader().rescue_data
    
    var mapView: MTMapView!
    var mapPoint1: MTMapPoint?
    var geocoder: MTMapReverseGeoCoder!
    var Marker1: MTMapPOIItem!
    var Marker2: MTMapPOIItem!
    var Rescue_loc: [Double] = []
    public var user_lat: Double = 0
    public var user_lng: Double = 0
    
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
        
        let Frame = CGRect(x: 20, y: 80, width: 355, height: 540)
        mapView = MTMapView(frame: Frame)
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard

            self.view.addSubview(mapView)
        }
                
        Rescue_loc = FindRescue(lat: user_lat, lng: user_lng)
        
        Marker1 = MTMapPOIItem()
        Marker1.itemName="현위치"
        Marker1.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: user_lat, longitude: user_lng))
        Marker1.markerType = .bluePin
        
        Marker2 = MTMapPOIItem()
        Marker2.itemName="응급구조함"
        Marker2.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: Rescue_loc[0], longitude: Rescue_loc[1]))
        Marker2.markerType = .redPin
        
        mapView.addPOIItems([Marker1, Marker2])
        mapView.fitAreaToShowAllPOIItems()
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
        print("위도: \(latit) 경도: \(longit)")
        return [latit, longit]
        
    }

}


extension CLLocation {
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
