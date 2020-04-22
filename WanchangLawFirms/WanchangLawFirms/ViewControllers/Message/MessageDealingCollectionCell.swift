//
//  MessageDealingCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/14.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 处理中订单
class MessageDealingCollectionCell: MessageBaseCollectionCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.status = "1"
        self.localDataSource()
        self.listView.dataSource = self
        self.listView.tabView.mj_header.beginRefreshing()
        NotificationCenter.default.addObserver(self, selector: #selector(localDataSource), name: NSNotification.Name(noti_dealing_msg_need_refresh), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func localDataSource() {
        self.dataArr = MessageManager.share.dealingConversation
        if self.dataArr.count == 0 {
            self.listView.imgName = "no_data_conversation_deal"
        } else {
            self.listView.imgName = nil
        }
        self.listView.tabView.reloadData()
    }
    
}

extension MessageDealingCollectionCell: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        }
    }
    
    func getHeaderDataSource() {
        if self.real_refresh {
            let prams: NSDictionary = ["status":"1","page":"1"]
            MessageManager.share.chatList(prams: prams) { (flag, arr) in
                self.listView.tabView.mj_header.endRefreshing()
                MessageManager.share.onGoRefresh()
                if flag {
                    self.real_refresh = false
                }
            }
        } else {
            let prams: NSDictionary = ["status":"1","page":"1"]
            MessageManager.share.chatList(prams: prams) { (flag, arr) in
                self.listView.j_header.jDelayEndRefreshing {
                    MessageManager.share.onGoRefresh()
                    if flag {
                        self.real_refresh = false
                    }
                }
            }
        }
    }
}
