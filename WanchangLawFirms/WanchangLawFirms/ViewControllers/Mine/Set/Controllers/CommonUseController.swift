//
//  CommonUseController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/21.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class CommonUseController: BaseController {
    
    private let bindArr: [String] = ["m_chat_font","mine_orange_save"]
    private lazy var tableView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.001))
        temp.register(MineCell.self, forCellReuseIdentifier: "MineCell")
        temp.register(MineTailCell.self, forCellReuseIdentifier: "MineTailCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var cacheStr: String = {
        () -> String in
        return String.init(format: "%.2fM", StorageManager.initWithShare().cachesSize())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("m_common_use")
        self.tableView.reloadData()
    }
    
}

extension CommonUseController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = bindArr[indexPath.row]
        if bind == "mine_orange_save" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineTailCell", for: indexPath) as! MineTailCell
            cell.bind = bind
            cell.tailLab.text = cacheStr
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineCell", for: indexPath) as! MineCell
        cell.bind = bind
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bind = bindArr[indexPath.row]
        if bind == "m_chat_font" {
            let vc = FontSetController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_orange_save" {
            JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "清除缓存不会影响聊天消息，请放心清理。确定清除？", message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
                StorageManager.initWithShare().clearCaches()
                self.cacheStr = "0M"
                tableView.reloadData()
            }, cancelHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
}
