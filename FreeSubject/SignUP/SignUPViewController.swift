//
//  SignUPViewController.swift
//  FreeSubject
//
//  Created by qualson1 on 2022/10/05.
//

import UIKit
import SnapKit
import Then

class SignUPViewController: UIViewController {
    
    private let titleView = UIView().then {
        $0.layer.backgroundColor = UIColor(red: 0.106, green: 0.294, blue: 0.4, alpha: 0.5).cgColor
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customColor(.brandColor).cgColor
        $0.layer.cornerRadius = 10
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = UIColor.white
        $0.font = UIFont(name: "Inter-Bold", size: 23)
    }
    
    private let signUPBtn = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customColor(.brandColor).cgColor
        $0.setBackgroundColor(.customColor(.brandColor), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Inter-Bold", size: 30)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViewHierarchy()
        setConstraints()

    }
    
    private func setViewHierarchy() {
        view.addSubviews(titleView, signUPBtn)
        titleView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(9)
            $0.centerY.equalToSuperview().inset(75)
        }
        
        titleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(75)
            $0.top.equalToSuperview().inset(80)
            $0.height.equalTo(46)
        }
        
        signUPBtn.snp.makeConstraints {
            $0.height.equalTo(39)
            $0.leading.trailing.equalToSuperview().inset(127)
            $0.bottom.equalToSuperview().inset(151)
        }
    }
}
