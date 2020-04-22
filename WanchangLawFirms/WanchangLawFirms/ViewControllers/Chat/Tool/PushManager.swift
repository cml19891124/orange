//
//  PushManager.swift
//  Stormtrader
//
//  Created by lh on 2018/11/13.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import UserNotifications

/// 消息推送
class PushManager: NSObject {
    static let share = PushManager()
    
    private var msgArr: [STMessage] = [STMessage]()
    
    func addMsg(msg: STMessage) {
        if #available(iOS 10.0, *) {
            if (NSClassFromString("UNUserNotificationCenter") == nil) {
                return
            }
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            var identifier: String = ""
            for m in msgArr {
                if m.sn == msg.sn {
                    if identifier == "" {
                        identifier = msg.sn
                    }
                }
            }
            if identifier == "" {
                identifier = msg.sn
            }
            content.title = L$("m_order_sn") + msg.sn
            var showStr = ""
            if msg.bodyType == .text {
                let body = msg.body as! STTextMessageBody
                showStr = body.text
            } else if msg.bodyType == .image {
                showStr = L$("push_picture")
            }
            content.body = showStr
            content.sound = UNNotificationSound.default
            let tirgger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
            let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: tirgger)
            center.add(request, withCompletionHandler: nil)
            msgArr.append(msg)
        }
    }
    
    func clearAll() {
        self.msgArr.removeAll()
    }

}
