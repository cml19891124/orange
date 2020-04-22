//
//  ChatQuestionView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/9.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol ChatQuestionViewDelegate: NSObjectProtocol {
    func chatQuestionViewEndClick()
}

/// 聊天订单信息视图
class ChatQuestionView: UIView {
    
    var model: MessageModel! {
        didSet {
            nameLab.text = model.name
            timeLab.text = model.created_at.theDateYMDHMSStrFromNumStr()
            tv.text = model.desc
            imgView.avatar = model.avatar
            if model.order_status == "1" {
                _ = closeBtn.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(timeLab, 0)?.widthIs(50)?.heightIs(30)
                _ = tv.sd_layout()?.leftSpaceToView(imgView, kLeftSpaceSS)?.rightSpaceToView(self, 70)?.topSpaceToView(nameLab, 0)?.bottomSpaceToView(self, kLeftSpaceS)
            } else {
                _ = tv.sd_layout()?.leftSpaceToView(imgView, kLeftSpaceSS)?.rightSpaceToView(self, 10)?.topSpaceToView(nameLab, 0)?.bottomSpaceToView(self, kLeftSpaceS)
            }
        }
    }
    
    weak var delegate: ChatQuestionViewDelegate?
    
    private let imgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    private let nameLab: UILabel = UILabel.init(kFontM, kOrangeDarkColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
    private let tv: UITextView = UITextView.init()
    private lazy var closeBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(closeClick))
        temp.setTitle("结束", for: .normal)
        temp.backgroundColor = kOrangeDarkColor
        temp.layer.cornerRadius = kBtnCornerR
        self.addSubview(temp)
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
//        if UserInfo.share.is_business {
//            notiLab.text = "订单完成后，记得点击右上角结束咨询哦~"
//        } else {
//            notiLab.text = "订单超过72个小时，咨询将自动取消。"
//        }
        self.tv.delegate = self
        self.tv.textColor = kTextBlackColor
        self.tv.font = kFontMS
        self.addSubview(imgView)
        self.addSubview(nameLab)
        self.addSubview(timeLab)
        self.addSubview(tv)
        
        _ = imgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = nameLab.sd_layout()?.leftSpaceToView(imgView, kLeftSpaceS)?.topEqualToView(imgView)?.rightSpaceToView(self, 150)?.heightIs(20)
        _ = timeLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(nameLab)?.leftSpaceToView(nameLab,kLeftSpaceS)?.heightIs(20)
    }
    
    @objc private func closeClick() {
        self.delegate?.chatQuestionViewEndClick()
    }
    
}

extension ChatQuestionView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
}
