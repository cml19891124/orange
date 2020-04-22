//
//  LHModel.swift
//  LHLabel
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class LHModel: NSObject {
    
    var text: String
    var list: LList?
    
    init(text: String) {
        self.text = text
        super.init()
    }

}
