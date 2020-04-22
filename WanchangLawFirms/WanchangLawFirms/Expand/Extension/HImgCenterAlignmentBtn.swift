//
//  HImgCenterAlignmentBtn.swift
//  Stormtrader
//
//  Created by lh on 2018/8/23.
//  Copyright © 2018年 gaming17. All rights reserved.
//

import UIKit

/// 左字右图，居中对齐
class HImgCenterAlignmentBtn: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = 3
        self.imageView?.contentMode = .scaleAspectFit
        
        let strWidth = (self.titleLabel?.sizeThatFits(CGSize.init(width: self.frame.size.width, height: self.frame.size.height)).width)!
        let imgWidth = (self.imageView?.sizeThatFits(CGSize.init(width: self.frame.size.height, height: self.frame.size.height)).width)!
        let x1 = (self.frame.size.width - strWidth - imgWidth - space) / 2
        self.titleLabel?.frame = CGRect.init(x: x1, y: 0, width: strWidth, height: self.frame.size.height)
        self.imageView?.frame = CGRect.init(x: x1 + strWidth + space, y: 0, width: imgWidth, height: self.frame.size.height)
    }

}
