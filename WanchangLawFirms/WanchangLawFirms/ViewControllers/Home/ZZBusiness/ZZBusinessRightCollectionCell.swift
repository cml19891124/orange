//
//  ZZBusinessRightCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ZZBusinessRightCollectionCell: ZZBusinessBaseCollectionCell {
    
    private let line: UIView = UIView.init(lineColor: kLineGrayColor)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(line)
        _ = line.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(kLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
