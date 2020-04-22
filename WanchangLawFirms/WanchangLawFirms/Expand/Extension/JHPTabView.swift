//
//  JHPTabView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/16.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 点击收键盘的UITableView，待完善，使用前请考虑相关问题进行修改。
class JHPTabView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.backgroundColor = UIColor.clear
        self.separatorStyle = .singleLine
        self.separatorColor = kLineGrayColor
        self.separatorInset = UIEdgeInsets.init(top: 0, left: kLeftSpaceS, bottom: 0, right: kLeftSpaceS)
        self.showsVerticalScrollIndicator = false
        self.estimatedRowHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
    
}
