//
//  InvoiceApplyController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceApplyController: BaseController {
    
    var block = { () in
        
    }
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - 110), style: .plain, space: kLeftSpaceS)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(InvoiceApplyCell.self, forCellReuseIdentifier: "InvoiceApplyCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var bottomV: InvoiceApplyBottomView = {
        () -> InvoiceApplyBottomView in
        let temp = InvoiceApplyBottomView.init(frame: CGRect.init(x: 0, y: kDeviceHeight - 110, width: kDeviceWidth, height: 110))
        temp.delegate = self
        return temp
    }()
    private var dataArr: [InvoiceListModel] = [InvoiceListModel]()
    private var selectedArr: [InvoiceListModel] = [InvoiceListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("m_invoice_apply")
        self.listView.tabView.mj_header.beginRefreshing()
        self.view.addSubview(bottomV)
    }
}

extension InvoiceApplyController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getDataSource()
        }
    }
    
    private func getDataSource() {
        HomeManager.share.userTradesInvoice { (arr) in
            self.listView.tabView.mj_header.endRefreshing()
            self.dataArr.removeAll()
            if arr != nil && arr!.count > 0 {
                for m in arr! {
                    self.dataArr.append(m)
                }
            }
            self.listView.tabView.reloadData()
            self.invoiceApplyCellSelected()
        }
    }
}

extension InvoiceApplyController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceApplyCell", for: indexPath) as! InvoiceApplyCell
        cell.delegate = self
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension InvoiceApplyController: InvoiceApplyCellDelegate {
    func invoiceApplyCellSelected() {
        var total_amount: Float = 0
        self.selectedArr.removeAll()
        for m in self.dataArr {
            if m.isSelected {
                self.selectedArr.append(m)
            }
            let amount = Float(m.amount)
            if amount != nil {
                total_amount += amount!
            }
        }
        var selected_amount: Float = 0
        for m in self.selectedArr {
            let amount = Float(m.amount)
            if amount != nil {
                selected_amount += amount!
            }
        }
        self.bottomV.totalAmount = total_amount
        self.bottomV.selectedCount = self.selectedArr.count
        self.bottomV.selectedAmount = selected_amount
        self.bottomV.isSelectedAll = self.selectedArr.count == self.dataArr.count
    }
}

extension InvoiceApplyController: InvoiceApplyBottomViewDelegate {
    func invoiceApplySelectedAllClick(selectedAll: Bool) {
        self.selectedArr.removeAll()
        var total_amount: Float = 0
        var selected_amount: Float = 0
        if selectedAll {
            for m in self.dataArr {
                m.isSelected = true
                let amount = Float(m.amount)
                if amount != nil {
                    total_amount += amount!
                    selected_amount += amount!
                }
                self.selectedArr.append(m)
            }
        } else {
            for m in self.dataArr {
                m.isSelected = false
            }
        }
        self.bottomV.totalAmount = total_amount
        self.bottomV.selectedCount = self.selectedArr.count
        self.bottomV.selectedAmount = selected_amount
        self.listView.tabView.reloadData()
    }
    
    func invoiceApplyBottomViewOKClick(sender: UIButton) {
        if selectedArr.count == 0 {
            PromptTool.promptText("请选择账单", 1)
            return
        }
        let vc = InvoiceDataController()
        vc.selectedArr = self.selectedArr
        weak var weakSelf = self
        vc.block = { () in
            weakSelf?.block()
            weakSelf?.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
