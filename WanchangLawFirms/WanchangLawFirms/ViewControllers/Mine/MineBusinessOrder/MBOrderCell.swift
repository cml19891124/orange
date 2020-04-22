//
//  MBOrderCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/20.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBOrderCell: BaseCell {

    var status: String = ""
    var model: MessageModel! {
        didSet {
            typeLab.text = model.product_title
            timeLab.text = model.created_at.theDateYMDStr()
            desLab.text = model.desc
            avatarImgView.avatar = model.avatar
            if model.comment_content.haveTextStr() {
                self.commentLab.isHidden = false
            } else {
                self.commentLab.isHidden = true
            }
        }
    }
    
    
    private let avatarImgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    private let typeLab: UILabel = UILabel.init(kFontM, kOrangeDarkColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
    private let desLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private let arrow: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    private let commentLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        commentLab.text = "已评价"
        desLab.adjustsFontSizeToFitWidth = false
        self.addSubview(avatarImgView)
        self.addSubview(typeLab)
        self.addSubview(timeLab)
        self.addSubview(desLab)
        self.addSubview(commentLab)
        
        _ = avatarImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = typeLab.sd_layout()?.topSpaceToView(self, kLeftSpaceS)?.leftSpaceToView(avatarImgView, kLeftSpaceS)?.widthIs(100)?.heightIs(20)
        _ = timeLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(typeLab)?.widthIs(150)?.heightIs(20)
        _ = desLab.sd_layout()?.leftEqualToView(typeLab)?.rightSpaceToView(self, 50)?.topSpaceToView(typeLab, 5)?.bottomSpaceToView(self, kLeftSpaceS)
        _ = commentLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.bottomSpaceToView(self, kLeftSpaceS)?.widthIs(100)?.heightIs(20)
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
