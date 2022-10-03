//
//  CustomTabBarController.swift
//  FreeSubject
//
//  Created by 홍준혁 on 2022/08/28.
//

import Foundation
import UIKit
import SnapKit


class CustomTabBarController: UITabBarController{
    
    let homeVC = CalendarViewController()
    let statsVC = LineChartViewController()
    let connetVC = ConnectionViewController()
    let myInfoVC = MyInfoViewController()
    let plusVC = CustomModalViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyle()
    }
    


    func setUpStyle(){
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .systemGray
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
        homeVC.title = "홈"
        statsVC.title = "통계"
        myInfoVC.title = "사용자"
        connetVC.title = "연결"
        
        
        
        
        let ViewControllers:[UIViewController] = [homeVC,statsVC,connetVC,myInfoVC]
        // assign view controllers to tab bar
        self.setViewControllers(ViewControllers, animated: true)
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "house")
        
        let imageHome = UIImage(named: "house")
        let imageStats = UIImage(named: "note.text")
        let imageConnection = UIImage(named: "message")
        let imageMyInfo = UIImage(named: "person")
        guard let items = self.tabBar.items else {return}
        items[0].image = imageHome
        items[1].image = imageStats
        items[2].image = imageConnection
        items[3].image = imageMyInfo
        
        
        //네비게이션 뷰컨으로 푸쉬했을 때 밑에 바가 사라지지 않도록
        self.hidesBottomBarWhenPushed = false
    }
}

extension CALayer {
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
