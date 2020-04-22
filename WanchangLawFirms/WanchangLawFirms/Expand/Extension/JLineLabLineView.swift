//
//  JLineLabLineView.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 样式，如： ------ 三方登陆 --------
class JLineLabLineView: UIView {
    
    var bind: String! {
        didSet {
            lab.text = L$(bind)
            let w = lab.sizeThatFits(CGSize.init(width: kDeviceWidth, height: 20)).width + kLeftSpaceL
            
            _ = lab.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(w)?.heightIs(20)
            _ = line1.sd_layout()?.leftEqualToView(self)?.centerYEqualToView(self)?.rightSpaceToView(lab, 0)?.heightIs(kLineHeight)
            _ = line2.sd_layout()?.rightEqualToView(self)?.centerYEqualToView(self)?.leftSpaceToView(lab, 0)?.heightIs(kLineHeight)
        }
    }

    
    private var lineColor: UIColor = UIColor.clear
    
    private lazy var line1: UIView = {
        () -> UIView in
        let temp = UIView.init(lineColor: lineColor)
        self.addSubview(temp)
        return temp
    }()
    private lazy var line2: UIView = {
        () -> UIView in
        let temp = UIView.init(lineColor: lineColor)
        self.addSubview(temp)
        return temp
    }()
    private lazy var lab: UILabel = {
        () -> UILabel in
        let temp = UILabel()
        temp.textAlignment = .center
        self.addSubview(temp)
        return temp
    }()
    
    convenience init(textColor: UIColor, font: UIFont, lineColor: UIColor) {
        self.init()
        self.lab.textColor = textColor
        self.lab.font = font
        self.lineColor = lineColor
    }

}
