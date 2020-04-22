//
//  STMessageBody.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

enum STMessageBodyType {
    case text
    case image
    case bigEmo
    case file
}

/// 消息体
class STMessageBody: NSObject {
    var type: STMessageBodyType = .text
}
