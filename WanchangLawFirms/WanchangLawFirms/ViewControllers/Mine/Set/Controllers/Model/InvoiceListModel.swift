//
//  InvoiceListModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/25.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceListModel: NSObject {
    @objc var amount: String = ""
    @objc var company_id: String = ""
    @objc var created_at: String = ""
    @objc var discount: String = ""
    @objc var id: String = ""
    @objc var invoice: String = ""
    @objc var order_sn: String = ""
    @objc var order_type: String = ""
    @objc var title: String = ""
    @objc var trade_type: String = ""
    @objc var uid: String = ""
    
    @objc var account: String = ""
    @objc var address: String = ""
    @objc var bank: String = ""
    @objc var head_info_type: String = ""
    @objc var head_name: String = ""
    @objc var head_sn: String = ""
    @objc var head_type: String = ""
    @objc var order_ids: String = ""
    @objc var phone: String = ""
    @objc var status: String = ""
    @objc var type: String = ""
    @objc var updated_at: String = ""
    
    var isSelected: Bool = false
}
