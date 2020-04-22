//
//  MineBusinessVIPModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/27.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineBusinessVIPModel: NSObject {
    @objc var category_id: String = ""
    @objc var content: String = "" {
        didSet {
            guard let data = content.data(using: String.Encoding.utf8) else {
                return
            }
            let d1 = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            guard let d3 = d1 else {
                return
            }
            let questionDict = d3["question"] as? NSDictionary
            let templateDict = d3["template"] as? NSDictionary
            let vipDict = d3["vip"] as? NSDictionary
            let rightsDict = d3["rights"] as? NSDictionary
            let m1: VipFuncModel = VipFuncModel.mj_object(withKeyValues: questionDict)
            let m2: VipFuncModel = VipFuncModel.mj_object(withKeyValues: templateDict)
            businessVipModel = BusinessVipFuncModel.mj_object(withKeyValues: vipDict)
            let m4: VipFuncModel = VipFuncModel.mj_object(withKeyValues: rightsDict)
            RemindersManager.share.updateTitleContent(bind: "vip_consult", title: m1.title, content: m1.content)
            RemindersManager.share.updateTitleContent(bind: "vip_template", title: m2.title, content: m2.content)
//            RemindersManager.share.updateTitleContent(bind: "vip_rank", title: m3.title, content: m3.content)
            RemindersManager.share.updateTitleContent(bind: "m_vip_regular", title: m4.title, content: m4.content)
            RemindersManager.share.updateContent(bind: "vip_sum", content: businessVipModel.info)
        }
    }
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
    
    var businessVipModel: BusinessVipFuncModel = BusinessVipFuncModel()
    
}

class BusinessVipFuncModel: NSObject {
    @objc var title: String = ""
    @objc var content: NSArray? {
        didSet {
            let arr = VipFuncModel.mj_objectArray(withKeyValuesArray: content) as? [VipFuncModel]
            if arr != nil {
                vipArr = arr!
            }
        }
    }
    @objc var info: String = ""
    
    lazy var vipArr: [VipFuncModel] = {
        () -> [VipFuncModel] in
        var arr: [String] = ["黄金会员3888元/年，免费咨询（仅限企业问题）无限次；\n除律师函外的付费服务一律9.5折；\n文书模版免费下载。","钻石会员8800元/年，免费咨询（仅限企业问题）无限次；\n文书定制+文书审查共12次（不包含律师函）；\n除律师函外的付费服务一律9.5折；\n文书模版免费下载。","星耀会员13800元/年，免费咨询（仅限企业问题）无限次；\n文书定制+文书审查共24次（不包含律师函）;\n律师约见2次，每次约见时长为2小时内；\n付费服务一律9折；\n文书模版免费下载。","荣耀会员18800元/年，免费咨询（仅限企业问题）无限次；\n文书审查+文书定制共36次（不包含律师函）；\n律师约见4次，每次约见时长为2小时内（律师约见绿色通道优先推送服务）；\n在原有基础上赠送1个子账号（即拥有两个子账号）；\n付费服务一律8.5折；\n企业培训共1次；\n文书模版免费下载。"]
        var temp = [VipFuncModel]()
        for str in arr {
            let m = VipFuncModel.init(title: "", content: str)
            temp.append(m)
        }
        return temp
    }()
}
