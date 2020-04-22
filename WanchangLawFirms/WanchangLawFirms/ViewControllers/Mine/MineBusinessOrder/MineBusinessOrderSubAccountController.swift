//
//  MineBusinessOrderSubAccountController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/9.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineBusinessOrderSubAccountController: BaseController {
    
    private lazy var titleV: MBTitleView = {
        () -> MBTitleView in
        let temp = MBTitleView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 44))
        temp.delegate = self
        return temp
    }()
    private lazy var chooseV: MBSubAccountChooseView = {
        () -> MBSubAccountChooseView in
        let temp = MBSubAccountChooseView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight))
        temp.delegate = self
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.separatorStyle = .none
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(MineBusinessOrderCell.self, forCellReuseIdentifier: "MineBusinessOrderCell")
        tabView.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    private var dataArr: [MessageModel] = [MessageModel]()
    private var page: Int = 2
    let mulPrams: NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = self.titleV
        self.listView.tabView.mj_header.beginRefreshing()
    }
    
}

extension MineBusinessOrderSubAccountController: MBTitleViewDelegate {
    func mbTitleViewClick(sender: HImgCenterAlignmentBtn) {
        self.chooseV.isHidden = !sender.isSelected
        self.chooseV.block = { () in
            sender.isSelected = false
        }
    }
}

extension MineBusinessOrderSubAccountController: MBChooseViewDelegate {
    func mbChooseViewStatusClick(m: JBindModel) {
        let order_status: String = HomeManager.share.statusIdBy(bind: m.bind)
        mulPrams["status"] = order_status
        self.listView.tabView.mj_header.beginRefreshing()
    }
    
    func mbChooseViewTypeClick(m: JBindModel) {
        let product_id: String = HomeManager.share.idByBind(bind: m.bind)
        mulPrams["product_id"] = product_id
        self.listView.tabView.mj_header.beginRefreshing()
    }
}

extension MineBusinessOrderSubAccountController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        } else {
            self.getFooterDataSource()
        }
    }
    
    private func getHeaderDataSource() {
        mulPrams["page"] = "1"
        HomeManager.share.userOrdersAll(prams: mulPrams) { (arr) in
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
        mulPrams["page"] = "\(page)"
        HomeManager.share.userOrdersAll(prams: mulPrams) { (arr) in
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


extension MineBusinessOrderSubAccountController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier:"MineBusinessOrderCell", for: indexPath) as! MineBusinessOrderCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.section]
        let vc = MessageDetailController()
        vc.model = model
        vc.co_username = model.co_username
        vc.co_avatar = model.avatar
        weak var weakSelf = self
        vc.cancelBlock = { () in
            weakSelf?.listView.tabView.mj_header.beginRefreshing()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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
