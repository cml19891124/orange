//
//  FCCCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 
class FCCCollectionCell: UICollectionViewCell {
    
    var model: JBindModel! {
        didSet {
            btn.setTitle(L$(model.bind), for: .normal)
            if model.selected {
                btn.backgroundColor = kOrangeDarkColor
            } else {
                btn.backgroundColor = UIColor.clear
            }
            btn.isSelected = model.selected
        }
    }
    
    private lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(frame: self.bounds)
        temp.titleLabel?.font = kFontMS
        temp.setTitleColor(kTextGrayColor, for: .normal)
        temp.setTitleColor(UIColor.white, for: .selected)
        temp.contentHorizontalAlignment = .center
        temp.isUserInteractionEnabled = false
        temp.layer.cornerRadius = kBtnCornerR
        temp.layer.borderColor = kTextGrayColor.cgColor
        temp.layer.borderWidth = 1
        self.addSubview(temp)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = btn.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
