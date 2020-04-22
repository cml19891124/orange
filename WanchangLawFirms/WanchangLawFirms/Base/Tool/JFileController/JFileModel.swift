//
//  JFileModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JFileModel: NSObject {
    
    @objc var remotePath: String
    @objc var name: String
    @objc var fileSize: String
    
    @objc var localPath: String = ""
    
    var imgName: String = ""
    var selected: Bool = false
    
    var endUrlStr: String {
        get {
            let ns = remotePath as NSString
            if ns.contains("http://") || ns.contains("https://") {
                guard let temp = remotePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                    return ""
                }
                return temp
            }
            return OSSManager.initWithShare().allUrlStr(by: remotePath)
        }
    }
    
    var progress = { (value: Float) in
        
    }
    var success = { (endPath: String) in
        
    }
    
    @objc init(remotePath: String, name: String, fileSize: String) {
        self.remotePath = remotePath
        self.name = name
        self.fileSize = fileSize
        super.init()
        self.imgName = JFileManager.share.getFileImgName(remotePath: remotePath)
        self.localPath = OSSManager.initWithShare().savePath(remotePath)
    }
}
