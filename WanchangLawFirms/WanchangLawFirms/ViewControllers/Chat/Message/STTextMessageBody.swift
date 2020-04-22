//
//  STTextMessageBody.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 文字消息
class STTextMessageBody: STMessageBody {
    var text: String
    
    init(text: String) {
        self.text = text
        super.init()
        self.type = .text
    }

}
