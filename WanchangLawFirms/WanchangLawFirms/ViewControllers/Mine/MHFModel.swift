//
//  MHFModel.swift
//  OLegal
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我的头部详情
class MHFModel: NSObject {
    
    var bind: String
    
    init(bind: String) {
        self.bind = bind
        super.init()
    }

}

extension MHFModel {
    var descStr: String {
        get {
            if bind == "m_vip_level" {
                if UserInfo.share.is_business {
                    if UserInfo.share.businessModel?.vip == "1" {
                        return "黄金会员"
                    } else if UserInfo.share.businessModel?.vip == "2" {
                        return "钻石会员"
                    } else if UserInfo.share.businessModel?.vip == "3" {
                        return "星耀会员"
                    } else if UserInfo.share.businessModel?.vip == "4" {
                        return "荣耀会员"
                    }
                } else {
                    if UserInfo.share.model?.vip == "1" {
                        return "钻石会员"
                    } else if UserInfo.share.model?.vip == "2" {
                        return "星耀会员"
                    } else if UserInfo.share.model?.vip == "3" {
                        return "荣耀会员"
                    }
                }
                return "注册会员"
            } else if bind == "m_vip_number" {
                return UserInfo.share.model?.id ?? ""
            } else if bind == "m_vip_date" {
                if UserInfo.share.is_business {
                    if UserInfo.share.businessModel?.vip_expired != nil {
                        return (UserInfo.share.businessModel?.vip_expired)!.theDateYMDStr()
                    }
                } else {
                    if UserInfo.share.model?.vip_expired != nil {
                        return (UserInfo.share.model?.vip_expired)!.theDateYMDStr()
                    }
                }
                return "---"
            } else if bind == "m_question_count" {
                return UserInfo.share.model?.quantity ?? ""
            } else if bind == "m_vip_property" {
                if UserInfo.share.isMother {
                    return "母账号"
                }
                return "子账号"
            }
            return ""
        }
    }
}
