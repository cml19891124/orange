//
//  FontSetController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/21.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class FontSetController: BaseController {

    private let bindArr: [String] = ["m_font_default","m_font_big","m_font_max"]
    private lazy var tableView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.001))
        temp.register(JLabCell.self, forCellReuseIdentifier: "JLabCell")
        self.view.addSubview(temp)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("m_chat_font")
        if UserInfo.defaultChatFont() == nil {
            UserInfo.setChatFont(text: "m_font_default")
        }
        self.tableView.reloadData()
    }

}

extension FontSetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = bindArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JLabCell", for: indexPath) as! JLabCell
        cell.lab.text = L$(bind)
        if UserInfo.defaultChatFont() == bind {
            cell.backgroundColor = kOrangeLightColor
        } else {
            cell.backgroundColor = kCellColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bind = bindArr[indexPath.row]
        UserInfo.setChatFont(text: bind)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
}
