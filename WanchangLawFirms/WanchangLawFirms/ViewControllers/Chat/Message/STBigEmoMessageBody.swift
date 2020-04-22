//
//  STBigEmoMessageBody.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 大表情消息
class STBigEmoMessageBody: STMessageBody {
    
    var text: String
    
    init(text: String) {
        self.text = text
        super.init()
        self.type = .bigEmo
    }

}
