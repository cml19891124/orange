//
//  MineBusinessModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/10.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineBusinessModel: NSObject {
    @objc var contact_name: String?
    @objc var contact_phone: String?
    @objc var created_at: String?
    @objc var id: String?
    @objc var image: String?
    @objc var name: String?
    @objc var number: String?
    @objc var remark: String?
    @objc var sn: String?
    @objc var contact_email: String?
    @objc var owner_name: String?
    @objc var owner_sn: String?
    
    @objc var check_number: String?
    @objc var consult_number: String?
    @objc var discount: String?
    @objc var make_number: String?
    @objc var meet_number: String?
    @objc var train_number: String?
    @objc var sub_account: String?
    
    @objc var file_number: String?
    
    @objc var position: String?
    @objc var business: String?
    @objc var address: String?
    
    @objc var recommend_id: String?
    
    @objc var exa_at: String?
    @objc var exa_image: String?
    @objc var exa_name: String?
    @objc var exa_owner_name: String?
    @objc var exa_owner_sn: String?
    @objc var exa_sn: String?
    @objc var exa_status: String?
    
    
    @objc var status: String? {
        didSet {
            if status == "0" {
                show_title = "企业认证"
            } else if status == "1" {
                show_title = "企业管理"
            } else {
                show_title = "企业认证"
            }
        }
    }
    @objc var uid: String?
    @objc var updated_at: String?
    @objc var vip: String?
    @objc var vip_expired: String?
    
    
    var show_title: String = "企业认证"
}
