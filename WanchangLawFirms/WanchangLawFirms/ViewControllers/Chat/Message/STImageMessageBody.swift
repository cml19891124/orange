//
//  STImageMessageBody.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 图片消息
class STImageMessageBody: STMessageBody {
    
    var remotePath: String
    var path: String
    var is_gif: Bool = false
    
    init(remotePath: String, path: String) {
        self.remotePath = remotePath
        self.path = path
        super.init()
        self.type = .image
        let ext = ((remotePath as NSString).pathExtension as NSString).lowercased
        if ext == "gif" {
            is_gif = true
        }
    }

}
