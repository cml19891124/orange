//
//  JVipListModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/10.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JVipListModel: NSObject {
    
    @objc var begin_at: String = ""
    @objc var discount_price: String = ""
    @objc var expire_at: String = ""
    @objc var id: String = ""
    @objc var price: String = ""
    @objc var quantity: String = ""
    @objc var sort: String = ""
    @objc var vip_discount: String = ""
    @objc var vip_expire: String = ""
    @objc var vip_info: String = ""
    @objc var vip_name: String = ""

}

extension JVipListModel {
    var j_time_str: String {
        get {
            guard let temp = Int(vip_expire) else {
                return "有效期1年"
            }
            if temp < 12 {
                return "有效期\(temp)个月"
            }
            let year = temp / 12
            return "有效期\(year)年"
        }
    }
    
    var index: Int {
        get {
            return Int(sort) ?? 0
        }
    }
}
