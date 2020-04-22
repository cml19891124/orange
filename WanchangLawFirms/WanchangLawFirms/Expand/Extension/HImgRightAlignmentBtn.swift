//
//  HImgRightAlignmentBtn.swift
//  Stormtrader
//
//  Created by lh on 2018/8/23.
//  Copyright © 2018年 gaming17. All rights reserved.
//

import UIKit

/// 左字右图 右对齐
class HImgRightAlignmentBtn: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = 3
        self.imageView?.contentMode = .scaleAspectFit
        let imgWidth = (self.imageView?.sizeThatFits(CGSize.init(width: self.frame.size.height, height: self.frame.size.height)).width)!
        self.titleLabel?.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width - imgWidth - space, height: self.frame.size.height)
        self.imageView?.frame = CGRect.init(x: self.frame.size.width - imgWidth, y: 0, width: imgWidth, height: self.frame.size.height)
    }

}
