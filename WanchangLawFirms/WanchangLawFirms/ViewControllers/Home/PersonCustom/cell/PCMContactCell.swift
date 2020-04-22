//
//  PCMContactCell.swift
//  OLegal
//
//  Created by lh on 2018/11/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会面咨询联系人
class PCMContactCell: BaseCell {
    
    let titleBtn: UIButton = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
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
        tf.leftViewMode = .always
        tf.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 30))
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 1
        tf.layer.borderColor = kLineGrayColor.cgColor
        titleBtn.setImage(UIImage.init(named: "snow_red"), for: .normal)
        titleBtn.imageEdgeInsets = UIEdgeInsets.init(top: -3, left: 0, bottom: 3, right: 0)
        self.addSubview(titleBtn)
        self.addSubview(tf)
        
        _ = titleBtn.sd_layout()?.leftSpaceToView(self, 50)?.rightSpaceToView(self, 50)?.topSpaceToView(self, 0)?.heightIs(30)
        _ = tf.sd_layout()?.leftEqualToView(titleBtn)?.rightEqualToView(titleBtn)?.topSpaceToView(titleBtn, 0)?.heightIs(40)
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
