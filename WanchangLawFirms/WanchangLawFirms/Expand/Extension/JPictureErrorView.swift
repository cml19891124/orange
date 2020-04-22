//
//  JPictureErrorView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/11.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 图片下载失败 - 通常发生在没有网络，下载失败后显示该视图
class JPictureErrorView: UIView {
    
    private let errorBtn: JVerticalBtn = JVerticalBtn.init(kFontL, UIColor.white, UIControl.ContentHorizontalAlignment.center, nil, nil)
    convenience init(frame: CGRect, bind: String) {
        self.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        errorBtn.setImage(UIImage.init(named: "picture_error"), for: .normal)
        errorBtn.setTitle(L$(bind), for: .normal)
        self.setupViews()
    }
    
    private func setupViews() {
        self.addSubview(errorBtn)
        _ = errorBtn.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(120)?.heightIs(120)
    }

}
