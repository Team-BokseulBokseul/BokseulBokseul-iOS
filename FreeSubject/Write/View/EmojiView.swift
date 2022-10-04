//
//  EmojiView.swift
//  FreeSubject
//
//  Created by qualson1 on 2022/08/28.
//

import UIKit
import SnapKit
import Then

protocol EmojiViewCheckDelegate: AnyObject {

    func getEmoji(emoji: Int)
}

enum Emoji: Int, CaseIterable {
    case happy
    case tranquility
    case tough
    case sad
    case tired
    case angry
    
    var image: UIImage {
        switch self {
        case .happy: return UIImage(named: "Happy.png")!
        case .tranquility: return UIImage(named: "Tranquility.png")!
        case .tough: return UIImage(named: "Tough.png")!
        case .sad: return UIImage(named: "Sad.png")!
        case .tired: return UIImage(named: "Tired.png")!
        case .angry: return UIImage(named: "Angry.png")!
        }
    }
    
    var labelText: String {
        switch self {
        case .happy: return "기쁨"
        case .tranquility: return "편안"
        case .tough: return "힘듦"
        case .sad: return "슬픔"
        case .tired: return "피곤"
        case .angry: return "화남"
        }
    }
}
class EmojiView: UIView {
   
    var emoji: Emoji? {
        didSet {
            //1. uiView 배열을 emojiStackview 배열로 변환
            let view = horizontalStackView.arrangedSubviews.compactMap {$0 as? EmojiStackView }
            
            let oldView = view.first(where: {$0.emoji == oldValue})
            oldView?.removeBorder()
            
            let newView = view.first(where: {$0.emoji == self.emoji})
            newView?.addBorder()
            
            self.delegate?.getEmoji(emoji: emoji!.rawValue)
            
        }
    }
        
    weak var delegate: EmojiViewCheckDelegate?
    
    private let titleLabel = UILabel().then {
        $0.text = "기분을 선택해줘"
        $0.font = UIFont(name: "Avenir-Black", size: 14)
    }
    
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.layer.backgroundColor = UIColor.customColor(.brandColor).cgColor
        self.layer.cornerRadius = 12
        setViewHierarchy()
        setConstraints()
        setAddStackViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAddStackViews() {
        
        for emoji in Emoji.allCases {
            let emojiStackView = EmojiStackView()
            emojiStackView.configure(emoji: emoji)
            emojiStackView.isUserInteractionEnabled = true
            //emojiStackView.addTarget(self, action: S, for: .touchUpInside)
            emojiStackView.delegate = self
            emojiStackView.tag = emoji.rawValue
            horizontalStackView.addArrangedSubview(emojiStackView)
        }
    }
    
//    @objc func didSeletedEmojiStackView() {
//        emojiTap()
//    }
    
    private func setViewHierarchy() {
        addSubview(horizontalStackView)
        addSubview(titleLabel)
    }
    
    private func setConstraints() {
        
        horizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(39)
            $0.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(14)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(14)
        }
        
    }
}


extension EmojiView: EmojiStackViewDelegate {
    
    func didSelectedEmojiView(newEmoji: Emoji) {
        
        self.emoji = newEmoji
    }
}
