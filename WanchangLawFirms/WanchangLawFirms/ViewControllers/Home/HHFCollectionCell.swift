//
//  HHFCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 首页功能单个Cell（经典案例、文书模版、法务计算器、在线客服按钮的点击Cell）
class HHFCollectionCell: UICollectionViewCell {
    
    var bind: String! {
        didSet {
            logoBtn.setTitle(L$(bind), for: .normal)
            let imgName = JIconManager.share.getIcon(bind: bind)
            logoBtn.setImage(UIImage.init(named: imgName), for: .normal)
        }
    }
    
    private lazy var logoBtn: JVerticalBtn = {
        () -> JVerticalBtn in
        let temp = JVerticalBtn.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
        temp.frame = self.bounds
        self.addSubview(temp)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
