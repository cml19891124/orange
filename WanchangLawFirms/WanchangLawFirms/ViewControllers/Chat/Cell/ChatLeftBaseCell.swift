//
//  ChatLeftBaseCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 聊天页左边基类
class ChatLeftBaseCell: ChatBaseCell {
    
    override var msg: STMessage! {
        didSet {
            self.bubbleImgView.frame = CGRect.init(x: kLeftSpaceS + kAvatarWH + 5, y: 20, width: msg.size.width, height: msg.size.height)
            LawyerManager.share.getLawyerModel(id: msg.from) { (m) in
                self.lawyer = m
            }
        }
    }
    
    private var lawyer: LawyerModel! {
        didSet {
            self.nameLab.text = lawyer.name
            self.avatarImgView.avatar = lawyer.avatar
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.bubbleImgView.image = UIImage.init(named: "chat_bubble_left")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 23, left: 15, bottom: 8, right: 8), resizingMode: .stretch)
        _ = self.avatarImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, 10)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = self.nameLab.sd_layout()?.leftSpaceToView(avatarImgView, kLeftSpaceS)?.topSpaceToView(self, 0)?.rightSpaceToView(self, 50)?.heightIs(20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
