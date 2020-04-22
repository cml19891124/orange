//
//  JOKBtnView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/25.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JOKBtnView: UIView {

    weak var delegate: JOKBtnCellDelegate?
    
    lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontL, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick(sender:)))
        temp.layer.cornerRadius = 20
        temp.clipsToBounds = true
        let gradLayer = CAGradientLayer.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth - kLeftSpaceL * 2, height: 40), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 1, y: 0), colors: [kBtnGradeStartColor, kBtnGradeEndColor])
        temp.layer.insertSublayer(gradLayer, at: 0)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(btn)
        _ = btn.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(kDeviceWidth - kLeftSpaceL * 2)?.heightIs(40)
    }
    
    @objc private func btnClick(sender: UIButton) {
        self.delegate?.jOKBtnCellClick(sender: sender)
    }

}
