//
//  JPhotoPromptView.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JPhotoPromptView: UIView {
    
    var text: String? {
        didSet {
            lab.text = text
        }
    }

    private lazy var lab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init()
        temp.font = UIFont.systemFont(ofSize: 14)
        temp.backgroundColor = kGrayColor
        temp.layer.cornerRadius = kBtnCornerR
        temp.clipsToBounds = true
        temp.textAlignment = .center
        self.addSubview(temp)
        return temp
    }()
    
    convenience init(bind: String) {
        self.init()
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.25)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.lab.text = L$(bind)
        let si = self.lab.sizeThatFits(CGSize.init(width: kDeviceWidth - 30, height: CGFloat(MAXFLOAT)))
        _ = lab.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(si.width + 20)?.heightIs(si.height + 20)
    }

}
