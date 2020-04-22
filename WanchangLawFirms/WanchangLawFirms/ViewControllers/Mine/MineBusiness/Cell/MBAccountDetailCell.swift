//
//  MBAccountDetailCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/17.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBAccountDetailCell: MBAccountBaseCell {
    
    
    var model: UserModel! {
        didSet {
            if bind == "m_business_username" {
                tailLab.text = model.co_username
                self.hideArrow = true
            } else if bind == "m_business_password" {
                if UserInfo.share.isMother {
                    self.hideArrow = false
                } else {
                    self.hideArrow = true
                }
            } else if bind == "m_business_contact" {
                if UserInfo.share.isMother && UserInfo.share.businessModel?.uid == model.uid {
                    self.hideArrow = false//true
//                    tailLab.text = UserInfo.share.businessModel?.contact_name
                    tailLab.text = model.co_name
                } else {
                    tailLab.text = model.co_name
                    self.hideArrow = false
                }
            } else if bind == "m_business_mobile" {
                if UserInfo.share.isMother && UserInfo.share.businessModel?.uid == model.uid {
                    self.hideArrow = false//true
//                    tailLab.text = UserInfo.share.businessModel?.contact_phone
                    tailLab.text = model.co_mobile
                } else {
                    tailLab.text = model.co_mobile
                    self.hideArrow = false
                }
            } else if bind == "m_business_email" {
                if UserInfo.share.isMother && UserInfo.share.businessModel?.uid == model.uid {
                    self.hideArrow = false//true
//                    tailLab.text = UserInfo.share.businessModel?.contact_email
                    tailLab.text = model.co_email
                } else {
                    tailLab.text = model.co_email
                    self.hideArrow = false
                }
            }
        }
    }
    
    let tailLab: UILabel = UILabel.init(kFontS, kOrangeLightColor, NSTextAlignment.right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(tailLab)
        _ = tailLab.sd_layout()?.rightSpaceToView(self.arrow, kLeftSpaceS)?.centerYEqualToView(self)?.leftSpaceToView(headLab, 0)?.heightIs(40)
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
