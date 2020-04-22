//
//  MessageDetailCommentFootView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/18.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 订单详情已评论
class MessageDetailCommentFootView: UIView {

    weak var delegate: JOKBtnCellDelegate?
    
    private let spaceV: UIView = UIView()
    private let commentLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private let avatarImgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    private let nameLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let scoreView: OLCScoreView = OLCScoreView.init(isBig: false)
    private let contentLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private lazy var editBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick(sender:)))
        temp.setTitle(L$("edit_comment"), for: .normal)
        temp.layer.cornerRadius = 15
        temp.clipsToBounds = true
        let gradLayer = CAGradientLayer.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 30), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 1, y: 0), colors: [kBtnGradeStartColor, kBtnGradeEndColor])
        temp.layer.insertSublayer(gradLayer, at: 0)
        return temp
    }()
    
    private var model: MessageModel!
    convenience init(model: MessageModel) {
        self.init()
        self.backgroundColor = kCellColor
        self.model = model
        self.setupViews()
        self.dealDataSource()
    }

    private func setupViews() {
        spaceV.backgroundColor = kBaseColor
        scoreView.score = Float(model.comment_star) ?? 1
        self.addSubview(spaceV)
        self.addSubview(commentLab)
        self.addSubview(avatarImgView)
        self.addSubview(nameLab)
        self.addSubview(timeLab)
        self.addSubview(scoreView)
        self.addSubview(contentLab)
        self.addSubview(editBtn)
        
        _ = spaceV.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(kCellSpaceL)
        _ = commentLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(spaceV, 0)?.widthIs(100)?.heightIs(40)
        _ = avatarImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(commentLab, 0)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = nameLab.sd_layout()?.leftSpaceToView(avatarImgView, kLeftSpaceS)?.topEqualToView(avatarImgView)?.rightSpaceToView(self, kLeftSpaceS)?.heightIs(20)
        _ = timeLab.sd_layout()?.leftEqualToView(nameLab)?.topSpaceToView(nameLab, 0)?.rightEqualToView(nameLab)?.heightIs(20)
        _ = scoreView.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.topSpaceToView(avatarImgView, kLeftSpaceS)?.heightIs(20)
        _ = contentLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(scoreView, kLeftSpaceS)?.bottomSpaceToView(self, kLeftSpaceS + 40)
        _ = editBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.bottomSpaceToView(self, kLeftSpaceS)?.widthIs(120)?.heightIs(30)
    }
    
    private func dealDataSource() {
        commentLab.text = L$("m_my_comment")
        avatarImgView.isMe = true
        avatarImgView.avatar = UserInfo.share.model?.avatar
        nameLab.text = UserInfo.share.model?.j_name
        timeLab.text = model.comment_at.theDateYMDHMSStrFromNumStr()
        contentLab.text = model.comment_content
        let topH = kCellSpaceL + 40 + kAvatarWH + kLeftSpaceS + 20 + kLeftSpaceS
        let h = contentLab.sizeThatFits(CGSize.init(width: kDeviceWidth - kLeftSpaceS * 2, height: CGFloat(MAXFLOAT))).height
        if UserInfo.share.is_business {
//            if UserInfo.share.businessModel?.uid == self.model.uid {
//                self.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: topH + h + kLeftSpaceS + 30 + kLeftSpaceS * 2)
//            } else {
//                self.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: topH + h + kLeftSpaceS * 2)
//                self.editBtn.isHidden = true
//            }
            self.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: topH + h + kLeftSpaceS + 30 + kLeftSpaceS * 2)
            if UserInfo.share.businessModel?.uid != self.model.uid {
                self.editBtn.isHidden = true
            }
        } else {
            self.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: topH + h + kLeftSpaceS + 30 + kLeftSpaceS * 2)
        }
        
    }
    
    @objc private func btnClick(sender: UIButton) {
        self.delegate?.jOKBtnCellClick(sender: sender)
    }
    
}
