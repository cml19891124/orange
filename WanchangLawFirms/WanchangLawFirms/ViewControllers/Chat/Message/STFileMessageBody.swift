//
//  STFileMessageBody.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/7.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 文件消息
class STFileMessageBody: STMessageBody {
    
    var remotePath: String
    var name: String
    
    init(remotePath: String, name: String) {
        self.remotePath = remotePath
        self.name = name
        super.init()
        self.type = .file
    }

}
