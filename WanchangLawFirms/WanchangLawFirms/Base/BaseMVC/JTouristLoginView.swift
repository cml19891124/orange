//
//  JTouristLoginView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/25.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JTouristLoginView: UIView {

    private lazy var loginBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kOrangeDarkColor, UIControl.ContentHorizontalAlignment.center, self, #selector(loginClick))
        temp.setTitle("登录", for: .normal)
        temp.layer.cornerRadius = kBtnCornerR
        temp.layer.borderColor = kOrangeDarkColor.cgColor
        temp.layer.borderWidth = 1
        self.addSubview(temp)
        return temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        _ = loginBtn.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(60)?.heightIs(30)
    }
    
    @objc private func loginClick() {
        NotificationCenter.default.post(name: NSNotification.Name(noti_tourist_back), object: nil)
    }

}
