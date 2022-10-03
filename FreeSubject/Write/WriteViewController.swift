//
//  WriteViewController.swift
//  FreeSubject
//
//
//

import UIKit
import SnapKit
import Then
import RealmSwift
import Realm




class WriteViewController: UIViewController {

    let dateFormatter = DateFormatter()
    var isToday:Bool  = false
    let realTime = Date()
    
    var todayTask: Day?
    
    var stdDate: String?

    
    let calendar: Calendar = Calendar.current
    
    init(isToday: Bool) {
            self.isToday = isToday
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 입력값 필수 체크
    var isEmojiCheckRight: Bool = false
    var isMedicineCheckRight: Bool = false
    var isSleepTimeCheckRight: Bool = false
    var isTodayQuestionCheckRight: Bool = false
    
    //이모지
    var getEmoji: Int?
    // 약복용 여부
    var medicineCheck: Bool?
    // 수면 시간
    var sleepTime: String?
    // 기분 체크
    var emotionCheck: Bool?
    // 1번째 질문
    var firstQuestion: String?
    // 2번째 질문
    var secondQuestion: String?
    // 3번째 질문
    var questionText: String?
    
    let emojiView = EmojiView()
    let sleepTimeDatePickerView = SleepTimeDatePickerView()
    let medicineCheckView = MedicineCheckView()
    let emotionalCheckView = EmotionalCheckView()
    let contentScrollView = ContentScrollView()
    let todayQuestionView = TodayQuestionView()
    
    private let titleLabel = UILabel().then {
        $0.text = "Drug Diary"
        $0.font = UIFont(name: "Avenir-Black", size: 24)
    }
    
     private let closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        $0.tintColor = .black
        $0.layer.cornerRadius = 16
        $0.backgroundColor = UIColor.customColor(.defaultGrayColor)
    }
    
    lazy var saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.isEnabled = false
        $0.setBackgroundColor(.customColor(.writeViewColor), for: .normal)
        $0.setBackgroundColor(.gray, for: .disabled)
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(saveButtonTap(_:)), for: .touchUpInside)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        resetDB()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        print(self.isToday)
        contentScrollView.emojiView.delegate = self
        contentScrollView.medicineCheckView.delegate = self
        contentScrollView.sleepTimeDatePickerView.delegate = self
        contentScrollView.emotionalCheckView.delegate = self
        contentScrollView.todayQuestionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(saveButtonEnableCheck(_:)), name: Notification.Name("saveButtonEnable"), object: nil)
        setUI()
    }
    
    func setUI() {
        self.view.addSubviews(titleLabel, closeButton, contentScrollView, saveButton)

        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.centerX.equalToSuperview()
        }
    
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(14)
            $0.width.equalTo(34)
            $0.height.equalTo(34)
        }
        
        contentScrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-16)
            $0.trailing.leading.equalToSuperview().inset(130)
            $0.height.equalTo(44)
        }
    }
    
    func saveData() {
        dateFormatter.dateFormat = "YYYYMMdd"
        let currentDate = dateFormatter.string(from: realTime)
        let newTask = Day(createdDate: currentDate,
                          iconFeeling: getEmoji!,
                          sleepTime: sleepTime!,
                          didFeelingChange: emotionCheck ?? false,
                          didTakeMedicine: medicineCheck!,
                          firstQuestion: firstQuestion ?? "불편한 거 없이 좋았어요.",
                          secondQuestion: secondQuestion ?? "특별한 사건이 없었어요.",
                          thirdQuestion: questionText!)
        
        // 여기에 오늘이 아니면 데이터 들어가지 않는 로직 구현
        if self.isToday == true{
            if self.todayTask?._id == nil {
                RealmService.shared.add(item: newTask)
            }else{
                guard let task = self.todayTask else {return}
                RealmService.shared.update(item: task, newTask: newTask)
            }
        } else {

        }//확인만

        
    }

    @objc func closeButtonTap() {
        self.dismiss(animated: true)
    }
    
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -250 // Move view 150 points upward

    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
        // Move view to original position
    }
    
    @objc func saveButtonEnableCheck(_ noti: Notification) {
        saveButton.isEnabled = isMedicineCheckRight && isSleepTimeCheckRight && isTodayQuestionCheckRight && isEmojiCheckRight
    }
    
    @objc func saveButtonTap(_ sender: UIButton) {
        print(sender.isEnabled)
        saveData()
        self.dismiss(animated: true)
    }
}
extension WriteViewController: MedicineCheckDelegate, SleepTimeCheckDelegate, TodayQuestionCheckDelegate, EmotionalCheckDelegate, EmojiViewCheckDelegate {
    func getEmoji(emoji: Int) {
        self.getEmoji = emoji
        
        if self.getEmoji != nil {
            self.isEmojiCheckRight = true
        }
    }
    
    
    func SleepTimeCheckEnabledSaveBtn(sleepTime: String) {
        self.sleepTime = sleepTime
        
        if self.sleepTime != "" {
            self.isSleepTimeCheckRight = true
            
            NotificationCenter.default.post(
                name: Notification.Name("saveButtonEnable"),
                object: nil
            )
        }
    }
    
    func medicineCheckEnabledSaveBtn(medicine: Bool) {
        
        self.medicineCheck = medicine
        
        if self.medicineCheck != nil {
            self.isMedicineCheckRight = true
            
            NotificationCenter.default.post(
                name: Notification.Name("saveButtonEnable"),
                object: nil
            )
        }
    }
    
    func TodayQuestionCheckEnabledSaveBtn(question: String) {
        
        self.questionText = question
        
        if self.questionText != "" {
            self.isTodayQuestionCheckRight = true
            
            NotificationCenter.default.post(
                name: Notification.Name("saveButtonEnable"),
                object: nil
            )
        }
    }
    
    func firstQuestionText(firstQuestion: String) {
        self.firstQuestion = firstQuestion
    }
    
    func secondQuestionText(secondQuestion: String) {
        self.secondQuestion = secondQuestion
    }
    
    func emotionalCheck(emotional:Bool) {
        self.emotionCheck = emotional
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

