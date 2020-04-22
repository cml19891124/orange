//
//  UserModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/3.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 个人资料
class UserModel: NSObject {
    
    /// 用户信息
    @objc var address: String = ""
    @objc var avatar: String = ""
    @objc var email: String = ""
    @objc var id: String = ""
    @objc var mobile: String = ""
    @objc var nickname: String = ""
    @objc var quantity: String = ""
    @objc var sex: String = ""
    @objc var vip: String = ""
    @objc var vip_expired: String = ""
    
    @objc var uid: String = ""
    
    @objc var recommend_id: String = ""
    
    /// 企业子账户信息
    @objc var username: String = ""
    @objc var co_email: String = ""
    @objc var co_username: String = ""
    @objc var co_name: String = ""
    @objc var co_mobile: String = ""
    
    var open: Bool = false
    
    /// 要显示的性别信息
    var show_sex: String {
        get {
            var temp = ""
            if sex == "1" {
                temp = "sex_man"
            } else if sex == "2" {
                temp = "sex_woman"
            }
            return L$(temp)
        }
    }

}

extension UserModel {
    /// 昵称，未设置昵称时显示手机号
    var j_name: String {
        get {
            if nickname.haveContentNet() == true {
                return nickname
            }
            return mobile
        }
    }
}
