//
//  MBVipOrderDetailController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/4/5.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBVipOrderDetailController: BaseController {
    var messageModel: MessageModel = MessageModel()
    var block = { () in
        
    }
    private lazy var bindArr: [String] = {
        () -> [String] in
        if messageModel.order_status == "0" {
            return ["orange_tips","orange_company","orange_account","orange_bank_name","orange_number","orange_recognizer","ok"]
        }
        return ["orange_tips","orange_company","orange_account","orange_bank_name","orange_number","orange_recognizer"]
    }()
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.dataSource = self
        let tabView: UITableView = temp.tabView
        tabView.separatorStyle = .none
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(OrangeBankCell.self, forCellReuseIdentifier: "OrangeBankCell")
        tabView.register(OrangeBankCodeCell.self, forCellReuseIdentifier: "OrangeBankCodeCell")
        tabView.register(MineQuestionPayCell.self, forCellReuseIdentifier: "MineQuestionPayCell")
        tabView.register(OBPHeaderView.self, forHeaderFooterViewReuseIdentifier: "OBPHeaderView")
        self.view.addSubview(temp)
        return temp
    }()
    private var model: OrangeBankModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VIP线下转账信息"
        self.listView.tabView.mj_header.beginRefreshing()
        
    }
    
}

extension MBVipOrderDetailController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        }
    }
    
    private func getHeaderDataSource() {
        HomeManager.share.companyTransferInfo { (m) in
            self.listView.tabView.mj_header.endRefreshing()
            self.listView.j_footer.jRefreshNoTextMoreData()
            self.model = m
            self.listView.tabView.reloadData()
        }
    }
}

extension MBVipOrderDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = bindArr[indexPath.row]
        if bind == "orange_recognizer" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrangeBankCodeCell", for: indexPath) as! OrangeBankCodeCell
            cell.titleLab.text = L$(bind)
            cell.codeLab.text = messageModel.pay_code
            cell.tailLab.text = messageModel.pay_tips
            return cell
        } else if bind == "ok" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineQuestionPayCell", for: indexPath) as! MineQuestionPayCell
            cell.calView.getDataSource(bind1: "cancel_order", bind2: "confirm_pay")
            cell.calView.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrangeBankCell", for: indexPath) as! OrangeBankCell
        cell.titleLab.text = L$(bind)
        if bind == "orange_tips" {
            cell.tailLab.text = model?.tips
        } else if bind == "orange_company" {
            cell.tailLab.text = model?.name
        } else if bind == "orange_account" {
            cell.tailLab.text = model?.account
        } else if bind == "orange_bank_name" {
            cell.tailLab.text = model?.bank
        } else if bind == "orange_number" {
            cell.tailLab.text = model?.number
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bind = bindArr[indexPath.row]
        if bind == "orange_recognizer" {
            return 150
        } else if bind == "ok" {
            return 120
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OBPHeaderView") as! OBPHeaderView
        if messageModel.vip_id == "1" {
            vv.headLab.text = "黄金会员"
        } else if messageModel.vip_id == "2" {
            vv.headLab.text = "钻石会员"
        } else if messageModel.vip_id == "3" {
            vv.headLab.text = "星耀会员"
        } else if messageModel.vip_id == "4" {
            vv.headLab.text = "荣耀会员"
        }
        let str1 = "转账金额："
        let str2 = "¥" + messageModel.amount
        let totalStr = str1 + str2
        let mulStr = NSMutableAttributedString.init(string: totalStr)
        mulStr.addAttribute(NSAttributedString.Key.font, value: kFontXXL, range: NSRange.init(location: str1.count, length: str2.count))
        vv.tailLab.attributedText = mulStr
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension MBVipOrderDetailController: JCalculateResetViewDelegate {
    func jcalculateResetViewBtnsClick(sender: UIButton, bind: String) {
        let prams: NSDictionary = ["order_sn":messageModel.order_sn]
        var titleStr = "确定已支付订单？"
        var isCancel = false
        if bind == "cancel_order" {
            titleStr = "确定取消订单？"
            isCancel = true
        }
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: titleStr, message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            HomeManager.share.orderVipConfirmCancel(isCancel: isCancel, prams: prams, success: { (flag) in
                if flag {
                    self.block()
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }, cancelHandler: nil)
    }
    
}
