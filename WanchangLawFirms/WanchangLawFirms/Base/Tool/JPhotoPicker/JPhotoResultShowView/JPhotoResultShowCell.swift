//
//  JPhotoResultShowCell.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

class JPhotoResultShowCell: UICollectionViewCell {
    
    var asset: PHAsset! {
        didSet {
            imgView.image = asset.img
        }
    }
    
    lazy var imgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init()
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imgView)
        _ = imgView.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomEqualToView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
