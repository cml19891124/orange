//
//  JNoDataView.swift
//  Stormtrader
//
//  Created by lh on 2018/11/5.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JNoDataView: UIView {

    lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
        temp.backgroundColor = UIColor.clear
        self.addSubview(temp)
        return temp
    }()
    lazy var lab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.center)
        self.addSubview(temp)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
        
        let h: CGFloat = 150
        
        _ = btn.sd_layout()?.centerXEqualToView(self)?.topSpaceToView(self, 100)?.widthIs(kDeviceWidth)?.heightIs(h)
        _ = lab.sd_layout()?.centerXEqualToView(self)?.topSpaceToView(btn, 0)?.widthIs(kDeviceWidth)?.heightIs(30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
