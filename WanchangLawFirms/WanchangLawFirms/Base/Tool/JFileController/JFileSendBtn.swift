//
//  JFileSendBtn.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JFileSendBtn: UIButton {
    
    convenience init(frame: CGRect, titleStr: String) {
        self.init(frame: frame)
        self.titleLabel?.font = kFontMS
        self.setTitle(titleStr, for: .normal)
        self.setTitle(titleStr, for: .disabled)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(kOrangeLightColor, for: .disabled)
        self.contentHorizontalAlignment = .right
    }

}
