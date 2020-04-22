//
//  LawyerModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 律师信息
class LawyerModel: NSObject {
    @objc var id: String = ""
    @objc var name: String = "欧伶猪法律法务"
    @objc var avatar: String = ""
    
    @objc var desc: String = ""
    @objc var order_star_all: String = ""
    @objc var order_star_num: String = ""
    @objc var status: String = ""
    @objc var subscribe_count: String = ""
    @objc var type: String = ""
    @objc var username: String = ""
    @objc var work_status: String = ""
    @objc var work_year: String = ""
    
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["desc":"description"]
    }
}
