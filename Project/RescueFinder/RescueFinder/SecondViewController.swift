//
//  SecondViewController.swift
//  RescueFinder
//
//  Created by 1 on 2022/08/16.
//

import Foundation
import UIKit
import MapKit

class SecondViewController: UIViewController {
    
    @IBOutlet var NavigationBtn: UIButton!
    @IBOutlet var Map1: MKMapView!
    
    @IBAction func Back(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func Navigation(_ sender: Any) {
        guard let uvc2 = self.storyboard?.instantiateViewController(withIdentifier: "ThirdVC") else {
            return
        }
        
        // 화면 전환할 때의 애니메이션 타입
        uvc2.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        // 인자값으로 뷰 컨트롤러 인스턴스를 넣고 프레젠트 메소드 호출
        self.present(uvc2,animated: true)
    }
    
}
