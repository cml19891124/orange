//
//  MHAvatarView.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我的头像
class MHAvatarView: UIView {
    
    private lazy var wh: CGFloat = {
        () -> CGFloat in
        let temp = self.frame.size.height - 40
        return temp
    }()
    private lazy var avatarFrame: CGRect = {
        () -> CGRect in
        let ss: CGFloat = 24
        let temp = CGRect.init(x: (self.frame.size.width - wh) / 2 + ss / 2, y: ss / 2, width: wh - ss, height: wh - ss)
        return temp
    }()
    private lazy var avatarImgView: JAvatarImgView = {
        () -> JAvatarImgView in
        let temp = JAvatarImgView.init(cornerRadius: avatarFrame.size.width / 2)
        temp.isMe = true
        temp.frame = avatarFrame
        return temp
    }()
    private lazy var circleView: MHCircleView = {
        () -> MHCircleView in
        let temp = MHCircleView.init(frame: avatarFrame)
        return temp
    }()
    private lazy var nameLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontM, UIColor.white, NSTextAlignment.center)
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.personDataRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(personDataRefresh), name: NSNotification.Name(rawValue: noti_user_model_refresh), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        nameLab.frame = CGRect.init(x: 0, y: self.frame.size.height - 40, width: kDeviceWidth, height: 40)
        self.addSubview(circleView)
        self.addSubview(avatarImgView)
        self.addSubview(nameLab)
        
        avatarImgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        avatarImgView.addGestureRecognizer(tap)
    }
    
    @objc private func personDataRefresh() {
        guard let model = UserInfo.share.model else {
            return
        }
        if UserInfo.share.is_business {
            self.nameLab.text = model.username
        } else {
            self.nameLab.text = model.j_name
        }
        self.avatarImgView.avatar = model.avatar
    }
    
    @objc private func tapClick() {
        if UserInfo.share.is_business {
            UserInfo.share.companyAccountList { (flag) in
                if flag {
                    for m in UserInfo.share.businessAccountArr {
                        if m.uid == UserInfo.share.model?.id {
                            let vc = MinuBusinessAccountDetailController()
                            vc.model = m
                            JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
                            break
                        }
                    }
                }
            }
        } else {
            let vc = MineProfileController()
            JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
        }
    }

}
