//
//  JSocketModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 服务端返回的消息模型
class JSocketModel: NSObject {
    
    @objc var event: String = ""
    @objc var content: String = ""
    
    @objc var id: String = ""
    @objc var sn: String = ""
    @objc var from: String = ""
    @objc var to: String = ""
    @objc var attribute: String = "" {
        didSet {
            guard let data = attribute.data(using: String.Encoding.utf8) else {
                return
            }
            let dict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            if dict != nil {
                let m = JSAttributeModel.mj_object(withKeyValues: dict!)
                if m != nil {
                    self.attributeModel = m!
                }
            }
        }
    }
    @objc var time: Int64 = 0
    @objc var type: Int = 1
    
    @objc var net_id: String = ""
    
    @objc var from_id: String = ""
    @objc var to_id: String = ""
    
    @objc var push_type: String = ""
    @objc var push_title: String = ""
    
    @objc var j_isRead: Bool = false
    @objc var j_isWithdrew: Bool = false
    @objc var j_isReadAck: Bool = false
    
    @objc var j_status: String = "1"
    @objc var j_path: String = ""
    
    @objc var j_share_local_full_url: URL?
    
    @objc var j_oss_snap_url: String = ""
    @objc var j_oss_full_url: String = ""
    
    @objc var j_already_exist: Bool = false
    
    var attributeModel: JSAttributeModel = JSAttributeModel()
    
    convenience init(to: String, sn: String) {
        self.init()
        self.from = UserInfo.share.uid!
        self.to = to
        self.sn = sn
        self.id = BaseUtil.uniqueMsgID()
        self.time = Int64(Date().timeIntervalSince1970 * 1000)
        self.j_status = "0"
    }

}

class JSAttributeModel: NSObject {
    @objc var msg_image_width: String = ""
    @objc var msg_image_height: String = ""
    @objc var msg_image_size: String = ""
    @objc var msg_file_name: String = ""
    @objc var msg_file_length: String = ""
    
    @objc var order_sn: String = ""
    @objc var product_id: String = ""
    @objc var vip: String = ""
    
    @objc var auto_reply: NSArray? {
        didSet {
//            guard let data = auto_reply.data(using: String.Encoding.utf8) else {
//                return
//            }
//            let arr = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
            if auto_reply != nil {
                let mArr = JAutoReplyModel.mj_objectArray(withKeyValuesArray: auto_reply!) as? [JAutoReplyModel]
                if mArr != nil {
                    self.autoReplyArr = mArr!
                }
            }
        }
    }
    
    var autoReplyArr: [JAutoReplyModel] = [JAutoReplyModel]()
}

class JAutoReplyModel: NSObject {
    @objc var content: String = ""
    @objc var content_type: String = ""
    @objc var id: String = ""
    @objc var keyword: String = "" {
        didSet {
            let temp = "· " + keyword
            height = temp.height(width: 220, font: UserInfo.share.chatFont) + kLeftSpaceS
        }
    }
    @objc var sort: String = ""
    
    var height: CGFloat = 0.0
}
