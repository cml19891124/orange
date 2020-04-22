//
//  DTCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/11/29.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 文书模版缩略图
class DTCell: UICollectionViewCell {
    
    var model: HomeModel! {
        didSet {
            titleLab.text = model.title
            imgView.sd_setImage(with: URL.init(string: model.urlStr), completed: nil)
        }
    }
    
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFill)
    private let titleLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imgView.layer.borderColor = kLineGrayColor.cgColor
        imgView.layer.borderWidth = 0.5
        titleLab.backgroundColor = kOrangeLightColor
        self.addSubview(imgView)
        self.addSubview(titleLab)
        
        _ = titleLab.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(30)
        _ = imgView.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomSpaceToView(titleLab, 0)
    }
    
}
