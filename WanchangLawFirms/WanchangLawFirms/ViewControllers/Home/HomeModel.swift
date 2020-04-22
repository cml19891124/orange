//
//  HomeModel.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 首页文章列表模型
class HomeModel: NSObject {
    
    @objc var category_id: String = ""
    @objc var content: String = ""
    @objc var cover: String = ""
    @objc var created_at: String = ""
    @objc var id: String = ""
    @objc var is_recommend: String = ""
    @objc var link: String = ""
    @objc var pv: String = ""
    @objc var source: String = ""
    @objc var status: String = ""
    @objc var sub_title: String = ""
    @objc var symbol: String = ""
    @objc var thumb: String = ""
    @objc var title: String = ""
    @objc var type: String = ""
    
    var urlStr: String {
        get {
            let ns = thumb as NSString
            if ns.contains("http://") || ns.contains("https://") {
                return thumb
            }
            return BASE_URL + thumb
        }
    }
    
}
