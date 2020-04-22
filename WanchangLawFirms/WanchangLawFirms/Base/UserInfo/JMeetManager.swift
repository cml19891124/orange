//
//  JMeetManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/28.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JMeetModel: NSObject {
    @objc var date: String = ""
    @objc var time: String = "1"
    @objc var reason: String = ""
    @objc var meet_people: String = ""
    @objc var meet_contact_name: String = ""
    @objc var meet_contact_mobile: String = ""
    @objc var choose_lawyer: String = ""
    
    @objc var address: String = ""
    @objc var train_people: String = ""
    @objc var train_content: String = ""
    @objc var train_contact_mobile: String = ""
    
    @objc var remark: String = ""
}

/// 约见管理
class JMeetManager: NSObject {
    static let share = JMeetManager()
    
    var model: JMeetModel = JMeetModel()
    
    func clear() {
        model.date = ""
        model.time = "1"
        model.reason = ""
        model.meet_people = ""
        model.meet_contact_name = ""
        model.meet_contact_mobile = ""
        model.address = ""
        model.train_people = ""
        model.train_content = ""
        model.train_contact_mobile = ""
    }
    
}

extension JMeetManager {
    func companyInlineLawyerCreate(isTeach: Bool, prams: NSDictionary, success:@escaping(Bool, String?) -> Void) {
        var url = api_company_inline_lawyer_create
        if isTeach {
            url = api_company_inline_train_create
        }
        HTTPManager.share.ask(isGet: false, url: url, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let sn = dict[net_key_result] as? String
                UserInfo.share.companyInfo()
                success(true, sn)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false, nil)
            }
        }) { (err) in
            success(false, nil)
        }
    }
    
    func servicesInlineLawyerList(success:@escaping([LawyerModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_service_inline_lawyer_list, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = LawyerModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [LawyerModel]
                if arr != nil {
                    LawyerManager.share.updateLawyers(arr: arr!)
                }
                success(arr)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
    func companyInlineCancel(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_company_inline_cancel, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
                UserInfo.share.companyInfo()
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
}
