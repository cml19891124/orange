//
//  MessageFinishCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/14.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 已完成订单
class MessageFinishCollectionCell: MessageBaseCollectionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.status = "2"
        self.localDataSource()
        self.listView.dataSource = self
        self.listView.tabView.mj_header.beginRefreshing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func localDataSource() {
        self.dataArr = MessageManager.share.localConversation(status: "2")
        self.listView.tabView.reloadData()
        if self.dataArr.count == 0 {
            self.listView.imgName = "no_data_conversation_finish"
        } else {
            self.listView.imgName = nil
        }
        self.listView.tabView.reloadData()
    }
    
}

extension MessageFinishCollectionCell: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        } else {
            self.getFooterDataSource()
        }
    }
    
    func getHeaderDataSource() {
        let prams: NSDictionary = ["status":"2","page":"1"]
        MessageManager.share.chatList(prams: prams) { (flag, arr) in
            if self.real_refresh {
                self.listView.j_header.endRefreshing()
                self.headerDataSourceDeal(flag: flag, arr: arr)
            } else {
                self.listView.j_header.jDelayEndRefreshing {
                    self.headerDataSourceDeal(flag: flag, arr: arr)
                }
            }
            
        }
    }
    
    private func headerDataSourceDeal(flag: Bool, arr: [MessageModel]?) {
        if !flag {
            return
        }
        self.real_refresh = false
        self.page = 2
        self.dataArr.removeAll()
        if arr == nil || arr!.count == 0 {
            self.listView.j_footer.jRefreshNoTextMoreData()
            self.listView.tabView.reloadData()
            self.listView.imgName = "no_data_conversation_finish"
            return
        }
        self.listView.imgName = nil
        if arr!.count < 10 {
            self.listView.j_footer.jRefreshNoMoreData()
        } else {
            self.listView.j_footer.jRefreshReset()
        }
        for m in arr! {
            self.dataArr.append(m)
        }
        self.listView.tabView.reloadData()
    }
    
    func getFooterDataSource() {
        let prams: NSDictionary = ["status":"2","page":"\(page)"]
        MessageManager.share.chatList(prams: prams) { (flag, arr) in
            self.listView.j_footer.endRefreshing()
            if !flag {
                return
            }
            guard let temp = arr else {
                self.listView.j_footer.jRefreshNoMoreData()
                self.listView.tabView.reloadData()
                return
            }
            self.page += 1
            if temp.count < 10 {
                self.listView.j_footer.jRefreshNoMoreData()
            }
            for m in temp {
                self.dataArr.append(m)
            }
            self.listView.tabView.reloadData()
        }
    }
}
