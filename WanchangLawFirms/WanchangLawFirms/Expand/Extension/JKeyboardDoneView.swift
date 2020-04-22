//
//  JKeyboardDoneView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/17.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 键盘附加视图
class JKeyboardDoneView: UIView {
    
    var bind: String = "" {
        didSet {
            self.lab.text = L$(bind)
        }
    }

    private lazy var line: UIView = {
        () -> UIView in
        let temp = UIView.init(lineColor: kGrayColor)
        self.addSubview(temp)
        return temp
    }()
    private lazy var lab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.center)
        self.addSubview(temp)
        return temp
    }()
    private lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick))
        self.addSubview(temp)
        return temp
    }()
    private var tf: UITextField?
    private var tv: UITextView?
    convenience init(bind: String) {
        self.init()
        self.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 40)
        self.backgroundColor = kBaseColor
        lab.text = L$(bind)
        btn.setTitle(L$("finish"), for: .normal)
        _ = btn.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(50)?.heightIs(30)
        _ = lab.sd_layout()?.leftSpaceToView(self, 70)?.rightSpaceToView(self, 70)?.centerYEqualToView(self)?.heightIs(30)
        _ = line.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.heightIs(1)
    }
    
    @objc private func btnClick() {
        tf?.resignFirstResponder()
        tv?.resignFirstResponder()
    }
    
    func addTF(tf: UITextField) {
        self.tf = tf
        tf.returnKeyType = .default
        tf.inputAccessoryView = self
    }
    
    func addTV(tv: UITextView) {
        self.tv = tv
        tv.returnKeyType = .default
        tv.inputAccessoryView = self
    }

}
