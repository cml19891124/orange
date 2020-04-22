//
//  JSocketHelper.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JSocketHelperDelegate: NSObjectProtocol {
    func jsocketHelperDidReceiveMsg(msg: STMessage)
}

/// socket工具
class JSocketHelper: NSObject {
    static let share = JSocketHelper()
    weak var delegate: JSocketHelperDelegate?
    
    /// 当前socket是否连接，本该是只读属性，注意不要在外部修改
    var connecting: Bool = false
    
    /// 发送消息得到return调用该闭包
    var msgReturnBlock = { (flag: Bool, id: String, net_id: String) in
        
    }
    
    private let webSocket = ZPWebSocket.initSocket()
    
    override init() {
        super.init()
        webSocket.delegate = self
        self.connectionSocket()
    }
    
    /// 连接socket
    func connectionSocket() {
        if UserInfo.share.token != nil {
            webSocket.connect()
            self.connecting = true
        }
    }
    
    /// 关闭socket
    func closeSocket() {
        webSocket.close()
        self.connecting = false
    }

}

extension JSocketHelper: ZPWebSocketDelegate {
    /// 重连socket
    func reconnectionSocket() {
        self.loginSocket()
    }
    
    /// 收到返回数据
    func webSocketReceiveDataStr(_ str: String?) {
//        guard let resultStr = str else {
//            return
//        }
//        guard let resultStr = AES.decryptAES(str, key: UserInfo.share.aes_key, iv: UserInfo.share.aes_iv) else {
//            return
//        }
        guard let str1 = str else {
            return
        }
        var resultStr = str1
        /// 先对消息解密
        let str2 = AES.decryptAES(str1, key: UserInfo.share.aes_key, iv: UserInfo.share.aes_iv)
        /// 解密失败，可能是未加密，直接解析即可
        if str2?.haveTextStr() == true {
            resultStr = str2!
        }
        DEBUG("socket_return = " + resultStr)
        /// 都无法解析，就跳转到登陆界面
        guard let data = resultStr.data(using: String.Encoding.utf8) else {
            JRootVCManager.share.rootLogin()
            return
        }
        let temp1 = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        guard let dict = temp1 else {
            JRootVCManager.share.rootLogin()
            return
        }
        let tempM = JSocketModel.mj_object(withKeyValues: dict)
        guard let model = tempM else {
            return
        }
        
        if model.event.haveContentNet() == true {
            /// 授权登陆、发送消息返回、被剔除、以及ping
            if model.event == "auth" {
                self.dealLogin(model: model)
            } else if model.event == "return" {
                self.dealReturn(model: model)
            } else if model.event == "kickoff" {
                JRootVCManager.share.kickOff(content: model.content)
            } else if model.event == "pong" {
                webSocket.pingBlock()
            }
        } else if model.push_type.haveContentNet() == true {
            /// 系统消息
            self.dealSystem(model: model)
        } else if model.id.haveContentNet() == true {
            /// 收到消息后要告诉服务端消息已接收
            self.sendReceive(id: model.id)
            
            if (model.type > 0 && model.type < 5) || model.type == 7 {// 要在界面上显示的消息
                self.dealMessage(model: model)
                if model.type == 7 {
                    self.dealOrderTransform()
                }
            } else if model.type == 5 { //已读
                ChatManager.share.receiveRead(sn: model.sn)
            } else if model.type == 6 { //撤回
                ChatManager.share.receiveWithdrew(model: model)
            }
            /// 刷新正在处理中的会话列表状态（最后一条消息以及最后一条消息状态等）
            MessageManager.share.onGoRefresh()
        }
    }
}

extension JSocketHelper {
    /// 登陆socket
    func loginSocket() {
        guard let token = UserInfo.share.token else {
            return
        }
        let prams: NSDictionary = ["event":"auth","content":token]
        guard let jsonStr = prams.mj_JSONString() else {
            return
        }
        webSocket.send(jsonStr)
    }
}

extension JSocketHelper {
    /// 登陆成功或失败进行的操作
    private func dealLogin(model: JSocketModel) {
        if model.content == "success" {
            self.loginSuccessGetOffline()
            self.loginSuccessGetSystemOffline()
            ChatManager.share.sendUnSend()
        } else {
            JRootVCManager.share.rootLogin()
        }
    }
    
    /// 处理消息
    private func dealMessage(model: JSocketModel) {
        ChatManager.share.receiveChatMsg(model: model)
        if !model.j_already_exist {
            let msg = STMessage.init(model: model)
            self.lastDealMsg(msg: msg)
        }
    }
    
    /// 发送消息返回
    private func dealReturn(model: JSocketModel) {
        let msg_id = model.content
        msgReturnBlock(true, msg_id, model.attribute)
    }
    
    /// 处理系统消息
    private func dealSystem(model: JSocketModel) {
        if model.attributeModel.vip.haveTextStr() == true {
            UserInfo.share.netUserInfo()
        } else if model.attributeModel.order_sn.haveTextStr() == true {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: model.attributeModel.order_sn), object: nil)
        }
        self.systemNotiPost()
        JVoiceMoveManager.share.noti()
    }
    
    /// 接收到系统订单消息，要刷新相应的界面
    private func systemNotiPost() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_system_msg_refresh), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_user_order_change), object: nil)
    }
    
    /// 订单被转接
    private func dealOrderTransform() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_order_transform), object: nil)
    }
    
}

extension JSocketHelper {
    /// 处理消息
    private func lastDealMsg(msg: STMessage) {
        self.msgDelegateAction(msg: msg)
        JVoiceMoveManager.share.noti()
    }
    
    private func msgDelegateAction(msg: STMessage) {
        if self.delegate != nil {
            self.delegate?.jsocketHelperDidReceiveMsg(msg: msg)
        } else {
            if msg.sn == "" {
                UserInfo.chatOnlineServiceNoti(text: "1")
            }
        }
    }
}

extension JSocketHelper {
    /// 获取离线消息
    private func loginSuccessGetOffline() {
        MessageManager.share.chatOffline { (arr) in
            if arr != nil && arr!.count > 0 {
                for m in arr! {
                    if m.id.haveTextStr() == true {
                        if !m.push_type.haveContentNet() {
                            self.sendReceive(id: m.id)
                        }
                    }
                    if !m.j_already_exist {
                        if !m.push_type.haveContentNet() {
                            if m.type > 0 && m.type < 5 {
                                let msg = STMessage.init(model: m)
                                self.msgDelegateAction(msg: msg)
                            } else if m.type == 6 {
                                ChatManager.share.receiveWithdrew(model: m)
                            } else if m.type == 7 {
                                self.dealOrderTransform()
                            }
                        }
                    }
                }
            }
            MessageManager.share.onGoRefresh()
        }
    }
    
    /// 登陆成功后获取离线消息
    private func loginSuccessGetSystemOffline() {
        MessageManager.share.chatSystemOffline { (arr) in
            if arr != nil && arr!.count > 0 {
                self.systemNotiPost()
            }
        }
    }
}

extension JSocketHelper {
    /// 发送消息
    func sendMsg(msg: STMessage, success:@escaping(Bool, String, String) -> Void) {
        let prams: NSDictionary = ["from":msg.from,"to":msg.to,"content":msg.content,"sn":msg.sn,"id":msg.id,"type":msg.type,"time":msg.time,"attribute":msg.j_model.attribute]
        guard let jsonStr = prams.mj_JSONString() else {
            return
        }
        self.aes_send(jsonStr: jsonStr)
        msgReturnBlock = { (flag, id, net_id) in
            success(flag, id, net_id)
        }
    }
    
    /// 发送消息
    func sendModel(model: JSocketModel, success:@escaping(Bool, String, String) -> Void) {
        let prams: NSDictionary = ["from":model.from,"to":model.to,"content":model.content,"sn":model.sn,"id":model.id,"type":model.type,"time":model.time,"attribute":model.attribute]
        guard let jsonStr = prams.mj_JSONString() else {
            return
        }
        self.aes_send(jsonStr: jsonStr)
        msgReturnBlock = { (flag, id, net_id) in
            success(flag, id, net_id)
        }
    }
    
    /// 发送已收到
    func sendReceive(id: String) {
        let prams: NSDictionary = ["event":"return","content":id]
        guard let jsonStr = prams.mj_JSONString() else {
            return
        }
        self.aes_send(jsonStr: jsonStr)
    }
}

extension JSocketHelper {
    /// 加密消息后发送
    private func aes_send(jsonStr: String) {
//        webSocket.send(jsonStr)
        guard let resultStr = AES.encryptAES(jsonStr, key: UserInfo.share.aes_key, iv: UserInfo.share.aes_iv) else {
            return
        }
        webSocket.send(resultStr)
    }
}
