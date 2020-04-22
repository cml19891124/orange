//
//  JPayApiWechatModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 微信支付模型
class JPayApiWechatModel: NSObject {
    @objc var appid: String = ""
    @objc var mch_id: String = ""
    @objc var nonce_str: String = ""
    @objc var prepay_id: String = ""
    @objc var result_code: String = ""
    @objc var return_code: String = ""
    @objc var return_msg: String = ""
    @objc var sign: String = ""
    @objc var trade_type: String = ""
    @objc var timestamp: String = ""
}
