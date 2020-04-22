//
//  BaseHeaderFooterSpaceView.swift
//  Stormtrader
//
//  Created by lh on 2018/8/21.
//  Copyright © 2018年 gaming17. All rights reserved.
//

import UIKit

/// 空白的头和脚
class BaseHeaderFooterSpaceView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = kBaseColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
