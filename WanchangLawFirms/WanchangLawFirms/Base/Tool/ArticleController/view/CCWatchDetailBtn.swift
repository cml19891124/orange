//
//  CCWatchDetailBtn.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class CCWatchDetailBtn: UIButton {

    convenience init(bindStr: String) {
        self.init()
        self.titleLabel?.font = kFontS
        self.contentHorizontalAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
        self.isUserInteractionEnabled = false
        self.setBackgroundImage(UIImage.imageWithColor(kOrangeDarkColor), for: .normal)
        self.layer.cornerRadius = kBtnCornerR
        self.clipsToBounds = true
        self.setTitle(L$(bindStr), for: .normal)
    }

}

extension CCWatchDetailBtn {
    var bind_width: CGFloat {
        get {
            let w = self.sizeThatFits(CGSize.init(width: kDeviceWidth, height: bind_height)).width + kLeftSpaceS
            return w
        }
    }
    
    var bind_height: CGFloat {
        get {
            return 20
        }
    }
}
