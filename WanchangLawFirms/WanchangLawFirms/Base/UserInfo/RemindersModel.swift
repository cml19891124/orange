//
//  RemindersModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/10.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 温馨提示等数据类型
class RemindersModel: NSObject {

    /// 绑定的健
    var bind: String
    /// 显示的内容
    var content: String
    
    /// 标题
    var net_title: String?
    /// 内容
    var net_content: String?
    /// 说明
    var net_explain: String?
    
    init(bind: String, content: String) {
        self.bind = bind
        self.content = content
        super.init()
    }

}

extension RemindersModel {
    /// 最终显示的标题，先显示本地数据，网络请求成功后返回网络数据
    var showTitle: String {
        get {
            if net_title?.haveContentNet() == true {
                return net_title!
            }
            return L$(bind)
        }
    }
    /// 最终显示的内容
    var showContent: String {
        get {
            if net_content?.haveContentNet() == true {
                return net_content!
            }
            return content
        }
    }
}
