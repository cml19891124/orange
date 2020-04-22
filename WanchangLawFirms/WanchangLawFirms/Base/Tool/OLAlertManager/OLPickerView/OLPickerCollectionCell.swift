//
//  OLPickerCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class OLPickerCollectionCell: UICollectionViewCell {
    
    var bind: String! {
        didSet {
            btn.setImage(UIImage.init(named: bind), for: .normal)
            btn.setTitle(L$(bind), for: .normal)
        }
    }
    
    private let btn: OLPickerBtn = OLPickerBtn.init(font: kFontS)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(btn)
        _ = btn.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
