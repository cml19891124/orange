//
//  MBOrderCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/20.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBOrderCollectionCell: UICollectionViewCell {
    
    var status: String = "" {
        didSet {
            self.listView.tabView.mj_header.beginRefreshing()
        }
    }
    
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: self.bounds, style: .plain, space: 0)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.separatorStyle = .none
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(MBOrderCell.self, forCellReuseIdentifier: "MBOrderCell")
        tabView.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.addSubview(temp)
        return temp
    }()
    private var dataArr: [MessageModel] = [MessageModel]()
    private var page: Int = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MBOrderCollectionCell: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        } else {
            self.getFooterDataSource()
        }
    }
    
    private func getHeaderDataSource() {
        let prams: NSDictionary = ["status":status,"page":"1"]
        HomeManager.share.userOrders(prams: prams) { (arr) in
            self.listView.j_header.endRefreshing()
            self.dataArr.removeAll()
            self.page = 2
            if arr == nil || arr!.count == 0 {
                self.listView.tabView.reloadData()
                self.listView.j_footer.jRefreshNoTextMoreData()
                if self.status == "1" {
                    self.listView.imgName = "no_data_order_deal"
                } else {
                    self.listView.imgName = "no_data_order_finish"
                }
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
    }
    
    private func getFooterDataSource() {
        let prams: NSDictionary = ["status":status,"page":"\(page)"]
        HomeManager.share.userOrders(prams: prams) { (arr) in
            self.listView.j_footer.endRefreshing()
            self.page += 1
            guard let temp = arr else {
                self.listView.j_footer.jRefreshNoMoreData()
                return
            }
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


extension MBOrderCollectionCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier:"MBOrderCell", for: indexPath) as! MBOrderCell
        cell.status = status
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.section]
        let vc = MessageDetailController()
        vc.model = model
        vc.status = status
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.section]
        var tempH = kLeftSpaceS * 2 + 30
        if model.id == "00" {
            tempH += 35
        }
        var h = model.desc.height(width: kDeviceWidth - kLeftSpaceS - kAvatarWH - 50, font: kFontMS) + tempH
        if h < tempH + 20 {
            h = tempH + 20
        } else if h > tempH + 60 {
            h = tempH + 60
        }
        return h
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
