//
//  JPayModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/10.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

enum JPayModelServiceType {
    case custom
    case vip
}

class JPayModel: NSObject {
    
    var service_type: JPayModelServiceType = .custom
    var price: String = ""
    var id: String = ""
    var content: String = ""
    var images: String = ""
    var files: String = ""
    
    var j_isDocument: Bool = false
    var j_pid: String = ""
    var j_email: String = ""
    
    convenience init(service_type: JPayModelServiceType, id: String, price: String, content: String) {
        self.init()
        self.service_type = service_type
        self.id = id
        self.price = price
        self.content = content
    }
    

}

extension JPayModel {
    var j_price: Float {
        get {
            guard let temp = Float(price) else {
                return 0
            }
            return temp
        }
    }
}
