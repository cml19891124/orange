//
//  OLProfilePickerBtn.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/12.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class OLProfilePickerBtn: UIButton {
    
    convenience init(font: UIFont) {
        self.init()
        self.titleLabel?.font = font
        self.contentHorizontalAlignment = .center
        self.titleLabel?.textAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let tempSize = self.frame.size
        var imgSize = CGSize.init(width: 50, height: 50)
        if self.imageView != nil {
            imgSize = self.imageView!.sizeThatFits(tempSize)
        }
        var titleSize = CGSize.init(width: 50, height: 50)
        if self.titleLabel != nil {
            titleSize = self.titleLabel!.sizeThatFits(tempSize)
        }
        let space: CGFloat = 5
        let img_y: CGFloat = (tempSize.height - imgSize.height - titleSize.height - space) / 2
        self.imageView?.frame = CGRect.init(origin: CGPoint.init(x: (tempSize.width - imgSize.width) / 2, y: img_y), size: imgSize)
        self.titleLabel?.frame = CGRect.init(origin: CGPoint.init(x: (tempSize.width - titleSize.width) / 2, y: (img_y + imgSize.height + space)), size: titleSize)
    }

}
