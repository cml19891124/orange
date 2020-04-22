//
//  OLCommentScoreCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/18.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class OLCommentScoreCollectionCell: UICollectionViewCell {
    
    let btn: UIButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        btn.isUserInteractionEnabled = false
        btn.frame = self.bounds
        self.addSubview(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
