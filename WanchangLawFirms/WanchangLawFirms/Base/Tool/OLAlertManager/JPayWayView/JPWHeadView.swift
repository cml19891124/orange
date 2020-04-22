//
//  JPWHeadView.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JPWHeadView: UIView {
    
    private lazy var backBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontL, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.setImage(UIImage.init(named: "cross_gray"), for: .normal)
        return temp
    }()
    private lazy var titleLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontL, kTextBlackColor, NSTextAlignment.center)
        temp.text = L$("confirm_pay")
        return temp
    }()
    private let line: UIView = UIView.init(lineColor: kLineGrayColor)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(backBtn)
        self.addSubview(titleLab)
        self.addSubview(line)
        
        _ = backBtn.sd_layout()?.leftSpaceToView(self, 0)?.centerYEqualToView(self)?.widthIs(50)?.heightIs(50)
        _ = titleLab.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(200)?.heightIs(30)
        _ = line.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(kLineHeight)
    }
    
    @objc private func btnsClick(sender: UIButton) {
        OLAlertManager.share.payHide()
    }

}
