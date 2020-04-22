//
//  JTitleChooseModel.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JTitleChooseModel: NSObject {
    
    var bind: String = ""
    var normalTextColor: UIColor = UIColor.clear
    var selectedTextColor: UIColor = UIColor.clear
    var lineColor: UIColor = UIColor.clear
    var textFont = kFontM
    var selected: Bool = false
    var tag: Int = 0
    
    convenience init(bind: String, normalTextColor: UIColor, selectedTextColor: UIColor, lineColor: UIColor, textFont: UIFont, tag: Int) {
        self.init()
        self.bind = bind
        self.normalTextColor = normalTextColor
        self.selectedTextColor = selectedTextColor
        self.lineColor = lineColor
        self.textFont = textFont
        self.tag = tag
        if tag == 1 {
            selected = true
        }
    }

}
