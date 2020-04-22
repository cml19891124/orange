//
//  ChatContentSearchController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ChatContentSearchController: BaseController {
    
    var model: MessageModel!
    var clickBlock = { (msg: STMessage) in
        
    }
    
    private lazy var searchView: ChatContentSearchTopView = {
        () -> ChatContentSearchTopView in
        let temp = ChatContentSearchTopView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kBarStatusHeight + 50))
        temp.searchBar.search_delegate = self
        return temp
    }()
    private var dataArr: [STMessage] = [STMessage]()
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kBarStatusHeight + 50, width: kDeviceWidth, height: kDeviceHeight - kBarStatusHeight - 50), style: .plain, space: 0)
        let tabView = temp.tabView
        tabView.bounces = false
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(ChatContentSearchCell.self, forCellReuseIdentifier: "ChatContentSearchCell")
        self.view.addSubview(temp)
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(searchView)
        self.listView.tabView.reloadData()
        self.searchView.searchBar.becomeFirstResponder()
    }
}

extension ChatContentSearchController: ChatContentSearchBarDelegate {
    func chatContentSearchBarTextChange(text: String) {
        model.loadMsgBy(keyword: text) { (arr) in
            self.dataArr.removeAll()
            for m in arr {
                self.dataArr.append(m)
            }
            self.listView.tabView.reloadData()
            if self.dataArr.count == 0 {
                self.listView.imgName = "no_data_chat_content_search"
            } else {
                self.listView.imgName = nil
            }
        }
    }
}

extension ChatContentSearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatContentSearchCell", for: indexPath) as! ChatContentSearchCell
        cell.msg = msg
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        let msg = dataArr[indexPath.row]
        self.clickBlock(msg)
        self.dismiss(animated: true, completion: nil)
    }
}
