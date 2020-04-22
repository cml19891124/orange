//
//  ChatTimeHeaderView.swift
//  Stormtrader
//
//  Created by lh on 2018/8/29.
//  Copyright © 2018年 gaming17. All rights reserved.
//

import UIKit

/// 聊天时间视图
class ChatTimeHeaderView: UITableViewHeaderFooterView {
    
    var timeStr: String! {
        didSet {
            if timeStr == "" {
                lab.isHidden = true
                return
            }
            lab.isHidden = false
            lab.text = timeStr
            let w = CGFloat(Int(lab.sizeThatFits(CGSize.init(width: kDeviceWidth, height: 20)).width + kLeftSpaceL))
            lab.frame = CGRect.init(x: (kDeviceWidth - w) / 2, y: 5, width: w, height: 20)
        }
    }

    private let lab: UILabel = UILabel.init(kFontS, UIColor.white, NSTextAlignment.center)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        lab.layer.cornerRadius = kBtnCornerR
        lab.clipsToBounds = true
        lab.backgroundColor = kGrayColor
        self.addSubview(lab)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
