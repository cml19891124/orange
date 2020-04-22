//
//  MobileTFCell.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 手机号文本框
class MobileTFCell: LoginTFBaseCell {
    
    var isLR: Bool = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.leftBtn.setImage(UIImage.init(named: "lr_mobile"), for: .normal)
        self.tf.keyboardType = .numberPad
        self.tf.delegate = self
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

extension MobileTFCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let temp = textField.text else {
            return true
        }
        if string == "" {
            return true
        }
        if temp.count >= 11 {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isLR {
            UserInfo.share.mobile = textField.text
        } else {
            UserInfo.share.change_mobile = textField.text
        }
    }
    
}
