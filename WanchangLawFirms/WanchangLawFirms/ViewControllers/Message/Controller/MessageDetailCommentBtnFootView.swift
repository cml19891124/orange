//
//  MessageDetailCommentBtnFootView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/18.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 订单详情未评论
class MessageDetailCommentBtnFootView: UIView {

    weak var delegate: JOKBtnCellDelegate?
    private let spaceV: UIView = UIView()
    lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick(sender:)))
        temp.layer.cornerRadius = 15
        temp.clipsToBounds = true
        let gradLayer = CAGradientLayer.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 30), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 1, y: 0), colors: [kBtnGradeStartColor, kBtnGradeEndColor])
        temp.layer.insertSublayer(gradLayer, at: 0)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        spaceV.backgroundColor = kBaseColor
        self.addSubview(spaceV)
        self.addSubview(btn)
        _ = spaceV.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(kCellSpaceL)
        _ = btn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(spaceV, kLeftSpaceS)?.widthIs(120)?.heightIs(30)
    }
    
    @objc private func btnClick(sender: UIButton) {
        self.delegate?.jOKBtnCellClick(sender: sender)
    }

}
