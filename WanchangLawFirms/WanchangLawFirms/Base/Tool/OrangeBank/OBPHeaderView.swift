//
//  OBPHeaderView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/2.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class OBPHeaderView: BaseHeaderFooterSpaceView {

    let headLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    let tailLab: UILabel = UILabel.init(kFontMS, kOrangeDarkColor, NSTextAlignment.right)
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = kCellColor
        self.addSubview(headLab)
        self.addSubview(tailLab)
        _ = headLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(100)?.heightIs(20)
        _ = tailLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(150)?.heightIs(30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
