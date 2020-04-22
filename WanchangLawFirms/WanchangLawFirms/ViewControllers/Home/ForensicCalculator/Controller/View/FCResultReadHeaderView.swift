//
//  FCResultReadHeaderView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/16.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算结果只读，不可写
class FCResultReadHeaderView: FCResultBaseHeaderView {

    var model: FCDamageModel! {
        didSet {
            titleLab.text = model.title
            trailLab.text = model.val + "元"
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        arrow.isHidden = true
        self.selBtn.isSelected = true
        self.line.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
