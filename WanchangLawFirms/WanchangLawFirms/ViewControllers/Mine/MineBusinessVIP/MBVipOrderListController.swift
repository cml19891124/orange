//
//  MBVipOrderListController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/4/5.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBVipOrderListController: BaseController {
    
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: kLeftSpaceS)
        temp.dataSource = self
        let tabView: UITableView = temp.tabView
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(MBVOLCell.self, forCellReuseIdentifier: "MBVOLCell")
        self.view.addSubview(temp)
        return temp
    }()
    private var dataArr: [MessageModel] = [MessageModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会员开通记录"
        self.listView.tabView.mj_header.beginRefreshing()
    }

}

extension MBVipOrderListController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        }
    }
    
    private func getHeaderDataSource() {
        HomeManager.share.companyVipOrderList { (arr) in
            self.listView.tabView.mj_header.endRefreshing()
            self.dataArr.removeAll()
            if arr != nil {
                for m in arr! {
                    self.dataArr.append(m)
                }
            }
            self.listView.j_footer.jRefreshNoMoreData()
            self.listView.tabView.reloadData()
        }
    }
}

extension MBVipOrderListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MBVOLCell", for: indexPath) as! MBVOLCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.row]
        let vc = MBVipOrderDetailController()
        vc.messageModel = model
        weak var weakSelf = self
        vc.block = { () in
            weakSelf?.listView.tabView.mj_header.beginRefreshing()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
