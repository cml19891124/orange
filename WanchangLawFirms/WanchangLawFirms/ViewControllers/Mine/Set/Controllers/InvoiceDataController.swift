//
//  InvoiceDataController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/25.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceDataController: BaseController {
    
    var selectedArr: [InvoiceListModel] = [InvoiceListModel]() {
        didSet {
            for i in 0..<selectedArr.count {
                let mo = selectedArr[i]
                let temp = Float(mo.amount)
                if temp != nil {
                    open_amount += temp!
                    open_orderIds += mo.id
                    if i < selectedArr.count - 1 {
                        open_orderIds += "-"
                    }
                }
            }
        }
    }
    private var open_amount: Float = 0
    private var open_orderIds: String = ""
    
    var block = { () in
        
    }
    
    private var isBusiness: Bool = false

    var id: String = ""
    private var bindArr: [[String]] = [[String]]()
    
    private lazy var footView: JOKBtnView = {
        () -> JOKBtnView in
        let temp = JOKBtnView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 120))
        temp.btn.setTitle("提交申请", for: .normal)
        temp.delegate = self
        return temp
    }()
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: kLeftSpaceS)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(InvoiceDataCell.self, forCellReuseIdentifier: "InvoiceDataCell")
        tabView.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        
        tabView.register(InvoiceHeadLabCell.self, forCellReuseIdentifier: "InvoiceHeadLabCell")
        tabView.register(InvoiceHeadTypeCell.self, forCellReuseIdentifier: "InvoiceHeadTypeCell")
        tabView.register(InvoiceHeadBtnCell.self, forCellReuseIdentifier: "InvoiceHeadBtnCell")
        tabView.register(InvoiceHeadTFCell.self, forCellReuseIdentifier: "InvoiceHeadTFCell")
        tabView.register(InvoiceHeadLookCell.self, forCellReuseIdentifier: "InvoiceHeadLookCell")
        
        self.view.addSubview(temp)
        return temp
    }()
    
    private var model: InvoiceListModel = InvoiceListModel()
    private var currentModel: InvoiceHeadListModel = InvoiceHeadListModel()
    private var headLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("m_invoice_data")
        JKeyboardNotiManager.share.delegate = self
        if selectedArr.count > 0 {
            self.listView.tabView.bounces = false
            if UserInfo.share.is_business {
                self.isBusiness = true
            }
            self.config()
        } else {
            self.config()
            self.listView.tabView.mj_header.beginRefreshing()
        }
    }
    
    private func config() {
        if selectedArr.count > 0 {
            if isBusiness {
                bindArr = [["m_invoice_data_amount"],["m_invoice_data_head","m_invoice_data_head_type","m_invoice_data_type"],["m_invoice_data_tax","m_invoice_data_address","m_invoice_data_phone","m_invoice_data_bank","m_invoice_data_account"]]
                self.getInvoiceDataSource()
            } else {
                bindArr = [["m_invoice_data_amount"],["m_invoice_data_head","m_invoice_data_head_type","m_invoice_data_type"]]
            }
            self.listView.tabView.tableFooterView = footView
            self.listView.tabView.reloadData()
        }
    }
    
    private func getInvoiceDataSource() {
        if headLoaded {
            return
        }
        HomeManager.share.invoiceHeadInfo { (m) in
            if m?.head_name.haveTextStr() == true {
                self.currentModel = m!
                self.listView.tabView.reloadData()
            }
            self.headLoaded = true
        }
    }

}

extension InvoiceDataController: JKeyboardNotiManagerDelegate {
    func jkeyboardHeightChange(kH: CGFloat, duration: Double) {
        self.listView.tabView.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kH)
    }
    
    func jkeyboardWillHide(kH: CGFloat, duration: Double) {
        self.listView.tabView.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceHeight - kNavHeight)
    }
}

extension InvoiceDataController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getDataSource()
        }
    }
    
    private func getDataSource() {
        let prams: NSDictionary = ["id": id]
        HomeManager.share.invoiceView(prams: prams) { (m) in
            self.listView.tabView.mj_header.endRefreshing()
            if m != nil {
                self.model = m!
                if self.model.type == "1" {
                    self.bindArr = [["m_invoice_data_amount"],["m_invoice_data_head","m_invoice_data_head_type","m_invoice_data_type"],["m_invoice_data_tax","m_invoice_data_address","m_invoice_data_phone","m_invoice_data_bank","m_invoice_data_account"]]
                } else {
                    self.bindArr = [["m_invoice_data_amount"],["m_invoice_data_head","m_invoice_data_head_type","m_invoice_data_type"]]
                }
                self.listView.tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
            }
            self.listView.tabView.reloadData()
        }
    }
}

extension InvoiceDataController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = bindArr[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = bindArr[indexPath.section]
        let bind = arr[indexPath.row]
        
        if bind == "m_invoice_data_head" {
            if selectedArr.count > 0 {
                if !isBusiness {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeadLabCell", for: indexPath) as! InvoiceHeadLabCell
                    cell.titleLab.text = L$(bind)
                    cell.tailLab.text = "个人"
                    return cell
                }
            }
        } else if bind == "m_invoice_data_head_type" {
            if selectedArr.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeadTypeCell", for: indexPath) as! InvoiceHeadTypeCell
                cell.delegate = self
                cell.titleLab.text = L$(bind)
                return cell
            }
        } else if bind == "m_invoice_data_type" {
            if selectedArr.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeadBtnCell", for: indexPath) as! InvoiceHeadBtnCell
                cell.titleLab.text = L$(bind)
                cell.tailBtn.setTitle("增值税普通发票", for: .normal)
                return cell
            }
        }
        if selectedArr.count > 0 {
            if bind != "m_invoice_data_amount" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeadTFCell", for: indexPath) as! InvoiceHeadTFCell
                cell.titleLab.text = L$(bind)
                cell.tf.delegate = self
                cell.tf.placeholder = L$(bind)
                if bind == "m_invoice_data_head" {
                    cell.tf.text = currentModel.head_name
                } else if bind == "m_invoice_data_tax" {
                    cell.tf.text = currentModel.head_sn
                } else if bind == "m_invoice_data_address" {
                    cell.tf.text = currentModel.address
                } else if bind == "m_invoice_data_phone" {
                    cell.tf.text = currentModel.phone
                } else if bind == "m_invoice_data_bank" {
                    cell.tf.text = currentModel.bank
                } else if bind == "m_invoice_data_account" {
                    cell.tf.text = currentModel.account
                }
                return cell
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDataCell", for: indexPath) as! InvoiceDataCell
        cell.titleLab.text = L$(bind)
        if bind == "m_invoice_data_amount" {
            if selectedArr.count > 0 {
                cell.tailLab.text = String.init(format: "¥%.2f", open_amount)
            } else {
                cell.tailLab.text = "¥" + model.amount
            }
        } else if bind == "m_invoice_data_head" {
            cell.tailLab.text = model.head_name
        } else if bind == "m_invoice_data_head_type" {
            if model.type == "1" {
                cell.tailLab.text = "企业(电子发票)"
            } else {
                cell.tailLab.text = "个人(电子发票)"
            }
        } else if bind == "m_invoice_data_type" {
            cell.tailLab.text = "增值税普通发票"
        } else if bind == "m_invoice_data_tax" {
            cell.tailLab.text = model.head_sn
        } else if bind == "m_invoice_data_bank" {
            cell.tailLab.text = model.bank
        } else if bind == "m_invoice_data_account" {
            cell.tailLab.text = model.account
        } else if bind == "m_invoice_data_address" {
            cell.tailLab.text = model.address
        } else if bind == "m_invoice_data_phone" {
            cell.tailLab.text = model.phone
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceS
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension InvoiceDataController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == L$("m_invoice_data_head") {
            currentModel.head_name = textField.text ?? ""
        } else if textField.placeholder == L$("m_inovce_head_type") {
            currentModel.head_type = textField.text ?? ""
        } else if textField.placeholder == L$("m_invoice_data_tax") {
            currentModel.head_sn = textField.text ?? ""
        } else if textField.placeholder == L$("m_invoice_data_bank") {
            currentModel.bank = textField.text ?? ""
        } else if textField.placeholder == L$("m_invoice_data_account") {
            currentModel.account = textField.text ?? ""
        } else if textField.placeholder == L$("m_invoice_data_address") {
            currentModel.address = textField.text ?? ""
        } else if textField.placeholder == L$("m_invoice_data_phone") {
            currentModel.phone = textField.text ?? ""
        }
    }
}

extension InvoiceDataController: InvoiceHeadTypeCellDelegate {
    func invoiceHeadTypeCellClick(isBusiness: Bool) {
        self.isBusiness = isBusiness
        self.config()
    }
}

extension InvoiceDataController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        if isBusiness {
            self.businessInvoice(arr: selectedArr, m: currentModel, sender: sender)
        } else {
            self.personInvoice(arr: selectedArr, sender: sender)
        }
    }
    
    private func personInvoice(arr: [InvoiceListModel], sender: UIButton) {
        sender.isUserInteractionEnabled = false
        let mulPrams: NSMutableDictionary = NSMutableDictionary()
        mulPrams["head_name"] = "个人"
        mulPrams["head_type"] = "0"
        mulPrams["type"] = "0"
        mulPrams["head_info_type"] = "0"
        mulPrams["amount"] = String.init(format: "%.2f", open_amount)
        mulPrams["order_ids"] = open_orderIds
        HomeManager.share.invoiceCreate(prams: mulPrams) { (flag) in
            if flag {
                self.block()
                self.navigationController?.popViewController(animated: true)
            }
            sender.isUserInteractionEnabled = true
        }
    }
    
    private func businessInvoice(arr: [InvoiceListModel], m: InvoiceHeadListModel, sender: UIButton) {
        if m.head_name.haveTextStr() != true {
            PromptTool.promptText("请输入发票抬头", 1)
            return
        }
        if m.head_sn.haveTextStr() != true {
            PromptTool.promptText("请输入税务登记账号", 1)
            return
        }
        sender.isUserInteractionEnabled = false
        let mulPrams: NSMutableDictionary = NSMutableDictionary()
        mulPrams["head_name"] = m.head_name
        mulPrams["head_type"] = "0"
        mulPrams["type"] = "1"
        mulPrams["head_sn"] = m.head_sn
        mulPrams["account"] = m.account
        mulPrams["address"] = m.address
        mulPrams["phone"] = m.phone
        mulPrams["bank"] = m.bank
        mulPrams["head_info_type"] = "1"
        var amount: Float = 0
        var order_ids: String = ""
        for i in 0..<arr.count {
            let mo = arr[i]
            let temp = Float(mo.amount)
            if temp != nil {
                amount += temp!
                order_ids += mo.id
                if i < arr.count - 1 {
                    order_ids += "-"
                }
            }
        }
        mulPrams["amount"] = String.init(format: "%.2f", amount)
        mulPrams["order_ids"] = order_ids
        HomeManager.share.invoiceCreate(prams: mulPrams) { (flag) in
            if flag {
                self.block()
                self.navigationController?.popViewController(animated: true)
            }
            sender.isUserInteractionEnabled = true
        }
    }
}
