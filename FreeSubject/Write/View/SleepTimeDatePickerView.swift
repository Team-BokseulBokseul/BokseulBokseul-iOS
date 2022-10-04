//
//  sleepTimeDatePickerView.swift
//  FreeSubject
//
//  Created by qualson1 on 2022/08/30.
//

import UIKit
import SnapKit
import Then

protocol SleepTimeCheckDelegate: AnyObject {
    func SleepTimeCheckEnabledSaveBtn(sleepTime: String)
}

class SleepTimeDatePickerView: UIView {
    
    weak var delegate: SleepTimeCheckDelegate?
    
    private var sleepTime: String?
    
    private let datePicker = UIDatePicker()
    
    private let titleLabel = UILabel().then {
        $0.text = "어제 수면 시간"
        $0.font = UIFont(name: "Avenir-Black", size: 14)
    }
    
    let attributes = [
        NSAttributedString.Key.foregroundColor: UIColor.systemGray,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)
    ]
    
    private lazy var dateTextFiled = UITextField().then {
        $0.font = UIFont(name: "Avenir-Black", size: 22)
        $0.attributedPlaceholder = NSAttributedString(string: "Sleep Time", attributes:attributes)
        $0.layer.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1).cgColor
        $0.layer.cornerRadius = 15
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.layer.backgroundColor = UIColor.customColor(.brandColor).cgColor
        self.layer.cornerRadius = 12
        configureDatePicker()
        setViewHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // DATE PICKER
     private func configureDatePicker(){
         self.datePicker.datePickerMode = .countDownTimer
         self.datePicker.minuteInterval = 10
         self.datePicker.preferredDatePickerStyle = .wheels // 그냥 데이터 피커가 아닌 프리페어 데이트 피커
         self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
         
         let toolBar = UIToolbar()
         toolBar.barStyle = .default
         toolBar.isTranslucent = true
         toolBar.tintColor = UIColor.black
         toolBar.sizeToFit()
         
         let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
         toolBar.setItems([doneButton], animated: true)
         
         self.dateTextFiled.inputAccessoryView = toolBar
         self.dateTextFiled.inputView = self.datePicker
     }
    

      @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
          let formmater = DateFormatter()
          formmater.dateFormat = "HH:mm"
          self.dateTextFiled.text = formmater.string(from: datePicker.date)
          self.delegate?.SleepTimeCheckEnabledSaveBtn(sleepTime: dateTextFiled.text!)
      }
    
    @objc func onClickDoneButton() {
        self.endEditing(true)
    }
    
    private func setViewHierarchy() {
        addSubview(titleLabel)
        addSubview(dateTextFiled)
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(8.84)
        }
        
        dateTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(34)
        }
        
    }


}
