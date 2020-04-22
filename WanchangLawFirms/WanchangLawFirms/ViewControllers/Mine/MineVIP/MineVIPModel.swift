//
//  MineVIPModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/6.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineVIPModel: NSObject {
    
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
            let m3: VipFuncModel = VipFuncModel.mj_object(withKeyValues: vipDict)
            let m4: VipFuncModel = VipFuncModel.mj_object(withKeyValues: rightsDict)
            RemindersManager.share.updateTitleContent(bind: "vip_consult", title: m1.title, content: m1.content)
            RemindersManager.share.updateTitleContent(bind: "vip_template", title: m2.title, content: m2.content)
            RemindersManager.share.updateTitleContent(bind: "vip_rank", title: m3.title, content: m3.content)
            RemindersManager.share.updateTitleContent(bind: "m_vip_regular", title: m4.title, content: m4.content)
            RemindersManager.share.updateContent(bind: "vip_sum", content: m3.info)
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

}

class VipFuncModel: NSObject {
    @objc var title: String = ""
    @objc var content: String = ""
    @objc var info: String = ""
    
    convenience init(title: String, content:String) {
        self.init()
        self.title = title
        self.content = content
    }
}
