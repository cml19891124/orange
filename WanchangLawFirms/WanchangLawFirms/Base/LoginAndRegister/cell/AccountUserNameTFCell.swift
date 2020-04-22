//
//  AccountUserNameTFCell.swift
//  WanchangLawFirms
//
//  Created by szcy on 2019/6/15.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class AccountUserNameTFCell: LoginTFBaseCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.tf.keyboardType = .default
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

extension AccountUserNameTFCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let temp = textField.text else {
            return true
        }
        if string == "" {
            return true
        }
        if temp.count > 50 {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserInfo.share.business_username = textField.text
    }
    
}
