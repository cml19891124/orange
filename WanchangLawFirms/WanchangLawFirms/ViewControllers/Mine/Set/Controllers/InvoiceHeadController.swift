//
//  InvoiceHeadController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceHeadController: BaseController {
    
    var isLook: Bool = false
    var selectedArr: [InvoiceListModel] = [InvoiceListModel]()
    var block = { () in
        
    }
    
    private var isBusiness: Bool = false
    private var bindArr: [[String]] = [[String]]()
    
    private lazy var tableView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: kLeftSpaceS)
        temp.delegate = self
        temp.dataSource = self
        temp.register(InvoiceHeadLabCell.self, forCellReuseIdentifier: "InvoiceHeadLabCell")
        temp.register(InvoiceHeadTypeCell.self, forCellReuseIdentifier: "InvoiceHeadTypeCell")
        temp.register(InvoiceHeadBtnCell.self, forCellReuseIdentifier: "InvoiceHeadBtnCell")
        temp.register(InvoiceHeadTFCell.self, forCellReuseIdentifier: "InvoiceHeadTFCell")
        temp.register(InvoiceHeadLookCell.self, forCellReuseIdentifier: "InvoiceHeadLookCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var footView: JOKBtnView = {
        () -> JOKBtnView in
        let temp = JOKBtnView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 200))
        temp.delegate = self
        temp.btn.setTitle(L$("save"), for: .normal)
        return temp
    }()
    
    private var currentModel: InvoiceHeadListModel = InvoiceHeadListModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("m_invoice_head")
        if UserInfo.share.is_business {
            self.isBusiness = true
            currentModel.head_name = UserInfo.share.businessModel?.name ?? ""
        } else {
            self.isBusiness = false
        }
        self.config()
        JKeyboardNotiManager.share.delegate = self
        self.getDataSource()
    }
    
    private func config() {
        if isBusiness {
            bindArr = [["m_invoice_head"],["m_inovce_head_type","m_invoice_data_type","m_invoice_data_tax","m_invoice_data_address","m_invoice_data_phone","m_invoice_data_bank","m_invoice_data_account"]]
        } else {
            bindArr = [["m_invoice_head"],["m_inovce_head_type","m_invoice_data_type"]]
        }
    }
    
    private func getDataSource() {
        HomeManager.share.invoiceHeadInfo { (m) in
            if m?.head_name.haveTextStr() == true {
                self.isLook = true
                self.currentModel = m!
            } else {
                self.isLook = false
            }
            self.lastRefresh()
        }
    }
    
    private func lastRefresh() {
        if isLook {
            self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        } else {
            if isBusiness {
                self.tableView.tableFooterView = self.footView
            } else {
                self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
            }
        }
        self.tableView.reloadData()
    }
    
}

extension InvoiceHeadController: JKeyboardNotiManagerDelegate {
    func jkeyboardHeightChange(kH: CGFloat, duration: Double) {
        self.tableView.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kH)
    }
    
    func jkeyboardWillHide(kH: CGFloat, duration: Double) {
        self.tableView.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight)
    }
}

extension InvoiceHeadController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLook {
            return 1
        }
        return self.bindArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLook {
            return 1
        }
        return bindArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLook {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeadLookCell", for: indexPath) as! InvoiceHeadLookCell
            cell.delegate = self
            cell.model = currentModel
            return cell
        }
        let arr = bindArr[indexPath.section]
        let bind = arr[indexPath.row]
        if bind == "m_invoice_head" {
            if !isBusiness {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeadLabCell", for: indexPath) as! InvoiceHeadLabCell
                cell.titleLab.text = L$(bind)
                cell.tailLab.text = "个人"
                return cell
            }
        } else if bind == "m_inovce_head_type" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeadTypeCell", for: indexPath) as! InvoiceHeadTypeCell
            cell.delegate = self
            cell.titleLab.text = L$(bind)
            return cell
        } else if bind == "m_invoice_data_type" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeadBtnCell", for: indexPath) as! InvoiceHeadBtnCell
            cell.titleLab.text = L$(bind)
            cell.tailBtn.setTitle("增值税普通发票", for: .normal)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceHeadTFCell", for: indexPath) as! InvoiceHeadTFCell
        cell.titleLab.text = L$(bind)
        cell.tf.delegate = self
        cell.tf.placeholder = L$(bind)
        if bind == "m_invoice_head" {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLook {
            return 90
        }
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isLook {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return kCellSpaceS
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "编辑发票抬头"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.isLook = false
        self.lastRefresh()
    }
}

extension InvoiceHeadController: InvoiceHeadLookCellDelegate {
    func invoiceHeadLookCellEditClick() {
        self.isLook = false
        self.lastRefresh()
    }
}

extension InvoiceHeadController: InvoiceHeadTypeCellDelegate {
    func invoiceHeadTypeCellClick(isBusiness: Bool) {
        self.isBusiness = isBusiness
        self.config()
        self.lastRefresh()
    }
}

extension InvoiceHeadController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == L$("m_invoice_head") {
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

extension InvoiceHeadController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        self.view.endEditing(true)
        if currentModel.head_name.haveTextStr() != true {
            PromptTool.promptText("请输入发票抬头", 1)
            return
        }
        if currentModel.head_sn.haveTextStr() != true {
            PromptTool.promptText("请输入税务登记证号", 1)
            return
        }
        sender.isUserInteractionEnabled = false
        let mulPrams: NSMutableDictionary = NSMutableDictionary()
        mulPrams["head_name"] = currentModel.head_name
        mulPrams["head_type"] = "0" //0普通发票
        mulPrams["head_sn"] = currentModel.head_sn
        mulPrams["type"] = "1" // 0个人 1企业
        mulPrams["bank"] = currentModel.bank
        mulPrams["account"] = currentModel.account
        mulPrams["address"] = currentModel.address
        mulPrams["phone"] = currentModel.phone
        if currentModel.id.haveTextStr() == true {
            mulPrams["id"] = currentModel.id
            HomeManager.share.invoiceHeadUpdate(prams: mulPrams) { (flag) in
                sender.isUserInteractionEnabled = true
                if flag {
                    self.isLook = true
                    self.getDataSource()
                }
            }
        } else {
            HomeManager.share.invoiceHeadCreate(prams: mulPrams) { (flag) in
                sender.isUserInteractionEnabled = true
                if flag {
                    self.isLook = true
                    self.getDataSource()
                    if self.selectedArr.count > 0 {
                        self.openInvoice(arr: self.selectedArr, m: self.currentModel)
                    }
                }
            }
        }
    }
    
    private func openInvoice(arr: [InvoiceListModel], m: InvoiceHeadListModel) {
        let mulPrams: NSMutableDictionary = NSMutableDictionary()
        mulPrams["head_name"] = m.head_name
        mulPrams["head_type"] = m.head_type
        mulPrams["head_sn"] = m.head_sn
        mulPrams["type"] = "0"
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
        }
    }
}
