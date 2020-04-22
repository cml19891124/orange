//
//  PCMTextCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/18.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 会面咨询文本
class PCMTextCell: BaseCell {
    
    var bind: String = "" {
        didSet {
            tf.keyboardType = .default
            if bind == "h_meet_reason" {
                tf.placeholder = L$("p_enter_meet_reason")
            } else if bind == "h_meet_teach_phone" {
                tf.keyboardType = .numberPad
                tf.placeholder = L$("p_enter_teach_phone")
            } else if bind == "h_meet_teach_area" {
                tf.placeholder = L$("p_enter_teach_address")
            } else if bind == "h_meet_teach_obj" {
                tf.placeholder = L$("p_enter_teach_obj")
            } else if bind == "h_meet_teach_content" {
                tf.placeholder = L$("p_enter_teach_content")
            }
        }
    }
    
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
        self.addSubview(tf)
        
        _ = tf.sd_layout()?.leftSpaceToView(self, 50)?.rightSpaceToView(self, 50)?.centerYEqualToView(self)?.heightIs(40)
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
