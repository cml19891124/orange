//
//  JBindModel.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 绑定模型
class JBindModel: NSObject {
    
    var bind: String
    var selected: Bool = false
    var width: CGFloat = 0
    
    var id: String = ""
    
    init(bind: String, font: UIFont) {
        self.bind = bind
        super.init()
        let ns = L$(bind) as NSString
        width = ns.boundingRect(with: CGSize.init(width: kDeviceWidth, height: 30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).width + kLeftSpaceS
    }

}
