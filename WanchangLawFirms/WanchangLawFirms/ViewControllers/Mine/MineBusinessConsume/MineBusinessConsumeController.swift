//
//  MineBusinessConsumeController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/17.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业消费记录
class MineBusinessConsumeController: BaseController {
    
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: kLeftSpaceS)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(MineBusinessConsumeCell.self, forCellReuseIdentifier: "MineBusinessConsumeCell")
        tabView.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    private var dataArr: [MineConsumeModel] = [MineConsumeModel]()
    private var page: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("mine_consume")
        self.listView.tabView.mj_header.beginRefreshing()
    }
}

extension MineBusinessConsumeController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        } else {
            self.getFooterDataSource()
        }
    }
    
    private func getHeaderDataSource() {
        let prams: NSDictionary = ["page":"1"]
        HomeManager.share.userTrades(prams: prams) { (arr) in
            self.listView.j_header.endRefreshing()
            self.page = 2
            self.dataArr.removeAll()
            if arr == nil || arr!.count == 0 {
                self.listView.j_footer.jRefreshNoTextMoreData()
                self.listView.imgName = "no_data_consume_record"
                self.listView.tabView.reloadData()
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
        let prams: NSDictionary = ["page":"\(page)"]
        HomeManager.share.userTrades(prams: prams) { (arr) in
            self.listView.j_footer.endRefreshing()
            self.page += 1
            if arr == nil || arr!.count == 0 {
                self.listView.tabView.reloadData()
                return
            }
            if arr!.count < 10 {
                self.listView.j_footer.jRefreshNoMoreData()
            }
            for m in arr! {
                self.dataArr.append(m)
            }
            self.listView.tabView.reloadData()
        }
    }
}

extension MineBusinessConsumeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineBusinessConsumeCell", for: indexPath) as! MineBusinessConsumeCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceL
    }
}
