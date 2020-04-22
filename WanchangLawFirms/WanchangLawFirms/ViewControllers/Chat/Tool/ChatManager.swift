//
//  ChatManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/7.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol ChatManagerDelegate: NSObjectProtocol {
    /// 收到已读
    func chatManagerReceiveRead(sn: String)
    /// 收到撤回
    func chatManagerReceiveWithdrew(model: JSocketModel)
}

class ChatManager: NSObject {
    static let share = ChatManager()
    
    weak var delegate: ChatManagerDelegate?
    
    private var messageArr: [STMessage] = [STMessage]()
    private var modelArr: [JSocketModel] = [JSocketModel]()
    
    private var current_is_upload: Bool = false
    private var waitImgMsgsArr: [STMessage] = [STMessage]()
    
    var haveTask: Bool {
        if messageArr.count == 0 {
            return false
        }
        return true
    }
    
    override init() {
        super.init()
    }

}

extension ChatManager {
    /// 发送正在发送中的消息，发生在socket重连
    func sendUnSend() {
        var ossMsg: [STMessage] = [STMessage]()
        for m in modelArr {
            JSocketHelper.share.sendModel(model: m) { (flag, id, net_id) in
                self.dealModelReturn(flag: flag, id: id, net_id: net_id)
            }
        }
        for m in self.messageArr {
            if m.bodyType == .image {
                ossMsg.append(m)
            } else if m.bodyType == .text || m.bodyType == .bigEmo {
                JSocketHelper.share.sendMsg(msg: m) { (flag, id, net_id) in
                    self.sendReturnDeal(flag: flag, id: id, net_id: net_id)
                }
            } else if m.bodyType == .file {
                let endPath = JPhotoManager.share.uploadPath(path: m.j_model.j_path)
                let url = URL.init(fileURLWithPath: endPath)
                let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                if data == nil {
                    JSocketHelper.share.sendMsg(msg: m) { (flag, id, net_id) in
                        self.sendReturnDeal(flag: flag, id: id, net_id: net_id)
                    }
                } else {
                    ossMsg.append(m)
                }
            }
        }
        self.chatUpload(msgArr: ossMsg)
    }
}

extension ChatManager {
    /// 文本消息、大表情消息
    func addChatMsg(msg: STMessage) {
        messageArr.append(msg)
        RealmManager.share().addMsgModel(msg.j_model)
        JSocketHelper.share.sendMsg(msg: msg) { (flag, id, net_id) in
            self.sendReturnDeal(flag: flag, id: id, net_id: net_id)
        }
    }
    
    /// 图片消息
    func addChatImageMsgArr(msgArr: [STMessage]) {
        var mArr: [JSocketModel] = [JSocketModel]()
        for msg in msgArr {
            messageArr.append(msg)
            mArr.append(msg.j_model)
        }
        RealmManager.share().addMsgModelArr(mArr)
        if !current_is_upload {
            self.chatUpload(msgArr: msgArr)
        } else {
            for msg in msgArr {
                waitImgMsgsArr.append(msg)
            }
        }
    }
    
    /// 文件消息
    func addChatFileMsgArr(msgArr: [STMessage]) {
        var mArr: [JSocketModel] = [JSocketModel]()
        for msg in msgArr {
            messageArr.append(msg)
            mArr.append(msg.j_model)
        }
        RealmManager.share().addMsgModelArr(mArr)
        for msg in msgArr {
            JSocketHelper.share.sendMsg(msg: msg) { (flag, id, net_id) in
                self.sendReturnDeal(flag: flag, id: id, net_id: net_id)
            }
        }
    }
    
    /// 发送成功后更新消息状态
    private func sendReturnDeal(flag: Bool, id: String, net_id: String) {
        for i in 0..<messageArr.count {
            let msg = messageArr[i]
            if msg.id == id {
                if flag {
                    msg.updateMsgStatus(status: "1")
                    if net_id.count > 0 {
                        msg.updateMsgId(msg_id: id, net_id: net_id)
                    }
                } else {
                    msg.updateMsgStatus(status: "2")
                }
                messageArr.remove(at: i)
                break
            }
        }
        if UIApplication.shared.applicationState == .background {
            if messageArr.count == 0 {
                JSocketHelper.share.closeSocket()
            }
        }
    }
}

extension ChatManager {
    /// 发送已读
    func addRead(model: JSocketModel) {
        modelArr.append(model)
        JSocketHelper.share.sendModel(model: model) { (flag, id, net_id) in
            self.dealModelReturn(flag: flag, id: id, net_id: net_id)
        }
    }
    
    /// 处理服务端消息id
    private func dealModelReturn(flag: Bool, id: String, net_id: String) {
        for i in 0..<modelArr.count {
            let m = modelArr[i]
            if m.id == id {
                modelArr.remove(at: i)
                break
            }
        }
    }
}

extension ChatManager {
    /// 撤回消息
    func withdrewMsg(model: JSocketModel, success:@escaping(Bool) -> Void) {
        if HTTPManager.share.net_unavaliable {
            PromptTool.promptText(L$("net_unavailable"), 1)
            success(false)
            return
        }
        let vv = JPhotoPromptView.init(bind: "withdrewing")
        JSocketHelper.share.sendModel(model: model) { (flag, id, net_id) in
            vv.removeFromSuperview()
            success(true)
        }
    }
}

extension ChatManager {
    /// 图片上传
    private func chatUpload(msgArr: [STMessage]) {
        var i = 0
        var needWait = false
        current_is_upload = true
        JQueueManager.share.globalAsyncQueue {
            while i < msgArr.count {
                if needWait {

                } else {
                    if i >= msgArr.count {
                        break
                    }
                    if HTTPManager.share.net_unavaliable {
                        return
                    }
                    needWait = true
                    if i >= msgArr.count {
                        break
                    }
                    let msg = msgArr[i]
                    let m = msg.j_model
                    let objKey = m.content
                    let localPath = JPhotoManager.share.uploadPath(path: m.j_path)
                    OSSManager.initWithShare().uploadFilePath(localPath, objKey: objKey, progress: { (progre) in

                    }, complete: { (remotePath) in
                        if remotePath.haveTextStr() == true {
                            for msg in msgArr {
                                if msg.j_model.content == remotePath {
                                    JSocketHelper.share.sendMsg(msg: msg, success: { (flag, id, net_id) in
                                        self.sendReturnDeal(flag: flag, id: id, net_id: net_id)
                                    })
                                    break
                                }
                            }
                        } else {
                            msg.updateMsgStatus(status: "2")
                        }
                        i += 1
                        needWait = false
                    })
                }
            }
            self.current_is_upload = false
            if self.waitImgMsgsArr.count > 0 {
                self.chatUpload(msgArr: self.waitImgMsgsArr)
                self.waitImgMsgsArr.removeAll()
            }
        }
    }
    
}

extension ChatManager {
    /// 收到消息
    func receiveChatMsg(model: JSocketModel) {
        RealmManager.share().addMsgModel(model)
    }
    
    /// 收到已读
    func receiveRead(sn: String) {
        RealmManager.share().updateRead(sn, isReadAck: false)
        self.delegate?.chatManagerReceiveRead(sn: sn)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: sn + "_read"), object: nil)
    }
    
    /// 收到撤回
    func receiveWithdrew(model: JSocketModel) {
        RealmManager.share().updateWithdrew(model.content)
        self.delegate?.chatManagerReceiveWithdrew(model: model)
    }
    
}
