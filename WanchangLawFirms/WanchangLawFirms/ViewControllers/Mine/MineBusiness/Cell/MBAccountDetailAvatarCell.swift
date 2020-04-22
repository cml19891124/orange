//
//  MBAccountDetailAvatarCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/18.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBAccountDetailAvatarCell: MBAccountBaseCell {
    
    var model: UserModel! {
        didSet {
            avatarImgView.avatar = model.avatar
            if UserInfo.share.isMother && UserInfo.share.businessModel?.uid != model.uid {
                self.hideArrow = true
            } else {
                self.hideArrow = false
            }
        }
    }
    
    private lazy var avatarImgView: JAvatarImgView = {
        () -> JAvatarImgView in
        let temp = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
        temp.isMe = true
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(avatarImgView)
        _ = avatarImgView.sd_layout()?.rightSpaceToView(self.arrow, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
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
