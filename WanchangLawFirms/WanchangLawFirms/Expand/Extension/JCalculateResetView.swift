//
//  JCalculateResetView.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JCalculateResetViewDelegate: NSObjectProtocol {
    func jcalculateResetViewBtnsClick(sender: UIButton, bind: String)
}

/// 法务计算器重置计算视图
class JCalculateResetView: UIView {

    weak var delegate: JCalculateResetViewDelegate?
    private lazy var btn1: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick(sender:)))
        temp.backgroundColor = kOrangeLightColor
        return temp
    }()
    
    private lazy var btn2: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick(sender:)))
        temp.backgroundColor = kOrangeDarkColor
        return temp
    }()
    
    private var bind1: String = ""
    private var bind2: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(btn1)
        self.addSubview(btn2)
        _ = btn1.sd_layout()?.leftEqualToView(self)?.rightSpaceToView(self, self.frame.size.width / 2)?.topEqualToView(self)?.bottomEqualToView(self)
        _ = btn2.sd_layout()?.rightEqualToView(self)?.topEqualToView(self)?.bottomEqualToView(self)?.leftSpaceToView(self, self.frame.size.width / 2)
    }
    
    func getDataSource(bind1: String, bind2: String) {
        self.bind1 = bind1
        self.bind2 = bind2
        btn1.setTitle(L$(bind1), for: .normal)
        btn2.setTitle(L$(bind2), for: .normal)
    }
    
    @objc private func btnClick(sender: UIButton) {
        if sender.isEqual(btn1) {
            self.delegate?.jcalculateResetViewBtnsClick(sender: sender, bind: bind1)
        } else {
            self.delegate?.jcalculateResetViewBtnsClick(sender: sender, bind: bind2)
        }
    }

}
