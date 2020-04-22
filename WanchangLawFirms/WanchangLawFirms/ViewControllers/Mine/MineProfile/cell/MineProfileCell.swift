//
//  MineProfileCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineProfileCell: MineCell {
    
    override var bind: String! {
        didSet {
            if bind == "m_nickname" {
                tailLab.text = UserInfo.share.model?.nickname
            } else if bind == "m_sex" {
                tailLab.text = UserInfo.share.model?.show_sex
            } else if bind == "m_area" {
                tailLab.text = UserInfo.share.model?.address
            } else if bind == "m_mobile" {
                tailLab.text = UserInfo.share.model?.mobile
            } else if bind == "m_email" {
                tailLab.text = UserInfo.share.model?.email
            }
        }
    }
    
    let tailLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews1()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews1() {
        self.addSubview(tailLab)
        _ = tailLab.sd_layout()?.rightSpaceToView(self.arrow, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(200)?.heightIs(20)
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
