//
//  JShadowView.swift
//  OLegal
//
//  Created by lh on 2018/11/26.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 阴影
class JShadowView: UIView {

    let contentView: UIView = UIView()
    convenience init(bgColor:UIColor, shadowColor: UIColor) {
        self.init()
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 10
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 8
        self.layer.masksToBounds = false
        
        self.contentView.backgroundColor = bgColor
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
        self.addSubview(contentView)
        self.insertSubview(contentView, at: 0)
        _ = contentView.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
    }

}
