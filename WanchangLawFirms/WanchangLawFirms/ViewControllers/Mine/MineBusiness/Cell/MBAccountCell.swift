//
//  MBAccountCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/10.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBAccountCell: BaseCell {
    
    var model: UserModel! {
        didSet {
            avatarImgView.avatar = model.avatar
            nameLab.text = model.co_username
        }
    }
    
    private let avatarImgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    private let nameLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    let arrow: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        avatarImgView.isMe = true
        arrow.image = UIImage.init(named: "arrow_right_gray")
        self.addSubview(avatarImgView)
        self.addSubview(nameLab)
        self.addSubview(arrow)
        
        _ = avatarImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = nameLab.sd_layout()?.leftSpaceToView(avatarImgView, kLeftSpaceS)?.centerYEqualToView(self)?.rightSpaceToView(self, 60)?.heightIs(30)
        _ = arrow.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(kArrowWH)?.heightIs(kArrowWH)
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
