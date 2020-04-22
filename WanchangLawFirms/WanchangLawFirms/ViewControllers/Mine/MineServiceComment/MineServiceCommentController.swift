//
//  MineServiceCommentController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/15.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 服务评价
class MineServiceCommentController: BaseController {
    
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.separatorStyle = .none
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(MBOrderCell.self, forCellReuseIdentifier: "MBOrderCell")
        tabView.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    private var dataArr: [MessageModel] = [MessageModel]()
    private var page: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserInfo.share.isMother {
            self.title = L$("mine_business_service_comment")
        } else {
            self.title = L$("mine_service_comment")
        }
        self.listView.tabView.mj_header.beginRefreshing()
    }
    
}

extension MineServiceCommentController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        } else {
            self.getFooterDataSource()
        }
    }
    
    private func getHeaderDataSource() {
        let prams: NSDictionary = ["status":"2","page":"1"]
        HomeManager.share.userOrders(prams: prams) { (arr) in
            self.listView.j_header.endRefreshing()
            self.dataArr.removeAll()
            self.page = 2
            if arr == nil || arr!.count == 0 {
                self.listView.tabView.reloadData()
                self.listView.j_footer.jRefreshNoTextMoreData()
                self.listView.imgName = "no_data_order_finish"
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
        let prams: NSDictionary = ["status":"2","page":"\(page)"]
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


extension MineServiceCommentController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier:"MBOrderCell", for: indexPath) as! MBOrderCell
        cell.status = "2"
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.section]
        let vc = MessageDetailController()
        vc.model = model
        vc.status = "2"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.section]
        let tempH = kLeftSpaceS * 2 + 30
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
