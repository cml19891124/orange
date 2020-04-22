//
//  JImgModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/14.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JImgModel: NSObject {
    
    var remotePath: String = "" {
        didSet {
            oss_snap_path = OSSManager.initWithShare().allSnapUrlStr(by: remotePath)
        }
    }
    var oss_snap_path: String = ""
    
    var snapImg: UIImage?

}
