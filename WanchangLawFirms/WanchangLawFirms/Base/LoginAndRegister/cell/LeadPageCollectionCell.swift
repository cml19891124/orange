//
//  LeadPageCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/12.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 引导页Cell
class LeadPageCollectionCell: UICollectionViewCell {
    
    var index: Int = 1 {
        didSet {
            imgView.image = UIImage.init(named: "lead_page_\(index)")
            if index == 4 {
                self.startBtn.isHidden = false
                self.logoBtn.isHidden = true
                self.pageCon.isHidden = true
            } else {
                self.startBtn.isHidden = true
                self.logoBtn.isHidden = false
                self.pageCon.isHidden = false
                self.pageCon.currentPage = index - 1
            }
        }
    }
    
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFill)
    
    private lazy var logoBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontS, kTextGrayColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
        temp.setImage(UIImage.init(named: "lead_page_logo"), for: .normal)
        return temp
    }()
    private lazy var startBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kOrangeDarkColor, UIControl.ContentHorizontalAlignment.center, self, #selector(startClick))
        temp.setTitle("立即体验", for: .normal)
        temp.layer.cornerRadius = 20
        temp.clipsToBounds = true
        temp.layer.borderWidth = 1
        temp.layer.borderColor = kOrangeDarkColor.cgColor
        return temp
    }()
    private lazy var pageCon: JPageControl = {
        () -> JPageControl in
        let temp = JPageControl.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceHeight - 30))
        temp.numberOfPages = 4
        temp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imgView)
        self.addSubview(logoBtn)
        self.addSubview(startBtn)
        self.addSubview(pageCon)
        _ = imgView.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
        _ = logoBtn.sd_layout()?.bottomSpaceToView(self, kXBottomHeight + 50)?.centerXEqualToView(self)?.widthIs(300)?.heightIs(60)
        _ = startBtn.sd_layout()?.bottomSpaceToView(self, kXBottomHeight + 60)?.centerXEqualToView(self)?.widthIs(120)?.heightIs(40)
        _ = pageCon.sd_layout()?.topSpaceToView(logoBtn, 0)?.centerXEqualToView(self)?.widthIs(100)?.heightIs(30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func startClick() {
        JRootVCManager.share.rootLogin()
        UserInfo.setStandard(key: standard_first_open, text: "1")
    }
    
}
