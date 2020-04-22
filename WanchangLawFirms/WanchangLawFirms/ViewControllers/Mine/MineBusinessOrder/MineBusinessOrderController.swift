//
//  MineBusinessOrderController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/16.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业订单
class MineBusinessOrderController: BaseController {
    
    private lazy var titleV: MBTitleView = {
        () -> MBTitleView in
        let temp = MBTitleView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 44))
        temp.delegate = self
        return temp
    }()
    private lazy var chooseV: MBChooseView = {
        () -> MBChooseView in
        let temp = MBChooseView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight))
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

extension MineBusinessOrderController: MBTitleViewDelegate {
    func mbTitleViewClick(sender: HImgCenterAlignmentBtn) {
        self.chooseV.isHidden = !sender.isSelected
        self.chooseV.block = { () in
            sender.isSelected = false
        }
    }
}

extension MineBusinessOrderController: MBChooseViewDelegate {
    func mbChooseViewStatusClick(m: JBindModel) {
        let order_status: String = HomeManager.share.statusIdBy(bind: m.bind)
        mulPrams["order_status"] = order_status
        self.listView.tabView.mj_header.beginRefreshing()
    }
    
    func mbChooseViewTypeClick(m: JBindModel) {
        let product_id: String = HomeManager.share.idByBind(bind: m.bind)
        mulPrams["product_id"] = product_id
        self.listView.tabView.mj_header.beginRefreshing()
    }
}

extension MineBusinessOrderController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        } else {
            self.getFooterDataSource()
        }
    }
    
    private func getHeaderDataSource() {
        mulPrams["page"] = "1"
        HomeManager.share.companyOrders(prams: mulPrams) { (arr) in
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
        HomeManager.share.companyOrders(prams: mulPrams) { (arr) in
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


extension MineBusinessOrderController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let model = dataArr[indexPath.section]
        if model.order_status != "1" {
            if model.order_status == "0" {
                if model.product_title == "律师约见" || model.product_title == "企业培训" {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let model = self.dataArr[indexPath.section]
        var message = ""
        if model.co_username == UserInfo.share.business_username {
            message = "删除订单后将无法再查看该订单详情，确定删除该订单？"
        } else {
            message = "该订单为子账号订单，删除后子账号将无法再查看，但不影响母账号查看，确定删除该订单？"
        }
        let deleteAction = UITableViewRowAction.init(style: .normal, title: "删除") { (action, indexP) in
            tableView.setEditing(false, animated: true)
            self.commitAction(titleStr: "删除订单", message: message, model: model, is_deleted: "2", index: indexP.section)
        }
        let sonAction = UITableViewRowAction.init(style: .normal, title: "删除子订单") { (action, indexP) in
            tableView.setEditing(false, animated: true)
            self.commitAction(titleStr: "删除子账号订单", message: message, model: model, is_deleted: "1", index: indexP.section)
        }
        deleteAction.backgroundColor = kRedColor
        sonAction.backgroundColor = kOrangeDarkColor
        if model.co_username != UserInfo.share.business_username && model.is_deleted == "0" {
            return [deleteAction, sonAction]
        }
        return [deleteAction]
    }
    
    private func commitAction(titleStr: String, message: String, model: MessageModel, is_deleted: String, index: Int) {
        let alertCon = UIAlertController.init(title: titleStr, message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: L$("sure"), style: .default, handler: { (action) in
            let prams: NSDictionary = ["order_sn":model.order_sn,"is_deleted":is_deleted]
            HomeManager.share.companyOrderDelete(prams: prams) { (flag) in
                if flag {
                    if is_deleted == "2" {
                        self.dataArr.remove(at: index)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_user_order_change), object: nil)
                    } else {
                        model.is_deleted = "1"
                    }
                    self.listView.tabView.reloadData()
                }
            }
        })
        let cancelAction = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
        alertCon.addAction(sureAction)
        alertCon.addAction(cancelAction)
        self.present(alertCon, animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return L$("delete")
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let alertCon = UIAlertController.init(title: "删除订单后将无法再查看该订单详情，确定删除该订单？", message: nil, preferredStyle: .alert)
//        let sureAction = UIAlertAction.init(title: L$("sure"), style: .default, handler: { (action) in
//            let model = self.dataArr[indexPath.section]
//            let prams: NSDictionary = ["order_sn":model.order_sn,"is_deleted":"2"]
//            HomeManager.share.companyOrderDelete(prams: prams) { (flag) in
//                if flag {
//                    self.dataArr.remove(at: indexPath.section)
//                    tableView.reloadData()
//                }
//            }
//        })
//        let cancelAction = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
//        alertCon.addAction(sureAction)
//        alertCon.addAction(cancelAction)
//        self.present(alertCon, animated: true, completion: nil)
//    }
}

extension MineBusinessOrderController: MineOrderCellDelegate {
    func mineOrderCellAsk(model: MessageModel) {
        let vc = ChatController()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
