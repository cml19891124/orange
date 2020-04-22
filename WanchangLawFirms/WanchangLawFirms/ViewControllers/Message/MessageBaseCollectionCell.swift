//
//  MessageBaseCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/14.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 订单会话基类
class MessageBaseCollectionCell: UICollectionViewCell {
    
    var status: String = "1"
    
    var real_refresh: Bool = true
    lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kTabBarHeight - 50), style: .plain, space: 0)
        let tabView = temp.tabView
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        tabView.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.addSubview(temp)
        return temp
    }()
    var dataArr: [MessageModel] = [MessageModel]()
    var page: Int = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(netRefresh), name: NSNotification.Name(rawValue: noti_user_order_change), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(netRefresh), name: NSNotification.Name(rawValue: noti_order_transform), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func netRefresh() {
        real_refresh = true
        self.listView.tabView.mj_header.beginRefreshing()
    }
    
}

extension MessageBaseCollectionCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.row]
        var h = (model.question_show).height(width: kDeviceWidth - kLeftSpaceL * 2 - kAvatarWH - kLeftSpaceS, font: kFontMS) + kLeftSpaceS * 2 + 25
        if h < 65 {
            h = 65
        } else if h > 100 {
            h = 100
        }
        if model.chat_show.count > 0 {
            h += 27
        }
        return h
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.row]
        if model.product_title == "企业培训" || model.product_title == "律师约见" {
            PromptTool.promptText("线下服务暂时不能聊天", 1)
            return
        }
        let vc = ChatController()
        vc.model = model
        vc.status = status
        if UserInfo.share.conversationLoadedJudge(sn: model.order_sn) {
            JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
            return
        }
        let prams: NSDictionary = ["order_sn": model.order_sn]
        let v = JPhotoPromptView.init(bind: "p_load_net_msg")
        MessageManager.share.chatMsg(prams: prams) { (flag) in
            v.removeFromSuperview()
            if flag {
                JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceL
    }
}
