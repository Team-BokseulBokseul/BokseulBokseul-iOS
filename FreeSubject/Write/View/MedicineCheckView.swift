//
//  MedicineCheckView.swift
//  FreeSubject
//
//  Created by qualson1 on 2022/08/31.
//

import UIKit
import SnapKit
import Then

protocol MedicineCheckDelegate: AnyObject {
    func medicineCheckEnabledSaveBtn(medicine: Bool)
}

class MedicineCheckView: UIView {
    
    weak var delegate: MedicineCheckDelegate?
    
    private let titleLabel = UILabel().then {
        $0.text = "약 복용"
        $0.font = UIFont(name: "Avenir-Black", size: 14)
    }
    
    lazy var takingMedicineButton = UIButton().then {
        $0.setImage(UIImage(named: "약복용"), for: .normal)
        $0.layer.cornerRadius =  24.5
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(onClickMedicineBtn(sender:)), for: .touchUpInside)
    }
    
    lazy var notTakingMedicineButton = UIButton().then {
        $0.setImage(UIImage(named: "약미복용"), for: .normal)
        $0.layer.cornerRadius = 24.5
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(onClickMedicineBtn(sender:)), for: .touchUpInside)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 14
        $0.distribution = .fillEqually
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
    
    private func setViewHierarchy() {
        addSubview(titleLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(notTakingMedicineButton)
        stackView.addArrangedSubview(takingMedicineButton)
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(8.84)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(58)
            $0.trailing.equalToSuperview().inset(7)
        }
        
    }
    
    @objc func onClickMedicineBtn(sender: UIButton) {
        switch sender {
        case takingMedicineButton:
            
            takingMedicineButton.layer.borderWidth = 3
            takingMedicineButton.layer.borderColor = UIColor.black.cgColor
            
            notTakingMedicineButton.layer.borderWidth = 0
            
            self.delegate?.medicineCheckEnabledSaveBtn(medicine: true)
           
            
        case notTakingMedicineButton:
            
            notTakingMedicineButton.layer.borderWidth = 3
            notTakingMedicineButton.layer.borderColor = UIColor.black.cgColor
            
            takingMedicineButton.layer.borderWidth = 0
        
            self.delegate?.medicineCheckEnabledSaveBtn(medicine: false)
            
        default:
            print("Error")
        }
    }
}
