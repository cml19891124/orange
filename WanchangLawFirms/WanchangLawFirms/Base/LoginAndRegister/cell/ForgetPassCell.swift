//
//  ForgetPassCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 忘记密码
class ForgetPassCell: BaseCell {
    
    let leftLab: LLabel = LLabel.init(font: kFontMS, textAlignment: NSTextAlignment.left)
    let rightLab: LLabel = LLabel.init(font: kFontMS, textAlignment: NSTextAlignment.right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        leftLab.textColor = kTextBlackColor
        rightLab.textColor = kTextBlackColor
        self.addSubview(leftLab)
        self.addSubview(rightLab)
        _ = leftLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(180)?.heightIs(30)
        _ = rightLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(100)?.heightIs(30)
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
