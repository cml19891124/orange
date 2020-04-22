//
//  MessageCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/3.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 订单消息视图
class MessageCell: BaseCell {
    
    var model: MessageModel! {
        didSet {
            self.nameLab.text = model.product_title
            if model.j_time > 0 {
                self.timeLab.text = "\(model.j_time)".theChatTimeFromNumStr()
            } else {
                self.timeLab.text = model.created_at.theDateYMDHMSStrFromNumStr()
            }
            self.imgView.avatar = model.avatar
            if model.j_unread_count > 0 {
                if model.j_unread_count > 99 {
                    self.countLab.text = "99+"
                } else {
                    self.countLab.text = "\(model.j_unread_count)"
                }
                self.countLab.isHidden = false
            } else {
                self.countLab.isHidden = true
            }
            self.contentLab.text = model.question_show
            if model.chat_show.count > 0 {
                
                let totalMulStr = NSMutableAttributedString()
                let str2 = model.chat_show
                let mulStr2 = NSMutableAttributedString.init(string: str2)
                mulStr2.addAttribute(NSAttributedString.Key.foregroundColor, value: kTextLightBlackColor, range: NSRange.init(location: 0, length: str2.count))
                totalMulStr.append(model.statusMulStr)
                totalMulStr.append(mulStr2)
                self.msgLab.attributedText = totalMulStr
                self.msgLab.frame = CGRect.init(x: kLeftSpaceL + kLeftSpaceS + kAvatarWH, y: self.frame.size.height - 30, width: kDeviceWidth - kLeftSpaceS * 2 - kLeftSpaceL - kAvatarWH, height: 20)
            } else {
                self.msgLab.attributedText = nil
                self.msgLab.frame = CGRect.init(x: kLeftSpaceL + kLeftSpaceS + kAvatarWH, y: self.frame.size.height - 1, width: kDeviceWidth - kLeftSpaceS * 2 - kLeftSpaceL - kAvatarWH, height: 1)
            }
        }
    }
    
    private let imgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    private let nameLab: UILabel = UILabel.init(kFontM, kOrangeDarkColor, NSTextAlignment.left)
    private let contentLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private let msgLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
    private let countLab: UILabel = UILabel.init(kFontS, UIColor.white, NSTextAlignment.center)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentLab.adjustsFontSizeToFitWidth = false
        countLab.backgroundColor = kOrangeDarkColor
        countLab.layer.cornerRadius = 10
        countLab.clipsToBounds = true
        msgLab.adjustsFontSizeToFitWidth = false
        
        self.addSubview(imgView)
        self.addSubview(countLab)
        self.addSubview(nameLab)
        self.addSubview(contentLab)
        self.addSubview(timeLab)
        self.addSubview(msgLab)
        
        _ = imgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.topSpaceToView(self, kLeftSpaceS)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = countLab.sd_layout()?.leftSpaceToView(imgView, -15)?.bottomSpaceToView(imgView, -15)?.widthIs(20)?.heightIs(20)
        _ = nameLab.sd_layout()?.topEqualToView(imgView)?.leftSpaceToView(imgView, kLeftSpaceS)?.widthIs(200)?.heightIs(20)
        _ = timeLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(nameLab)?.widthIs(200)?.heightIs(20)
        _ = contentLab.sd_layout()?.leftEqualToView(nameLab)?.rightEqualToView(timeLab)?.topSpaceToView(nameLab, 5)?.bottomSpaceToView(msgLab, 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        countLab.backgroundColor = kOrangeDarkColor
        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        countLab.backgroundColor = kOrangeDarkColor
    }

}
