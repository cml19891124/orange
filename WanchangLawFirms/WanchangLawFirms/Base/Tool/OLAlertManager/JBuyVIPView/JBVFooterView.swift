//
//  JBVFooterView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/16.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JBVFooterView: UITableViewHeaderFooterView {
    
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
    let lab: LLabel = LLabel.init(font: kFontMS, textAlignment: NSTextAlignment.center)
    private let line: UIView = UIView.init(lineColor: kLineGrayColor)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = kCellColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let str1 = L$("vip_open_means")
        let str2 = L$("vip_xieyi")
        lab.text = str1 + str2
        lab.addClickText(str: str2, original_color: kOrangeDarkColor, click_color: kOrangeDarkClickColor)
        self.addSubview(lab)
        self.addSubview(btn)
        self.addSubview(line)
        _ = lab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, 0)?.heightIs(50)
        _ = btn.sd_layout()?.centerXEqualToView(self)?.bottomSpaceToView(self, 25)?.widthIs(kDeviceWidth - kLeftSpaceL * 2)?.heightIs(40)
        _ = line.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(kLineHeight)
    }
    
    @objc private func btnClick(sender: UIButton) {
        self.delegate?.jOKBtnCellClick(sender: sender)
    }
    
}
