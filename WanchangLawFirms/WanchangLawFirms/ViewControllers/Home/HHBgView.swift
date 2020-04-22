//
//  HHBgView.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 首页轮播视图
class HHBgView: UIView {
    
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFill)
    
    lazy var calouselView: OLCarouselView = {
        () -> OLCarouselView in
        let temp = OLCarouselView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: self.frame.size.height))
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addSubview(calouselView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
