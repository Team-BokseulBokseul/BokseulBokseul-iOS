//
//  LoginViewController.swift
//  FreeSubject
//
//  Created by qualson1 on 2022/10/05.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginBtn = UIButton().then {
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
        self.view.backgroundColor = UIColor.white
        setViewHierarchy()
        setConstraints()

    }
    
    private func setViewHierarchy() {
        view.addSubview(loginBtn)
    }
    
    private func setConstraints() {
        loginBtn.snp.makeConstraints {
            $0.height.equalTo(39)
            $0.leading.trailing.equalToSuperview().inset(127)
            $0.bottom.equalToSuperview().inset(151)
        }
    }
    
}
