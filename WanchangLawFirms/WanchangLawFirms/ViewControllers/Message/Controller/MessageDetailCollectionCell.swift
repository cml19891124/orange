//
//  MessageDetailCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/5/1.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MessageDetailCollectionCell: UICollectionViewCell {
    
    var msg: STMessage! {
        didSet {
            if msg.fromMe {
                self.nameLab.text = UserInfo.share.model?.nickname
                self.avatarImgView.avatar = UserInfo.share.model?.avatar
            } else {
                LawyerManager.share.getLawyerModel(id: msg.from) { (m) in
                    self.lawyer = m
                }
            }
            if msg.isWithdrew {
                contentLab.text = "撤回了一条消息"
            } else {
                switch msg.bodyType {
                case .bigEmo:
                    contentLab.text = "[大表情]"
                    break
                case .image:
                    contentLab.text = "图片"
                    break
                case .file:
                    let body = msg.body as! STFileMessageBody
                    var temp = "[文件]"
                    temp += body.name
                    contentLab.text = temp
                    break
                default:
                    contentLab.text = msg.j_model.content
                    break
                }
            }
            timeLab.text = msg.timeStr
        }
    }
    private var lawyer: LawyerModel! {
        didSet {
            self.nameLab.text = lawyer.name
            self.avatarImgView.avatar = lawyer.avatar
        }
    }
    
    private let avatarImgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    private let nameLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let contentLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontMS, kOrangeDarkColor, NSTextAlignment.right)
    private let line: UIView = UIView.init(lineColor: kLineGrayColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentLab.adjustsFontSizeToFitWidth = false
        self.addSubview(avatarImgView)
        self.addSubview(nameLab)
        self.addSubview(contentLab)
        self.addSubview(timeLab)
        self.addSubview(line)
        
        _ = avatarImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = nameLab.sd_layout()?.leftSpaceToView(avatarImgView, kLeftSpaceS)?.rightSpaceToView(self, 80)?.topEqualToView(avatarImgView)?.heightIs(20)
        _ = contentLab.sd_layout()?.leftEqualToView(nameLab)?.rightEqualToView(nameLab)?.bottomEqualToView(avatarImgView)?.heightIs(20)
        _ = timeLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(nameLab)?.widthIs(100)?.heightIs(20)
        _ = line.sd_layout()?.leftEqualToView(nameLab)?.rightSpaceToView(self, kLeftSpaceS)?.bottomEqualToView(self)?.heightIs(kLineHeight)
    }
    
}
