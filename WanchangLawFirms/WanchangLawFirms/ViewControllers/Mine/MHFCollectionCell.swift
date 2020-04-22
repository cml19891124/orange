//
//  MHFCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我的头部Cell
class MHFCollectionCell: UICollectionViewCell {
    
    var model: MHFModel! {
        didSet {
            lab1.text = L$(model.bind)
            lab2.text = model.descStr
        }
    }
    
    private let lab1: UILabel = UILabel.init(kFontS, kTextBlackColor, NSTextAlignment.center)
    private let lab2: UILabel = UILabel.init(kFontMS, kOrangeDarkColor, NSTextAlignment.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(lab1)
        self.addSubview(lab2)
        
        _ = lab1.sd_layout()?.centerXEqualToView(self)?.bottomSpaceToView(self, self.frame.size.height / 2)?.widthIs(self.frame.size.width)?.heightIs(20)
        _ = lab2.sd_layout()?.centerXEqualToView(self)?.topSpaceToView(lab1, 0)?.widthIs(self.frame.size.width)?.heightIs(20)
    }
    
}
