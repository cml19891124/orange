//
//  JHeaderFooterLabView.swift
//  OLegal
//
//  Created by lh on 2018/11/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 一个UILabel的头和脚
class JHeaderFooterLabView: BaseHeaderFooterSpaceView {
    
    
    let lab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.rightSpaceToView(self, kLeftSpaceL)?.heightIs(20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
