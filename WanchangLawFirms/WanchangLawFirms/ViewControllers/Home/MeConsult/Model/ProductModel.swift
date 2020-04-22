//
//  ProductModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 产品详情
class ProductModel: NSObject {
    
    @objc var category_id: String = ""
    @objc var category_name: String = ""
    @objc var created_at: String = ""
    @objc var desc: String = ""
    @objc var id: String = ""
    @objc var image: String = ""
    @objc var price: String = ""
    @objc var sn: String = ""
    @objc var sort: String = ""
    @objc var status: String = ""
    @objc var sub_title: String = ""
    @objc var symbol: String = ""
    @objc var thumb: String = ""
    @objc var title: String = ""
    @objc var updated_at: String = ""
    
    @objc var content: String = ""
    @objc var type: String = ""
    
    @objc var cate_type: String = ""
    
    @objc var information: String = ""
    
    var j_content: String = ""
    var j_images: String = ""
    var j_files: String = ""
    
    var j_isDocument: Bool = false
    var j_pid: String = ""
    var j_email: String = ""
    
    var urlStr: String {
        get {
            let ns = thumb as NSString
            if ns.contains("http://") || ns.contains("https://") {
                return thumb
            }
            return BASE_URL + thumb
        }
    }
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["desc":"description"]
    }
    
    convenience init(isDocument: Bool, pid: String, email: String) {
        self.init()
        self.j_isDocument = isDocument
        self.j_pid = pid
        self.j_email = email
    }

}

extension ProductModel {
    var business_discount_show_str: String {
        get {
            guard var temp = Float(price) else {
                return ""
            }
            if UserInfo.share.businessModel?.vip == "4" {
                temp *= 0.85
            } else if UserInfo.share.businessModel?.vip == "3" {
                temp *= 0.9
            } else if UserInfo.share.businessModel?.vip == "2" {
                if id != "12" {
                    temp *= 0.95
                }
            } else if UserInfo.share.businessModel?.vip == "1" {
                if id != "12" {
                    temp *= 0.95
                }
            }
            return String.init(format: "¥%.2f", temp)
        }
    }
}
