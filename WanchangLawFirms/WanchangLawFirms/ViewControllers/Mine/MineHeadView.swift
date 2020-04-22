//
//  MineHeadView.swift
//  OLegal
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我的头部
class MineHeadView: UIView {
    
    private let bgImgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFill)
    
    private lazy var avatarV: MHAvatarView = {
        () -> MHAvatarView in
        let temp = MHAvatarView.init(frame: CGRect.init(x: 0, y: kBarStatusHeight + 53, width: kDeviceWidth, height: self.frame.size.height - kBarStatusHeight - 103))
        return temp
    }()
    
    private lazy var funcV: MHFuncView = {
        () -> MHFuncView in
        let temp = MHFuncView.init(frame: CGRect.init(x: kLeftSpaceS, y: self.frame.size.height - 50, width: self.frame.size.width - kLeftSpaceS * 2, height: 50))
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kBaseColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        bgImgView.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: self.frame.size.height - 20 - kNavHeight)
        bgImgView.backgroundColor = UIColor.clear
        let gradeLayer = CAGradientLayer.init(frame: bgImgView.bounds, startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 0, y: 1), colors: [kNavGradeEndColor, kViewGradeEndColor])
        bgImgView.layer.addSublayer(gradeLayer)
        
        self.addSubview(bgImgView)
        self.addSubview(avatarV)
        self.addSubview(funcV)
    }

}
