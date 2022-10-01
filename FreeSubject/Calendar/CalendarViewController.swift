//
//  CalendarViewController.swift
//  FreeSubject
//
//  Created by 홍준혁 on 2022/08/27.

import Foundation
import SnapKit
import UIKit
import RealmSwift
import Then
import FSCalendar
import SwiftUI
import Charts



class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    // 실제 날짜
    let realTime = Date()

    let fsCalendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var selectedDate: Date = Date()
    let dateFormatter = DateFormatter()
    
    lazy var goToThisMonth:UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.uturn.left"), for: .normal)
        btn.addTarget(self, action: #selector(currentBtnClicked), for: .touchUpInside)
        btn.tintColor = .black
        btn.layer.cornerRadius = 16
        btn.backgroundColor = UIColor(red: 0.74, green: 0.86, blue: 0.79, alpha: 1.00)
        return btn
    }()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        setView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        setView()
    }
    
    func setView(){
        view.backgroundColor = .systemBackground
        view.addSubview(fsCalendar)
        view.addSubview(goToThisMonth)
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
//        resetDB()
        setSNP()
        
    }
    
    func setSNP(){
        calendarSetting()
        fsCalendar.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(140)
            make.bottom.equalToSuperview().offset(-200)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        
        }
        goToThisMonth.snp.makeConstraints{ make in
            make.top.equalTo(fsCalendar).inset(10)
            make.trailing.equalTo(fsCalendar).inset(15)
            make.width.equalTo(34)
            make.height.equalTo(34)
        }

    }
    
    func calendarSetting(){
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0.0  //양 옆 글자 투명도
        fsCalendar.dataSource = self
        fsCalendar.delegate = self
        fsCalendar.locale = Locale(identifier: "ko_KR")
        fsCalendar.scrollEnabled = true
        fsCalendar.appearance.weekdayTextColor = .black
        fsCalendar.appearance.headerTitleColor = .black
        fsCalendar.appearance.eventDefaultColor = UIColor.green
        fsCalendar.appearance.eventSelectionColor = UIColor.green
        fsCalendar.appearance.headerDateFormat = "MM월 YYYY년"
        fsCalendar.appearance.todayColor = UIColor(red: 0.47, green: 0.86, blue: 0.63, alpha: 1.0)
        // font
        fsCalendar.appearance.headerTitleFont = UIFont(name: "Avenir-Black", size: 22)
    }
    
    // 날짜 선택 -> 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let isThisToday: Bool = isToday(calendarDate: date, todayDate: self.realTime)
        dateFormatter.dateFormat = "YYYYMMdd"
        presentModalController(inputDate: dateFormatter.string(from: date), isThisToday: isThisToday)
        
    }
    // 캘린더의 선택한 날과 실제 날짜를 비교해서 Bool 값 리턴
    func isToday(calendarDate:Date,todayDate:Date)->Bool{
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let a = dateFormatter.string(from: calendarDate)
        let b = dateFormatter.string(from: todayDate)
        if(a == b){
            return true
        }
        else{
            return false
        }
    }
    
    
    // To be updated
    func presentModalController(inputDate:String,isThisToday:Bool) {
        let vc = CustomModalViewController()
        vc.Date = inputDate
        vc.isToday = isThisToday
        vc.modalPresentationStyle = .overCurrentContext
        // keep false
        // modal animation will be handled in VC itself
        self.present(vc, animated: false)
    }

    // 현재 달로 돌아오기 위한 함수
    @objc func currentBtnClicked(sender: UIButton!) {
        print(Date())   // 실제 오늘 날짜가 출력됨.
        self.fsCalendar.setCurrentPage(Date(), animated: true)
    }
    
    
    // 아예 Realm 파일 삭제 Realm 의 요소들을 변경하면 한번씩 해줘야 한다...
    func resetDB(){
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
          realmURL,
          realmURL.appendingPathExtension("lock"),
          realmURL.appendingPathExtension("note"),
          realmURL.appendingPathExtension("management")
        ]

        for URL in realmURLs {
          do {
            try FileManager.default.removeItem(at: URL)
          } catch {
            // handle error
          }
        }
    }

    
    
    
    
}
