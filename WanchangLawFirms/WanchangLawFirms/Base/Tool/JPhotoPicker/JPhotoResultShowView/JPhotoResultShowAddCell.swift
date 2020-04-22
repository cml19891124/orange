//
//  JPhotoResultShowAddCell.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JPhotoResultShowAddCell: UICollectionViewCell {
    
    lazy var imgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init()
        temp.contentMode = .scaleAspectFit
        temp.clipsToBounds = true
        temp.image = UIImage.init(named: "add_photo")
        return temp
    }()
    
    lazy var btn: JVerticalBtn = {
        () -> JVerticalBtn in
        let temp = JVerticalBtn.init(kFontMS, kTextGrayColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
        temp.isUserInteractionEnabled = false
        temp.setImage(UIImage.init(named: "add_photo"), for: .normal)
        temp.setTitle("点击添加", for: .normal)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(btn)
        _ = btn.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomEqualToView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
