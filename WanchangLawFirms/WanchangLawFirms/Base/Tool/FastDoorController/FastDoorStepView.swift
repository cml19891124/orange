//
//  FastDoorStepView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class FastDoorStepView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let lineImgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
        lineImgView.image = UIImage.init(named: "door_line")
        self.addSubview(lineImgView)
        _ = lineImgView.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.centerYEqualToView(self)?.heightIs(1)
        let per_w: CGFloat = 90
        let per_space: CGFloat = (self.frame.size.width - per_w * 3) / 2
        for i in 0...2 {
            let btn = UIButton.init(kFontL, UIColor.white, UIControl.ContentHorizontalAlignment.center, nil, nil)
            if i == 0 {
                btn.backgroundColor = customColor(255, 178, 110)
                btn.setTitle("专业服务", for: .normal)
            } else if i == 1 {
                btn.backgroundColor = customColor(255, 152, 73)
                btn.setTitle("高效解决", for: .normal)
            } else if i == 2 {
                btn.backgroundColor = customColor(239, 106, 1)
                btn.setTitle("优质体验", for: .normal)
            }
            btn.layer.borderColor = customColor(255, 82, 0).cgColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 22
            btn.clipsToBounds = true
            btn.frame = CGRect.init(x: CGFloat(i) * (per_w + per_space), y: 0, width: per_w, height: 44)
            self.addSubview(btn)
        }
    }

}
