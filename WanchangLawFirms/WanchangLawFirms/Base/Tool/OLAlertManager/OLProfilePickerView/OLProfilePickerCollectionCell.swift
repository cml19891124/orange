//
//  OLProfilePickerCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/12.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class OLProfilePickerCollectionCell: UICollectionViewCell {
    
    var bind: String! {
        didSet {
            btn.setImage(UIImage.init(named: bind), for: .normal)
            btn.setTitle(L$(bind), for: .normal)
        }
    }
    
    private let btn: OLProfilePickerBtn = OLProfilePickerBtn.init(font: kFontS)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        btn.layer.cornerRadius = frame.size.width / 2
        btn.clipsToBounds = true
        btn.backgroundColor = kOrangeDarkColor
        self.addSubview(btn)
        _ = btn.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
