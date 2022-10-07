//
//  ViewController2.swift
//  RescueFinder2
//
//  Created by 1 on 2022/09/01.
//

import Foundation
import UIKit
import MapKit

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let Geocoder = CLGeocoder()
    let VC1 = KakaoMapView2()
    var rescues: [rescue] = []
    var hospitals: [hospital] = []
    var isRescue = true
    
    @IBOutlet var NowLocation: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell", for: indexPath) as? CustomCell else {
             return UITableViewCell()
         }
        if !isRescue {
            cell.Current_add.text = hospitals[indexPath.row].name
            cell.from_distance.text = "거리: 약 \(hospitals[indexPath.row].distance)km"
            cell.Rescue_add.text = hospitals[indexPath.row].address
        } else {
            cell.Current_add.text = "응급구조함 \(indexPath.row + 1)"
            cell.from_distance.text = "거리: 약" + String(rescues[indexPath.row].distance) + "km"
            cell.Rescue_add.text = rescues[indexPath.row].address
        }
        
         return cell
    }
    
    // 테이블 뷰셀 높이 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //테이블뷰의 이벤트처리 함수
        var user_url = "\(user_lat),\(user_lng)"
        var destin_url: String = ""
        var total_url: String = ""
        if isRescue {
            destin_url = "\(rescues[indexPath.row].latitude),\(rescues[indexPath.row].longitude)"
            total_url = "kakaomap://route?sp=\(user_url)&ep=\(destin_url)&by=FOOT"
            
        } else {
            destin_url = String(hospitals[indexPath.row].latitude) + "," + String(hospitals[indexPath.row].longitude)
            total_url = "kakaomap://route?sp=\(user_url)&ep=\(destin_url)&by=CAR"
        }
        
        if let openApp = URL(string: total_url), UIApplication.shared.canOpenURL(openApp) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(openApp, options: [:], completionHandler: nil) }
            else { UIApplication.shared.open(openApp)}
            
        } else {
            if let openStore = URL(string: "itms-apps://itunes.apple.com/app/id304608425"), UIApplication.shared.canOpenURL(openStore) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
                } else { UIApplication.shared.open(openStore) }
            }
        }
    }
}

class CustomCell: UITableViewCell {
    @IBOutlet var Current_add: UILabel!
    @IBOutlet var from_distance: UILabel!
    @IBOutlet var Rescue_add: UILabel!
    @IBOutlet var NaviBtn: UIButton!
}
