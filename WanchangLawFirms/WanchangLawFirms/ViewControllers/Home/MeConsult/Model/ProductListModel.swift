//
//  ProductListModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/5.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 产品列表模型
class ProductListModel: NSObject {

    @objc var category_id: String = ""
    @objc var created_at: String = ""
    @objc var desc: String = ""
    @objc var id: String = ""
    @objc var image: String = ""
    @objc var price: String = ""
    @objc var sort: String = ""
    @objc var status: String = ""
    @objc var sub_title: String = ""
    @objc var symbol: String = ""
    @objc var thumb: String = ""
    @objc var title: String = ""
    @objc var updated_at: String = ""
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["desc":"description"]
    }
}
