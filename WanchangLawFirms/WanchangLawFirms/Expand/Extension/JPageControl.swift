//
//  JPageControl.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/17.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 小圆点
class JPageControl: UIPageControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.currentPageIndicatorTintColor = kOrangeDarkColor
        self.pageIndicatorTintColor = kGrayColor
        self.isUserInteractionEnabled = false
        self.currentPage = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
