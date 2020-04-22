//
//  HHCCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 首页（个人定制、企业定制、我要咨询的Cell）
class HHCCollectionCell: UICollectionViewCell {
    
    var bind: String! {
        didSet {
            let bind2 = bind + "_desc"
            let str1 = L$(bind)
            let str2 = "\n\n" + L$(bind2)
            let totalStr = str1 + str2
            let mulStr = NSMutableAttributedString.init(string: totalStr)
            mulStr.addAttribute(NSAttributedString.Key.font, value: kFontS, range: NSRange.init(location: str1.count, length: str2.count))
            mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kTextLightBlackColor, range: NSRange.init(location: str1.count, length: str2.count))
            logoBtn.setAttributedTitle(mulStr, for: .normal)
            let imgName = JIconManager.share.getIcon(bind: bind)
            logoBtn.setImage(UIImage.init(named: imgName), for: .normal)
        }
    }
    
    private lazy var logoBtn: JVerticalBtn = {
        () -> JVerticalBtn in
        let temp = JVerticalBtn.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
        temp.titleLabel?.textAlignment = .center
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
