//
//  STMessage.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 消息状态：发送中、发送成功、发送失败
enum STMessageStatus {
    case develing
    case success
    case failed
}

class STMessage: NSObject {
    
    /// socket返回模型
    private var model: JSocketModel
    /// 消息尺寸计算
    private var cal_size: CGSize?
    /// 消息是否显示时间
    var j_show_time: Bool?
    
    /// 已读
    var isRead: Bool = false
    /// 已读回执
    var isReadAck: Bool = false
    /// 已撤回
    var isWithdrew: Bool = false
    
    
    init(model: JSocketModel) {
        self.model = model
        super.init()
        self.isRead = model.j_isRead
        self.isReadAck = model.j_isReadAck
        self.isWithdrew = model.j_isWithdrew
    }

}

extension STMessage {
    /// 更新消息状态
    func updateMsgStatus(status: String) {
        self.model.j_status = status
        if status == "0" {
            self.j_show_time = nil
            self.model.time = Int64(Date().timeIntervalSince1970 * 1000)
        } else if status == "1" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: id + "_return"), object: nil)
        } else if status == "2" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: id + "_failed"), object: nil)
        }
        RealmManager.share().updateMsgStatus(status, msg_id: id)
        MessageManager.share.onGoRefresh()
    }
    
    /// 更新消息服务端Id
    func updateMsgId(msg_id: String, net_id: String) {
        self.model.net_id = net_id
        RealmManager.share().updateMsgId(msg_id, net_id: net_id)
    }
    
    /// 更新消息为已撤回
    func updateMsgWithdrew() {
        self.isWithdrew = true
        RealmManager.share().updateWithdrew(id)
    }
    
    /// 更新图片消息的本地存储路径
    func updateImgMsgOssUrl(is_snap: Bool, oss_url: String) {
        if is_snap {
            self.model.j_oss_snap_url = oss_url
        } else {
            self.model.j_oss_full_url = oss_url
        }
        RealmManager.share().updateImgMsgOssUrl(id, is_snap: is_snap, oss_url: oss_url)
    }
}

extension STMessage {
    /// 消息从哪来
    var from: String {
        get {
            return model.from
        }
    }
    
    /// 消息到哪去
    var to: String {
        get {
            return model.to
        }
    }
    
    /// 消息的唯一id
    var id: String {
        get {
            if model.net_id.count > 0 {
                return model.net_id
            }
            return model.id
        }
    }
    
    /// 消息的内容
    var content: String {
        get {
            return model.content
        }
    }
    
    /// 消息的时间
    var time: Int64 {
        get {
            let temp1 = "\(model.time)" as NSString
            var temp2 = ""
            if temp1.length >= 10 {
                temp2 = temp1.substring(to: 10)
            } else {
                temp2 = "\(Int(NSDate().timeIntervalSince1970))"
            }
            return Int64(temp2)!
        }
    }
    
    /// 哪个订单编号的消息
    var sn: String {
        get {
            return model.sn
        }
    }
    
    /// 消息的类型
    var type: Int {
        get {
            return model.type
        }
    }
}

extension STMessage {
    
    /// 消息根据哪个model产生的
    var j_model: JSocketModel {
        get {
            return model
        }
    }
    
    /// 图片消息的缩略图路径
    var j_oss_snap_url: String {
        get {
            return model.j_oss_snap_url
        }
    }
    
    /// 图片消息的全路径
    var j_oss_full_url: String {
        get {
            return model.j_oss_full_url
        }
    }
    
    /// 消息的状态
    var status: STMessageStatus {
        get {
            if model.j_status == "0" {
                return .develing
            } else if model.j_status == "1" {
                return .success
            } else if model.j_status == "2" {
                return .failed
            }
            return .success
        }
    }
    
    /// 是我发的消息吗
    var fromMe: Bool {
        get {
            if model.from == UserInfo.share.uid {
                return true
            }
            return false
        }
    }
    
    /// 消息可撤回吗
    var canWithdrew: Bool {
        get {
            if fromMe {
                if status == .success {
                    let current = Int64(Date().timeIntervalSince1970)
                    if current - time < 120 {
                        return true
                    }
                }
            }
            return false
        }
    }
    
    /// 消息显示的时间
    var timeStr: String {
        get {
            let temp1 = "\(time)" as NSString
            var temp2 = ""
            if temp1.length >= 10 {
                temp2 = temp1.substring(to: 10)
            } else {
                temp2 = "\(Int(NSDate().timeIntervalSince1970))"
            }
            return temp2.theChatTimeFromNumStr()
        }
    }
    
    /// 消息体
    var body: STMessageBody {
        get {
            switch bodyType {
            case .text:
                let body = STTextMessageBody.init(text: model.content)
                return body
            case .bigEmo:
                let body = STBigEmoMessageBody.init(text: model.content)
                return body
            case .image:
                let body = STImageMessageBody.init(remotePath: model.content, path: model.j_path)
                return body
            case .file:
                let body = STFileMessageBody.init(remotePath: model.content, name: model.attributeModel.msg_file_name)
                return body
            }
        }
    }
    
    /// 消息体类型
    var bodyType: STMessageBodyType {
        get {
            if model.type == 2 {
                return .bigEmo
            } else if model.type == 3 {
                return .image
            } else if model.type == 4 {
                return .file
            }
            return .text
        }
    }
    
    /// 消息显示时的尺寸
    var size: CGSize {
        get {
            var resultSize: CGSize = CGSize()
            if cal_size != nil {
                return cal_size!
            }
            switch bodyType {
            case .text:
                let textBody = body as! STTextMessageBody
                let ns = textBody.text as NSString
//                if self.model.attributeModel.autoReplyArr.count > 0 {
//                    var tempStr = textBody.text
//                    for m in self.model.attributeModel.autoReplyArr {
//                        tempStr += "\n· "
//                        tempStr += m.keyword
//                    }
//                    ns = tempStr as NSString
//                }
                let tempSize = ns.boundingRect(with: CGSize.init(width: kDeviceWidth - 150, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UserInfo.share.chatFont], context: nil).size
                var tempWidth = tempSize.width + kBubbleSpaceL + kBubbleSpaceS
                var tempHeight = tempSize.height + kLeftSpaceS * 2
                if tempWidth < kBubbleWidthMin {
                    tempWidth = kBubbleWidthMin
                }
                if tempHeight < kBubbleHeightMin {
                    tempHeight = kBubbleHeightMin
                }
                resultSize = CGSize.init(width: tempWidth, height: tempHeight)
                let count = self.j_model.attributeModel.autoReplyArr.count
                if count > 0 {
                    var h = kLeftSpaceS * 2 + 25
                    for m in self.model.attributeModel.autoReplyArr {
                        h += m.height
                    }
                    resultSize = CGSize.init(width: 220 + kBubbleSpaceL + kBubbleSpaceS, height: h)
                }
                break
            case .image:
                resultSize = CGSize.init(width: 100, height: 100)
            case .bigEmo:
                resultSize = CGSize.init(width: 100, height: 100)
            case .file:
                resultSize = CGSize.init(width: 200, height: 70)
            }
            cal_size = resultSize
            return resultSize
        }
    }
    
    /// 文件大小
    var fileLength: Int {
        get {
            guard let temp = Int(self.model.attributeModel.msg_file_length) else {
                return 0
            }
            return temp
        }
    }
    
    /// 参考上条消息，判断当前消息是否显示时间，间隔超过2分钟就显示
    func showTime(referenceMsg: STMessage) -> Bool {
        if j_show_time != nil {
            return j_show_time!
        }
        var show: Bool = false
        if self.time - referenceMsg.time > 180 {
            show = true
        }
        j_show_time = show
        return show
    }
}
