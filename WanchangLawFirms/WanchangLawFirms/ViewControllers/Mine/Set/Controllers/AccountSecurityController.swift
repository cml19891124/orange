//
//  AccountSecurityController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class AccountSecurityController: BaseController {
    
    private let bindArr: [String] = ["m_clear_account"]
    private lazy var tableView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.001))
        temp.register(MineCell.self, forCellReuseIdentifier: "MineCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var cacheStr: String = {
        () -> String in
        return String.init(format: "%.2fM", StorageManager.initWithShare().cachesSize())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("m_account_security")
        self.tableView.reloadData()
    }
    
}

extension AccountSecurityController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = bindArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineCell", for: indexPath) as! MineCell
        cell.bind = bind
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var message = ""
        if UserInfo.share.is_business {
            message = "注销账号后将会删除该账号的所有信息以及该账号名下的所有子账号信息，包括公司信息，用户订单等，请谨慎操作！确定注销？"
        } else {
            message = "注销账号后将会删除该账号的所有信息和订单，请谨慎操作！确定注销？"
        }
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "注销账号", message: message, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            OLAlertManager.share.logOffShow()
        }, cancelHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
}
