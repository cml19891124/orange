//
//  MessageSystemCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/17.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 系统消息
class MessageSystemCollectionCell: UICollectionViewCell {
    
    private var real_refresh: Bool = true
    private var page: Int = 2
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kTabBarHeight - 50), style: .plain, space: 0)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.separatorStyle = .none
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(MessageSystemCell.self, forCellReuseIdentifier: "MessageSystemCell")
        tabView.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.addSubview(temp)
        return temp
    }()
    
    private var dataArr: [JSocketModel] = [JSocketModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.localDataSource()
        self.netRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(netRefresh), name: NSNotification.Name(rawValue: noti_system_msg_refresh), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func localDataSource() {
        self.dataArr = MessageManager.share.localSystemMsg()
        self.listView.tabView.reloadData()
        if self.dataArr.count == 0 {
            self.listView.imgName = "no_data_system_msg"
        }
    }
    
    @objc private func netRefresh() {
        self.real_refresh = true
        self.listView.tabView.mj_header.beginRefreshing()
    }
}

extension MessageSystemCollectionCell: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        } else {
            self.getFooterDataSource()
        }
    }
    
    private func getHeaderDataSource() {
        let prams: NSDictionary = ["page":"1"]
        MessageManager.share.chatSystem(prams: prams) { (flag, arr) in
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
    
    private func headerDataSourceDeal(flag: Bool, arr: [JSocketModel]?) {
        if !flag {
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_system_msg_read), object: nil)
        self.real_refresh = false
        self.dataArr.removeAll()
        self.page = 2
        if arr == nil || arr!.count == 0 {
            self.listView.j_footer.jRefreshNoTextMoreData()
            self.listView.tabView.reloadData()
            self.listView.imgName = "no_data_system_msg"
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
    
    private func getFooterDataSource() {
        let prams: NSDictionary = ["page":"\(page)"]
        MessageManager.share.chatSystem(prams: prams) { (flag, arr) in
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

extension MessageSystemCollectionCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArr[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSystemCell", for: indexPath) as! MessageSystemCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArr[indexPath.section]
        if model.attributeModel.vip.haveTextStr() == true {
            return
        }
        if model.attributeModel.order_sn.haveTextStr() == true {
            let vc = MessageDetailController()
            let tempModel = MessageModel()
            tempModel.order_sn = model.attributeModel.order_sn
            vc.model = tempModel
            JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceL
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
