//
//  JTitleChooseCell.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JTitleChooseCell: UICollectionViewCell {
    
    var model: JTitleChooseModel! {
        didSet {
            btn.setTitle(L$(model.bind), for: .normal)
            btn.setTitleColor(model.normalTextColor, for: .normal)
            btn.setTitleColor(model.selectedTextColor, for: .selected)
            btn.titleLabel?.font = model.textFont
            btn.isSelected = model.selected
        }
    }
    
    private lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, UIColor.clear, UIControl.ContentHorizontalAlignment.center, nil, nil)
        self.addSubview(temp)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        btn.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
