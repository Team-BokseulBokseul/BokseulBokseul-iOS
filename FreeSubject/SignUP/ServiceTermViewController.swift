//
//  ServiceTermViewController.swift
//  FreeSubject
//
//  Created by qualson1 on 2022/10/05.
//

import UIKit

class ServiceTermViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "복슬복슬 서비스 이용을 위해 약관에 동의하세요. "
        $0.font = UIFont(name: "Inter-Medium", size: 40)
        $0.textColor = UIColor.customColor(.brandColor)
        $0.numberOfLines = 2
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let nextBtn = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customColor(.brandColor).cgColor
        $0.setBackgroundColor(.customColor(.brandColor), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Inter-Bold", size: 30)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(nextBtnTap), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViewHierarchy()
        setConstraints()

    }
    
    private func setViewHierarchy() {
        view.addSubviews(titleLabel, nextBtn)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(73)
        }
        
        nextBtn.snp.makeConstraints {
            $0.height.equalTo(39)
            $0.leading.trailing.equalToSuperview().inset(127)
            $0.bottom.equalToSuperview().inset(151)
        }
        
    
    }
    
    @objc func nextBtnTap() {
        let newViewController = SignUPViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
 
}
