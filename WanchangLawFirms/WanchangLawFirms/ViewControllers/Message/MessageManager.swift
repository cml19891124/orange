//
//  MessageManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/11.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会话管理
class MessageManager: NSObject {
    static let share = MessageManager()
    
    /// 正在处理中订单的会话
    var dealingConversation: [MessageModel] = [MessageModel]()
    
    override init() {
        super.init()
    }

}

extension MessageManager {
    /// 刷新处理中会话列表
    func onGoRefresh() {
        let temp = RealmManager.share().getConversationList("1")
        dealingConversation = temp.sorted(by: { (m1, m2) -> Bool in
            return m1.j_time > m2.j_time
        })
        var count = 0
        for m in dealingConversation {
            count += m.j_unread_count
        }
        UserInfo.share.conversationMsgUnReadCount = count
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_dealing_msg_need_refresh), object: nil)
    }
}

extension MessageManager {
    /// 本地订单会话列表
    func localConversation(status: String) -> [MessageModel] {
        let arr = RealmManager.share().getConversationList(status)
        let temp = arr.sorted { (m1, m2) -> Bool in
            return m1.created_at > m2.created_at
        }
        return temp
    }
    
    /// 本地系统消息列表
    func localSystemMsg() -> [JSocketModel] {
        let arr = RealmManager.share().getAllSystemModelArr()
        let temp = arr.sorted { (m1, m2) -> Bool in
            return m1.time > m2.time
        }
        return temp
    }
}

extension MessageManager {
    /// 服务端会话列表
    func chatList(prams: NSDictionary, success:@escaping(Bool, [MessageModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_chat_list, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let resultDict = dict[net_key_result] as? NSDictionary
                let arr = MessageModel.mj_objectArray(withKeyValuesArray: resultDict?["data"]) as? [MessageModel]
                if arr != nil {
                    let status = prams["status"] as! String
                    if status == "1" {
                        RealmManager.share().updateConversation(onGoing: arr!)
                    } else {
                        RealmManager.share().updateConversationFinished(arr!)
                    }
                    LawyerManager.share.addLawyersByList(arr: arr!)
                }
                success(true, arr)
            } else {
                success(true, nil)
            }
        }) { (error) in
            success(false, nil)
        }
    }
    
    /// 获取某个订单的全部聊天消息
    func chatMsg(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_chat_msg, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = JSocketModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [JSocketModel]
                if arr != nil {
                    RealmManager.share().addHistoryMsgModelArr(arr!)
                }
                UserInfo.share.conversationLoadedAdd(sn: prams["order_sn"] as! String)
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 获取某个订单的全部文件消息
    func chatFiles(prams: NSDictionary, success:@escaping([JSocketModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_chat_msg_file, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = JSocketModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [JSocketModel]
                var temp: [JSocketModel] = [JSocketModel]()
                if arr != nil {
                    for m in arr! {
                        if m.type == 4 && m.from_id != UserInfo.defaultUserUid() {
                            temp.append(m)
                        }
                    }
                }
                success(temp)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 获取离线消息
    func chatOffline(success:@escaping([JSocketModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_chat_offline, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = JSocketModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [JSocketModel]
                if arr != nil {
                    RealmManager.share().addOfflineMsgModelArr(arr!)
                }
                success(arr)
            } else {
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 获取系统消息的离线消息
    func chatSystemOffline(success:@escaping([JSocketModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_chat_system_offline, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = JSocketModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [JSocketModel]
                success(arr)
            } else {
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
    /// 系统消息
    func chatSystem(prams: NSDictionary, success:@escaping(Bool, [JSocketModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_chat_system, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let resultDict = dict[net_key_result] as? NSDictionary
                let arr = JSocketModel.mj_objectArray(withKeyValuesArray: resultDict?["data"]) as? [JSocketModel]
                if arr != nil {
                    RealmManager.share().addSystemArr(arr!)
                }
                success(true, arr)
            } else {
                success(false, nil)
                PromptTool.promptText(dict[net_key_msg], 1)
            }
        }) { (err) in
            success(false, nil)
        }
    }
}
