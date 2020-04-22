//
//  ArticleFloatView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/2.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ArticleFloatView: UIView {

    private let btn: JVerticalBtn = JVerticalBtn.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, nil, nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.width / 2
        self.clipsToBounds = true
        btn.frame = CGRect.init(x: 10, y: 10, width: frame.size.width / 2, height: frame.size.height / 2)
        self.addSubview(btn)
        self.setFloat()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFloat() {
        self.btn.setImage(UIImage.init(named: "article_float_set"), for: .normal)
        self.btn.setTitle("浮窗", for: .normal)
        self.backgroundColor = kGrayColor
    }
    
    func cancelFloat() {
        self.btn.setImage(UIImage.init(named: "article_float_cancel"), for: .normal)
        self.btn.setTitle("取消浮窗", for: .normal)
        self.backgroundColor = kOrangeDarkColor
    }
    
}
