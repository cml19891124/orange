//
//  BaseUtil.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/8.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 常用工具在这里添加
class BaseUtil: NSObject {
    
    /// 唯一消息id
    class func uniqueMsgID() -> String {
        let date = Date()
        let timeSp = String(Int64(date.timeIntervalSince1970))
        let i = arc4random() % 1000
        let str = String.init(format: "%03d", i)
        return String.init(format: "%@%@%@", UserInfo.share.uid!, timeSp, str)
    }
    
    /// 检验邮箱是否可用
    class func emailValid(email: String?) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: email)
        return isValid
    }
    
    class func checkAccountRegularValid(username: String) -> Bool {
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5\\d]*$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: username)
    }
    
}
