//
//  EmotionalCheckView.swift
//  FreeSubject
//
//  Created by qualson1 on 2022/08/31.
//

import UIKit
import SnapKit
import Then

protocol EmotionalCheckDelegate: AnyObject {
    func emotionalCheck(emotional:Bool)
}

class EmotionalCheckView: UIView {
    
    var emotionalCheck : Bool = false
    
    weak var delegate: EmotionalCheckDelegate?
    
    private let titleLabel = UILabel().then {
        $0.text = "하루 동안 유의미한 감정 기복이 있었어?"
        $0.font = UIFont(name: "Avenir-Black", size: 14)
    }
    
     let emotionalCheckSwitch = UISwitch().then {
        //$0.isOn = true
        $0.thumbTintColor = UIColor.white
        $0.onTintColor = UIColor.customColor(.UISwitchColor)
        $0.addTarget(self, action: #selector(onClickSwitch(sender:)), for: .valueChanged)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.layer.backgroundColor = UIColor.customColor(.brandColor).cgColor
        self.layer.cornerRadius = 12
        setViewHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onClickSwitch(sender: UISwitch) {
        //emotionalCheck = sender.isOn
        self.delegate?.emotionalCheck(emotional: sender.isOn)
        print(sender.isOn)
    }
   
    
    private func setViewHierarchy() {
        addSubview(titleLabel)
        addSubview(emotionalCheckSwitch)
    }
        
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.bottom.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(13)
        }
        
        emotionalCheckSwitch.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(6)
        }
        
    }

}
