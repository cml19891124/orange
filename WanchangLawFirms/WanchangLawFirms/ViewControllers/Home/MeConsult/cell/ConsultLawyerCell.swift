//
//  ConsultLawyerCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/28.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ConsultLawyerCell: BaseCell {
    
    var lawyer: LawyerModel? {
        didSet {
            avatarImgView.avatar = lawyer?.avatar
            if lawyer != nil {
                var year = 0
                let y1 = Int(lawyer!.work_year)
                if y1 != nil {
                    year = y1!
                }
                let s1 = lawyer!.name + "   执业\(year)年"
                let s2 = "\n" + lawyer!.desc
                let totalStr = s1 + s2
                let mulStr = NSMutableAttributedString.init(string: totalStr)
                mulStr.addAttributes([NSAttributedString.Key.foregroundColor : kTextBlackColor, NSAttributedString.Key.font: kFontM], range: NSRange.init(location: 0, length: s1.count))
                titleLab.attributedText = mulStr
            }
        }
    }
    
    var id: String? {
        didSet {
            if id != nil {
                LawyerManager.share.chatLawyer(id: id!) { (m) in
                    if m != nil {
                        self.lawyer = m
                    }
                }
            }
        }
    }
    
    
    private let avatarImgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    private let titleLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.addSubview(avatarImgView)
        self.addSubview(titleLab)
        
        _ = avatarImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(40)?.heightIs(40)
        _ = titleLab.sd_layout()?.leftSpaceToView(avatarImgView, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.bottomSpaceToView(self, kLeftSpaceS)
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
