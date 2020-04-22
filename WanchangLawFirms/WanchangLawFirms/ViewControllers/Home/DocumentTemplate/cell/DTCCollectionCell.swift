//
//  DTCCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 文书模版左边分类选择
class DTCCollectionCell: UICollectionViewCell {
    
    var model: JTitleChooseModel! {
        didSet {
            titleBtn.setTitle(model.bind, for: .normal)
            titleBtn.isSelected = model.selected
            imgBtn.isSelected = model.selected
            if model.selected {
                self.backgroundColor = kCellColor
            } else {
                self.backgroundColor = customColor(248, 248, 248)
            }
        }
    }
    
    private let titleBtn: UIButton = UIButton.init(kFontM, kTextGrayColor, UIControl.ContentHorizontalAlignment.right, nil, nil)
    private let imgBtn: UIButton = UIButton.init(kFontM, kTextGrayColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
    private let lineV: UIView = UIView.init(lineColor: customColor(227, 227, 227))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lineV.frame = CGRect.init(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: kLineHeight)
        titleBtn.setTitleColor(kTextBlackColor, for: .selected)
        imgBtn.setImage(nil, for: .normal)
        imgBtn.setImage(UIImage.init(named: "triangle_right_orange"), for: .selected)
        self.addSubview(titleBtn)
        self.addSubview(imgBtn)
        self.addSubview(lineV)
        
        _ = imgBtn.sd_layout()?.rightSpaceToView(self, 0)?.centerYEqualToView(self)?.widthIs(20)?.heightIs(20)
        _ = titleBtn.sd_layout()?.leftSpaceToView(self, 0)?.rightSpaceToView(imgBtn, kLeftSpaceSS)?.centerYEqualToView(self)?.heightIs(30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
