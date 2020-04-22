//
//  JImgViewSelfAdapt.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 图片自适应大小，给定宽度，返回高度
class JImgViewSelfAdapt: UIImageView {

    var end_height: CGFloat = 0
    convenience init(imgName: String, wid: CGFloat) {
        self.init()
        self.image = UIImage.init(named: imgName)
        let s = self.sizeThatFits(CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        end_height = wid * s.height / s.width
    }

}
 
