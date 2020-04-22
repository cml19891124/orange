//
//  JVoiceMoveManager.swift
//  Stormtrader
//
//  Created by lh on 2018/9/30.
//  Copyright © 2018年 gaming17. All rights reserved.
//

import UIKit
import AudioToolbox

/// 消息声音震动提醒控制
class JVoiceMoveManager: NSObject {
    static let share = JVoiceMoveManager()
    
    func noti() {
        let flag = UserInfo.getStandard(key: standard_noti_flag) ?? "111"
        let ns = flag as NSString
        let flag1 = ns.substring(with: NSRange.init(location: 1, length: 1))
        let flag2 = ns.substring(with: NSRange.init(location: 2, length: 1))
        if flag1 == "1" {
            let audioPath = Bundle.main.url(forResource: "in", withExtension: "caf")
            var soundID: SystemSoundID = 1
            AudioServicesCreateSystemSoundID(audioPath! as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
        if flag2 == "1" {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }

}
