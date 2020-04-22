//
//  CCCHeadView.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class CCCHeadView: UIView {
    
    var model: HomeModel! {
        didSet {
            titleLab.text = model.title
            let tempStr = kBtnSpaceString + model.pv
            hotBtn.setTitle(tempStr, for: .normal)
            imgView.sd_setImage(with: URL.init(string: model.urlStr), completed: nil)
        }
    }
    
    private let spaceV: UIView = UIView.init(lineColor: kBaseColor)
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFill)
    private let titleLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private let hotBtn: UIButton = UIButton.init(kFontS, kOrangeDarkColor, UIControl.ContentHorizontalAlignment.left, nil, nil)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        self.setupViews()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        hotBtn.setImage(UIImage.init(named: "hot_icon"), for: .normal)
        titleLab.adjustsFontSizeToFitWidth = false
        self.addSubview(spaceV)
        self.addSubview(imgView)
        self.addSubview(titleLab)
        self.addSubview(hotBtn)
        
        _ = spaceV.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(kCellSpaceL)
        _ = imgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(spaceV, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.heightIs(140)
        _ = hotBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.bottomSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.heightIs(20)
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(imgView, kLeftSpaceS)?.bottomSpaceToView(hotBtn, kLeftSpaceS)
    }
    
    @objc private func tapClick() {
        let vc = ArticleDetailController()
        vc.model = model
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
    }

}
