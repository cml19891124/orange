//
//  JVLogoBtn.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/21.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 上图下字
class JVLogoBtn: UIButton {
    
    var j_height: CGFloat {
        get {
            return imgHeight + 40
        }
    }

    private var imgHeight: CGFloat = 0.0
    convenience init(logo: String) {
        self.init()
        self.setTitle("欧伶猪法律法务咨询", for: .normal)
        self.setTitleColor(kTextBlackColor, for: .normal)
        self.titleLabel?.font = kFontXL
        self.titleLabel?.textAlignment = .center
        self.setImage(UIImage.init(named: logo), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = false
        imgHeight = self.imageView!.sizeThatFits(CGSize.init(width: kDeviceWidth, height: kDeviceHeight)).height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: imgHeight)
        self.titleLabel?.frame = CGRect.init(x: 0, y: imgHeight, width: kDeviceWidth, height: 30)
    }

}
