//
//  MessageModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/6.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会话模型
class MessageModel: NSObject {
    
    @objc var amount: String = ""
    @objc var avatar: String = ""
    @objc var created_at: String = ""
    @objc var desc: String = ""
    @objc var name: String = ""
    @objc var order_sn: String = ""
    @objc var product_title: String = ""
    @objc var id: String = ""
    @objc var is_deleted: String = ""
    
    @objc var images: String = ""
    @objc var comment_at: String = ""
    @objc var comment_content: String = ""
    @objc var comment_star: String = ""
    @objc var cost_price: String = ""
    @objc var finished_at: String = ""
    @objc var lawyer_id: String = ""
    @objc var number: String = ""
    @objc var order_status: String = ""
    @objc var paid_at: String = ""
    @objc var paid_status: String = ""
    @objc var paid_type: String = ""
    @objc var price: String = ""
    @objc var product_id: String = ""
    @objc var uid: String = ""
    
    @objc var pay_code: String = ""
    @objc var pay_tips: String = ""
    
    @objc var vip_id: String = ""
    
    @objc var attribute: String = "" {
        didSet {
            guard let data = attribute.data(using: String.Encoding.utf8) else {
                return
            }
            let dict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            if dict?["files"] != nil {
                let arr = MessageFileModel.mj_objectArray(withKeyValuesArray: dict?["files"]) as? [MessageFileModel]
                if arr != nil {
                    fileModelArr = arr!
                }
            } else {
                let m = JMeetModel.mj_object(withKeyValues: dict)
                if m != nil {
                    self.meetModel = m!
                }
            }
        }
    }
    
    @objc var fileModelArr: [MessageFileModel] = [MessageFileModel]()
    var meetModel: JMeetModel = JMeetModel()
    
    @objc var co_name: String = ""
    @objc var  co_username: String = ""
    
    @objc var lastMsgModel: JSocketModel? {
        didSet {
            if lastMsgModel != nil {
                self.latestMsg = STMessage.init(model: lastMsgModel!)
            }
        }
    }
    var latestMsg: STMessage?
    var question_show: String {
        get {
            var temp1: String = desc
            if desc.count > 70 {
                temp1 = (desc as NSString).substring(to: 69)
                temp1 += "..."
            }
            return temp1
        }
    }
    var chat_show: String {
        get {
            var temp2 = ""
            if latestMsg != nil {
                if latestMsg?.isWithdrew == true {
                    if latestMsg?.fromMe == true {
                        temp2 = "你撤回了一条消息"
                    } else {
                        temp2 = "对方撤回了一条消息"
                    }
                } else {
                    switch latestMsg!.bodyType {
                    case .text:
                        if latestMsg?.j_model.type == 7 {
                            temp2 = latestMsg!.j_model.content
                        } else {
                            temp2 = " " + (lastMsgModel?.content ?? "")
                        }
                        break
                    case .bigEmo:
                        temp2 = " [大表情]"
                        break
                    case .file:
                        temp2 = " [文件]"
                        break
                    case .image:
                        temp2 = " [图片]"
                        break
                    }
                }
            }
            return temp2
        }
    }
    var statusMulStr: NSMutableAttributedString {
        get {
            if latestMsg?.isWithdrew == true {
                return NSMutableAttributedString.init(string: "")
            }
            if latestMsg?.j_model.type == 7 {
                return NSMutableAttributedString.init(string: "")
            }
            if latestMsg?.fromMe == true {
                if latestMsg?.status == .develing {
                    let attchment = NSTextAttachment()
                    attchment.image = UIImage.init(named: "msg_send_ing")
                    attchment.bounds = CGRect.init(x: 0, y: -3, width: kFontMS.lineHeight, height: kFontMS.lineHeight)
                    return NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: attchment))
                } else if latestMsg?.status == .failed {
                    let attchment = NSTextAttachment()
                    attchment.image = UIImage.init(named: "msg_send_fail")
                    attchment.bounds = CGRect.init(x: 0, y: -3, width: kFontMS.lineHeight, height: kFontMS.lineHeight)
                    return NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: attchment))
                } else {
                    var temp = "[未读]"
                    if latestMsg?.isRead == true {
                        temp = "[已读]"
                    }
                    let mulStr = NSMutableAttributedString.init(string: temp)
                    mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeLightColor, range: NSRange.init(location: 0, length: temp.count))
                    return mulStr
                }
            } else {
                let temp = name + ":"
                let mulStr = NSMutableAttributedString.init(string: temp)
                mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeLightColor, range: NSRange.init(location: 0, length: temp.count))
//                mulStr.addAttribute(NSAttributedString.Key.font, value: UIFont.italicSystemFont(ofSize: 14), range: NSRange.init(location: 0, length: temp.count))
//                mulStr.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber.init(value: NSUnderlineStyle.single.rawValue), range: NSRange.init(location: 0, length: temp.count))
                return mulStr
            }
        }
    }
    
    var j_find: Bool = false
    @objc var j_time: Int64 = 0
    @objc var j_unread_count: Int = 0
    @objc var input_text: String = ""

    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["desc":"description"]
    }
    
    /// 加载消息
    func loadMsgFrom(id: String, success:@escaping([STMessage]) -> Void) {
        let arr = RealmManager.share().getSocketModel(fromMessageId: id, trade_sn: order_sn)
        var mulArr: [STMessage] = [STMessage]()
        for m in arr {
            let msg = STMessage.init(model: m)
            mulArr.append(msg)
        }
        success(mulArr)
    }
    
    func loadAllFile(success:@escaping([STMessage]) -> Void) {
        let arr = RealmManager.share().getChatFiles(order_sn)
        var mulArr: [STMessage] = [STMessage]()
        for m in arr {
            let msg = STMessage.init(model: m)
            mulArr.append(msg)
        }
        success(mulArr)
    }
    
    func loadAllMsg(success:@escaping([STMessage]) -> Void) {
        let arr = RealmManager.share().getChatAllMsgs(order_sn)
        var mulArr: [STMessage] = [STMessage]()
        for m in arr {
            let msg = STMessage.init(model: m)
            mulArr.append(msg)
        }
        success(mulArr)
    }
    
    /// 根据关键字搜索该会话消息
    func loadMsgBy(keyword:String, success:@escaping([STMessage]) -> Void) {
        let arr = RealmManager.share().getMsgModel(byKeyWord: keyword, sn: order_sn)
        var mulArr: [STMessage] = [STMessage]()
        for m in arr {
            let msg = STMessage.init(model: m)
            mulArr.append(msg)
        }
        success(mulArr)
    }
    
    func loadMsgAfter(id: String, success:@escaping([STMessage]) -> Void) {
        let arr = RealmManager.share().getSocketModel(afterMessageId: id, trade_sn: order_sn)
        var mulArr: [STMessage] = [STMessage]()
        for m in arr {
            let msg = STMessage.init(model: m)
            mulArr.append(msg)
        }
        success(mulArr)
    }
    
    /// 更新为已读
    func updateReadAck() {
        let m = JSocketModel.init(to: id, sn: order_sn)
        m.type = socket_value_read
        ChatManager.share.addRead(model: m)
        RealmManager.share().updateRead(order_sn, isReadAck: true)
    }
    
    /// 更新会话结束
    func updateConversationFinish() {
        RealmManager.share().updateConversationFinish(order_sn)
    }
    
    /// 更新会话最后一条输入未发送的文本
    func updateConversationInputText(text: String) {
        if order_sn.count > 0 {
            RealmManager.share().updateConversationInputText(text, trade_sn: order_sn)
        }
    }
    
}

class MessageFileModel: NSObject {
    @objc var file_path: String = ""
    @objc var file_name: String = ""
    @objc var file_size: String = ""
}
