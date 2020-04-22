//
//  FastDoorTopView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class FastDoorTopView: UIView {
    
    private let topV: UIView = UIView()
    private let bubbleImgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    let titleLab: UILabel = UILabel.init(kFontXL, UIColor.white, NSTextAlignment.right)
    private let logoImgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    private let stepView: FastDoorStepView = FastDoorStepView.init(frame: CGRect.init(x: kLeftSpaceL, y: 310, width: kDeviceWidth - kLeftSpaceL * 2, height: 44))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        bubbleImgView.image = UIImage.init(named: "door_bubble")
        logoImgView.image = UIImage.init(named: "door_logo")
        self.addSubview(topV)
        topV.addSubview(bubbleImgView)
        bubbleImgView.addSubview(titleLab)
        topV.addSubview(logoImgView)
        self.addSubview(stepView)
        _ = topV.sd_layout()?.topSpaceToView(self, kLeftSpaceL)?.centerXEqualToView(self)?.widthIs(324)?.heightIs(250)
        _ = bubbleImgView.sd_layout()?.leftSpaceToView(topV, 0)?.topSpaceToView(topV, 0)?.widthIs(182)?.heightIs(182)
        _ = titleLab.sd_layout()?.rightSpaceToView(bubbleImgView, kLeftSpaceL)?.leftSpaceToView(bubbleImgView, 0)?.topSpaceToView(bubbleImgView, kLeftSpaceS)?.bottomSpaceToView(bubbleImgView, 40)
        _ = logoImgView.sd_layout()?.leftSpaceToView(bubbleImgView, 0)?.bottomSpaceToView(topV, 0)?.widthIs(142)?.heightIs(116)
        _ = stepView.sd_layout()?.bottomSpaceToView(self, 0)?.centerXEqualToView(self)?.widthIs(kDeviceWidth - kLeftSpaceL * 2)?.heightIs(44)
    }

}
