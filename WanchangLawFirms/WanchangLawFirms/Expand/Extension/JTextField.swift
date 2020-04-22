//
//  JTextField.swift
//  Stormtrader
//
//  Created by lh on 2018/8/24.
//  Copyright © 2018年 gaming17. All rights reserved.
//

import UIKit

class JTextField: UITextField {
    
    override var placeholder: String? {
        didSet {
            if placeholder != nil {
                self.attributedPlaceholder = NSAttributedString.init(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor:kPlaceholderColor])
            }
        }
    }

    convenience init(font: UIFont) {
        self.init()
        self.backgroundColor = UIColor.clear
        self.font = font
        self.textColor = kTextBlackColor
        self.returnKeyType = .done
    }

}
