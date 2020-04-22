//
//  ChatRecordController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/18.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 聊天记录
class ChatRecordController: BaseController {
    
    var model: MessageModel = MessageModel()
    var co_username: String?
    var co_avatar: String?
    var onlyFile: Bool = false
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .grouped, space: 0)
        temp.backgroundColor = kBaseColor
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.mj_header = j_header
        temp.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        temp.register(ChatLeftTextCell.self, forCellReuseIdentifier: "ChatLeftTextCell")
        temp.register(ChatRightTextCell.self, forCellReuseIdentifier: "ChatRightTextCell")
        temp.register(ChatLeftImgCell.self, forCellReuseIdentifier: "ChatLeftImgCell")
        temp.register(ChatRightImgCell.self, forCellReuseIdentifier: "ChatRightImgCell")
        temp.register(ChatLeftGifCell.self, forCellReuseIdentifier: "ChatLeftGifCell")
        temp.register(ChatRightGifCell.self, forCellReuseIdentifier: "ChatRightGifCell")
        temp.register(ChatLeftBigEmoCell.self, forCellReuseIdentifier: "ChatLeftBigEmoCell")
        temp.register(ChatRightBigEmoCell.self, forCellReuseIdentifier: "ChatRightBigEmoCell")
        temp.register(ChatLeftFileCell.self, forCellReuseIdentifier: "ChatLeftFileCell")
        temp.register(ChatRightFileCell.self, forCellReuseIdentifier: "ChatRightFileCell")
        temp.register(ChatTimeHeaderView.self, forHeaderFooterViewReuseIdentifier: "ChatTimeHeaderView")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        temp.register(ChatLabCell.self, forCellReuseIdentifier: "ChatLabCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var j_header: JRefreshHeader = {
        () -> JRefreshHeader in
        let temp = JRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(loadMessage))
        return temp!
    }()
    private var searchMsgId: String = ""
    private var dataArr: [STMessage] = [STMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if onlyFile {
            self.loadAllFiles()
            self.title = "聊天文件"
        } else {
            self.loadMessage()
            self.title = L$("chat_record")
        }
    }
    
}

extension ChatRecordController {
    private func loadAllFiles() {
        model.loadAllFile { (arr) in
            self.tabView.mj_header.endRefreshing()
            self.j_header.jRefreshNoMoreData()
            self.dataArr.removeAll()
            for msg in arr {
                self.dataArr.append(msg)
            }
            self.tabView.reloadData()
            self.scrollToBottom(animated: false)
        }
    }
    
    @objc private func loadMessage() {
        model.loadMsgFrom(id: searchMsgId) { (arr) in
            self.tabView.mj_header.endRefreshing()
            if arr.count < 20 {
                self.j_header.jRefreshNoMoreData()
            }
            for msg in arr {
                self.dataArr.insert(msg, at: 0)
            }
            self.tabView.reloadData()
            if arr.count == 0 {
                return
            }
            if self.searchMsgId == "" {
                self.scrollToBottom(animated: false)
            } else {
                self.tabView.scrollToRow(at: IndexPath.init(row: 0, section: arr.count), at: UITableView.ScrollPosition.top, animated: false)
            }
            let m = self.dataArr[0]
            self.searchMsgId = m.id
        }
    }
    
    func scrollToBottom(animated: Bool) {
        if self.dataArr.count > 0 {
            self.tabView.scrollToRow(at: IndexPath.init(row: 0, section: self.dataArr.count - 1), at: UITableView.ScrollPosition.bottom, animated: animated)
        }
    }
}

extension ChatRecordController: ChatManagerDelegate {
    func chatManagerReceiveRead(sn: String) {
        if sn == model.order_sn {
            var i = self.dataArr.count - 1
            while i >= 0 {
                let msg = self.dataArr[i]
                if msg.fromMe {
                    if msg.isRead {
                        break
                    }
                    msg.isRead = true
                }
                i -= 1
            }
        }
    }
    
    func chatManagerReceiveWithdrew(model: JSocketModel) {
        if model.sn == self.model.order_sn {
            var i = self.dataArr.count - 1
            while i >= 0 {
                let msg = self.dataArr[i]
                if !msg.fromMe {
                    if msg.id == model.content {
                        msg.isWithdrew = true
                        break
                    }
                }
                i -= 1
            }
            self.tabView.reloadData()
        }
    }
}


extension ChatRecordController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = dataArr[indexPath.section]
        if msg.isWithdrew {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLabCell", for: indexPath) as! ChatLabCell
            if msg.from == model.uid {
                cell.showStr = "你撤回了一条消息"
            } else {
                cell.showStr = "对方撤回了一条消息"
            }
            return cell
        }
        switch msg.bodyType {
        case .text:
            if msg.j_model.type == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLabCell", for: indexPath) as! ChatLabCell
                cell.showStr = msg.j_model.content
                return cell
            }
            if msg.from == model.uid {
                let cell = tabView.dequeueReusableCell(withIdentifier: "ChatRightTextCell", for: indexPath) as! ChatRightTextCell
                cell.msg = msg
                cell.recordHide()
                if self.co_username != nil {
                    cell.nameLab.text = co_username
                    cell.avatarImgView.avatar = co_avatar
                }
                return cell
            }
            let cell = tabView.dequeueReusableCell(withIdentifier: "ChatLeftTextCell", for: indexPath) as! ChatLeftTextCell
            cell.msg = msg
            return cell
        case .bigEmo:
            if msg.from == model.uid {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightBigEmoCell", for: indexPath) as! ChatRightBigEmoCell
                cell.msg = msg
                cell.recordHide()
                if self.co_username != nil {
                    cell.nameLab.text = co_username
                    cell.avatarImgView.avatar = co_avatar
                }
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftBigEmoCell", for: indexPath) as! ChatLeftBigEmoCell
            cell.msg = msg
            return cell
        case .image:
            let body = msg.body as! STImageMessageBody
            if msg.from == model.uid {
                if body.is_gif {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightGifCell", for: indexPath) as! ChatRightGifCell
                    cell.msg = msg
                    cell.recordHide()
                    if self.co_username != nil {
                        cell.nameLab.text = co_username
                        cell.avatarImgView.avatar = co_avatar
                    }
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightImgCell", for: indexPath) as! ChatRightImgCell
                cell.msg = msg
                cell.recordHide()
                if self.co_username != nil {
                    cell.nameLab.text = co_username
                    cell.avatarImgView.avatar = co_avatar
                }
                return cell
            }
            if body.is_gif {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftGifCell", for: indexPath) as! ChatLeftGifCell
                cell.msg = msg
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftImgCell", for: indexPath) as! ChatLeftImgCell
            cell.msg = msg
            return cell
        case .file:
            if msg.from == model.uid {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightFileCell", for: indexPath) as! ChatRightFileCell
                cell.msg = msg
                cell.recordHide()
                if self.co_username != nil {
                    cell.nameLab.text = co_username
                    cell.avatarImgView.avatar = co_avatar
                }
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftFileCell", for: indexPath) as! ChatLeftFileCell
            cell.msg = msg
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let msg = dataArr[indexPath.section]
        if msg.isWithdrew || msg.j_model.type == 7 {
            return 30
        }
        return msg.size.height + 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let msg = dataArr[section]
        let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ChatTimeHeaderView") as! ChatTimeHeaderView
        if section == 0 {
            v.timeStr = msg.timeStr
        } else {
            let upMsg = dataArr[section - 1]
            if msg.showTime(referenceMsg: upMsg) == true {
                v.timeStr = msg.timeStr
            } else {
                v.timeStr = ""
            }
        }
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let msg = dataArr[section]
        if section == 0 {
            msg.j_show_time = true
            return 30
        } else {
            let upMsg = dataArr[section - 1]
            if msg.showTime(referenceMsg: upMsg) == true {
                return 30
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_tabview_begin_scroll), object: nil)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_tabview_end_scroll), object: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_tabview_end_scroll), object: nil)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_tabview_end_scroll), object: nil)
    }
}
