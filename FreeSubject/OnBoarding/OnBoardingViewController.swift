//
//  OnBoardingViewController.swift
//  FreeSubject
//
//  Created by qualson1 on 2022/10/04.
//

import UIKit
import SnapKit
import Then

class OnBoardingViewController: UIViewController {
    
    var images = ["Onboarding1.png", "Onboarding2.png", "Onboarding3.png", "Onboarding4.png", "Onboarding5.png"]
    
     let scrollView = UIScrollView().then {
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        $0.isPagingEnabled = true
    }
    
      var pageControl = UIPageControl().then {
         $0.pageIndicatorTintColor = .darkGray
    }
        
    let signUPBtn = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setBackgroundColor(.customColor(.brandColor), for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customColor(.brandColor).cgColor
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(210)
        }
        $0.addTarget(self, action: #selector(signUPBtnTap), for: .touchUpInside)
    }
    
    private let loginBtn = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.customColor(.brandColor), for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customColor(.brandColor).cgColor
        $0.setBackgroundColor(.customColor(.defaultGrayColor), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(210)
        }
        $0.addTarget(self, action: #selector(loginBtnTap), for: .touchUpInside)
    }
    
    private let goHomeBtn = UIButton().then {
        $0.setTitle("둘러보기", for: .normal)
        $0.setTitleColor(.customColor(.defaultGrayColor), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.setUnderline()
    }
    
    private let signStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.distribution = .fill
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setViewHierarchy()
        setConstraints()
        addContentScrollView()
        scrollView.delegate = self
        pageControl.numberOfPages = images.count
    }
    
    private func setViewHierarchy() {
        view.addSubviews(scrollView, pageControl, signStackView, goHomeBtn)
        signStackView.addArrangedSubviews(signUPBtn, loginBtn)

    }
    
    private func setConstraints() {
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(100)
            
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(scrollView.snp.bottom).offset(-10)
            
        }
        
        signStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(90)
            $0.top.equalTo(scrollView.snp.bottom).offset(60)
        }
        
        goHomeBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(167)
            $0.bottom.equalToSuperview().inset(60)
            $0.top.equalTo(signStackView.snp.bottom).offset(60)
        }
        
    }

     func addContentScrollView() {
         for i in 0..<images.count{
             let imageView = UIImageView()
             imageView.image = UIImage(named: images[i])
             imageView.contentMode = .scaleToFill	 //  사진의 비율을 맞춤.
             let xPosition = self.view.frame.width * CGFloat(i)
             
             imageView.frame = CGRect(x: xPosition, y: 0,
             width: self.view.frame.width,
             height: self.view.frame.height) // 즉 이미지 뷰가 화면 전체를 덮게 됨.
             
             scrollView.contentSize.width =
                self.view.frame.width * CGFloat(1+i)
         
             scrollView.addSubview(imageView)
         }
    }
    
    @objc func signUPBtnTap() {
        let newViewController = ServiceTermViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func loginBtnTap() {
        let newViewController = LoginViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}

extension OnBoardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(pageNumber)
    }
}
