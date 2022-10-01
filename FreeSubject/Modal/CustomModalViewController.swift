//
//  TestViewControlle.swift
//  FreeSubject
//
//  Created by 홍준혁 on 2022/09/01.
//

import UIKit
import SnapKit
import RealmSwift

class CustomModalViewController: UIViewController{

    // 변수!

    // 모달창에 뜨는 부분 날짜 표기
    var Date:String = ""
    var isToday:Bool = false
    
    
    // half-modal 뷰
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.alpha = 1.0
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .systemGray5
        label.clipsToBounds = true
        label.text = "등록방법을 선택해 주세요."
        return label
    }()
    

    lazy var ButtonForWriteView: UIButton = {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load2"), object: self.Date)
        var btn = UIButton()
        btn.setTitle("오늘 하루를 기록해주세요.", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 16
        btn.backgroundColor = UIColor.customColor(.defaultGrayColor)
        btn.addTarget(self, action: #selector(dismissModal1), for: .touchUpInside)
        return btn
    }()
    
    lazy var ButtonForReset:UIButton = {
        var btn = UIButton()
        btn.setTitle("새로운 복약정보를 입력해주세요.", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 16
        btn.backgroundColor = UIColor.customColor(.defaultGrayColor)
        btn.addTarget(self, action: #selector(dismissModal2), for: .touchUpInside)
        return btn
    }()

    private let ButtonForExit = UIButton().then {
       $0.setImage(UIImage(systemName: "xmark"), for: .normal)
       $0.addTarget(self, action: #selector(dismissModal1), for: .touchUpInside)
       $0.tintColor = .black
       $0.layer.cornerRadius = 16
       $0.backgroundColor = UIColor.customColor(.defaultGrayColor)
   }
    
    
    // Constants
    let defaultHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 150
    let maximumContainerHeight: CGFloat = 600
    var currentContainerHeight: CGFloat = 300
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    
    // draw View!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(isToday)
        view.backgroundColor = .systemBackground
        setView()
        
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        containerView.addGestureRecognizer(tapGesture)
        
        setupPanGesture()
    }
    

    func setView() {
        view.backgroundColor = .clear
        
        // Add subviews
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        titleLabel.addSubview(ButtonForExit)
        containerView.addSubview(ButtonForWriteView)
        containerView.addSubview(ButtonForReset)
        
        setSNP()
    }

    func setSNP(){
        containerView.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(containerView)
            make.trailing.equalTo(containerView)
            make.leading.equalTo(containerView)
            make.height.equalTo(80)
        }
        ButtonForExit.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        ButtonForWriteView.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
        ButtonForReset.snp.makeConstraints{ make in
            make.top.equalTo(ButtonForWriteView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }

        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    
    // 로직 함수!
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    
    @objc func dismissModal1(_ sender: UIButton) {
        guard let pvc = self.presentingViewController else { return }
        pvc.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true) {
            pvc.present(WriteViewController(isToday: true),animated: true,completion: nil)
        }
    }
    // ScheduleViewController와 연결 - 근데 이거 present말고 push 형태로 수정 필요
    @objc func dismissModal2(_ sendr:UIButton){
        guard let pvc = self.presentingViewController else { return }
        pvc.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true) {
            pvc.present(ScheduleViewController(),animated: true,completion: nil)
        }
    }
    

    
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        containerView.alpha = 1.0
        UIView.animate(withDuration: 0.4) {
            self.containerView.alpha = 1.0
        }
        
    }
    
    func animateDismissView() {
        containerView.alpha = 1.0
        UIView.animate(withDuration: 0.4) {
            self.containerView.alpha = 1.0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
}

