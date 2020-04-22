//
//  ZZBusinessLeftCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ZZBusinessLeftCollectionCell: ZZBusinessBaseCollectionCell {
    
    private let line1: UIView = UIView.init(lineColor: kLineGrayColor)
    private let line2: UIView = UIView.init(lineColor: kLineGrayColor)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(line1)
        self.addSubview(line2)
        _ = line1.sd_layout()?.leftEqualToView(self)?.bottomEqualToView(self)?.rightEqualToView(self)?.heightIs(kLineHeight)
        _ = line2.sd_layout()?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.widthIs(kLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
