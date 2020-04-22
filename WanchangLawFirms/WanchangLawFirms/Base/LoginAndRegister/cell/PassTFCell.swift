//
//  PassTFCell.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 密码
class PassTFCell: LoginTFBaseCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.doneView.bind = "p_pass_limit"
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.leftBtn.setImage(UIImage.init(named: "lr_password"), for: .normal)
        self.tf.isSecureTextEntry = true
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
