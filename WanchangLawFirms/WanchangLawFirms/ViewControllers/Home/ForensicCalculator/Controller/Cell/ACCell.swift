//
//  ACCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算文本输入框
class ACCell: BaseCell {
    
    let titleLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    let tf: JTextField = JTextField.init(font: kFontMS)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        tf.layer.borderColor = kLineGrayColor.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = kBtnCornerR
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        self.addSubview(titleLab)
        self.addSubview(tf)
        
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(180)?.heightIs(30)
        _ = tf.sd_layout()?.leftSpaceToView(titleLab, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.heightIs(30)
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
