//
//  JAvatarImgModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/8.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JAvatarImgModel: NSObject {
    
    var remotePath: String
    var success = { (remotePath: String, endPath: String?, img: UIImage?) in
        
    }
    
    init(remotePath: String) {
        self.remotePath = remotePath
        super.init()
    }

}
