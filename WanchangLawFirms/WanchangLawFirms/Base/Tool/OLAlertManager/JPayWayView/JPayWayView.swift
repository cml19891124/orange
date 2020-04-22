//
//  JPayWayView.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JPayWayViewDelegate: NSObjectProtocol {
    func jPayWayViewCompleteData()
}

class JPayWayView: UIView {
    
    weak var delegate: JPayWayViewDelegate?
    
    private lazy var headV: JPWHeadView = {
        () -> JPWHeadView in
        let temp = JPWHeadView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 50))
        return temp
    }()
    lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: 370), style: .plain, space: 0)
        temp.separatorStyle = .none
        temp.bounces = false
        temp.delegate = self
        temp.dataSource = self
        temp.tableHeaderView = headV
        temp.register(JPWOldPriceCell.self, forCellReuseIdentifier: "JPWOldPriceCell")
        temp.register(JPWCurrentPriceCell.self, forCellReuseIdentifier: "JPWCurrentPriceCell")
        temp.register(JPWPayCell.self, forCellReuseIdentifier: "JPWPayCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.addSubview(temp)
        return temp
    }()
    
    private let bindArr: [[String]] = [["old","current"],["wechat","alipay"],["ok"]]
    private var selectBind: String = "wechat"

    private var model: JPayModel!
    private var discount: Float = 1
    private var vipListArr: [JVipListModel] = [JVipListModel]()
    
    
    convenience init(model: JPayModel) {
        self.init()
        self.model = model
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.layer.opacity = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        if UserInfo.share.is_vip {
            self.getDataSource()
        } else {
            self.tabView.reloadData()
        }
    }
    
    private var current_price: String {
        get {
            if model.service_type == .vip && model.id != "0" {
                if UserInfo.share.is_vip {
                    if self.vipListArr.count > UserInfo.share.vip_from_index + 1 {
                        let currentM = self.vipListArr[UserInfo.share.vip_from_index]
                        let next = Float(model.price)
                        let current = Float(currentM.price)
                        if next != nil && current != nil {
                            let result = next! - current!
                            let price = String.init(format: "%.2f", result)
                            return price
                        }
                    }
                } else {
                    return model.price
                }
            } else {
                if UserInfo.share.is_business {
                    if UserInfo.share.businessModel?.vip == "3" && model.id == "12" {
                        let result = model.j_price * 0.9
                        let price = String.init(format: "%.2f", result)
                        return price
                    } else {
                        return model.price
                    }
                } else {
                    let result = model.j_price * self.discount
                    let price = String.init(format: "%.2f", result)
                    return price
                }
            }
            return "0"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        OLAlertManager.share.payHide()
    }
    
    private func getDataSource() {
        UserInfo.share.getVipList { (arr) in
            self.vipListArr = arr
            if arr.count > UserInfo.share.vip_from_index {
                let m = arr[UserInfo.share.vip_from_index]
                self.discount = Float(m.vip_discount) ?? 1
                self.tabView.reloadData()
            }
        }
    }

}

extension JPayWayView: UITableViewDelegate, UITableViewDataSource {
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
        if bind == "old" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JPWOldPriceCell", for: indexPath) as! JPWOldPriceCell
            if UserInfo.share.is_business {
                if model.service_type == .vip && model.id != "0" {
                    cell.oldPrice = model.price
                } else {
                    cell.id = model.id
                }
            } else {
                cell.oldPrice = model.price
            }
            return cell
        } else if bind == "current" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JPWCurrentPriceCell", for: indexPath) as! JPWCurrentPriceCell
            if UserInfo.share.is_business {
                if model.service_type == .vip && model.id != "0" {
                    cell.lab1.text = "折扣价"
                    cell.lab2.text = "¥" + current_price
                } else {
                    cell.lab1.text = "订单价格"
                    cell.lab2.text = "¥" + current_price
                }
            } else {
                cell.lab1.text = "折扣价"
                cell.lab2.text = "¥" + current_price
            }
            return cell
        } else if bind == "ok" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
            cell.backgroundColor = kCellColor
            cell.btn.setTitle(L$("immediate_pay"), for: .normal)
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "JPWPayCell", for: indexPath) as! JPWPayCell
        if bind == "wechat" {
            cell.titleBtn.setImage(UIImage.init(named: "wechat_pay"), for: .normal)
            cell.titleBtn.setTitle(kBtnSpaceString + "微信支付", for: .normal)
        } else {
            cell.titleBtn.setImage(UIImage.init(named: "alipay_pay"), for: .normal)
            cell.titleBtn.setTitle(kBtnSpaceString + "支付宝支付", for: .normal)
        }
        if bind == selectBind {
            cell.selBtn.isSelected = true
        } else {
            cell.selBtn.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = bindArr[indexPath.section]
        let bind = arr[indexPath.row]
        if bind == "wechat" || bind == "alipay" {
            selectBind = bind
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arr = bindArr[indexPath.section]
        let bind = arr[indexPath.item]
        if bind == "old" {
            return 20
        } else if bind == "current" {
            return 30
        } else if bind == "ok" {
            return 90
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        vv?.contentView.backgroundColor = kCellColor
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

extension JPayWayView: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        var pay_type = "1"
        if selectBind == "alipay" {
            pay_type = "2"
        }
        sender.isUserInteractionEnabled = false
        var order_type: String = "1"
        if UserInfo.share.is_business {
            order_type = "2"
        }
        if model.service_type == .custom {
            let mulPrams = NSMutableDictionary()
            mulPrams["pid"] = model.id
            mulPrams["pay_type"] = pay_type
            mulPrams["order_type"] = order_type
            mulPrams["problem"] = model.content
            mulPrams["images"] = model.images
            mulPrams["attribute"] = model.files
            if model.j_isDocument {
                mulPrams["posts_id"] = model.j_pid
                mulPrams["email"] = model.j_email
            }
//            let prams: NSDictionary = ["pid":model.id,"pay_type":pay_type,"order_type":order_type,"problem":model.content,"images":model.images]
            HomeManager.share.orderCreate(prams: mulPrams) { (flag, sn) in
                if flag {
                    if sn != nil {
                        self.payDeal(pay_type: pay_type, sn: sn!)
                    }
                } else {
                    if sn?.haveTextStr() == true {
                        OLAlertManager.share.payHide()
                        self.delegate?.jPayWayViewCompleteData()
                    }
                    sender.isUserInteractionEnabled = true
                }
            }
        } else if model.service_type == .vip {
            let prams: NSDictionary = ["vip":model.id,"pay_type":pay_type,"order_type":order_type]
            HomeManager.share.vipOrderCreate(prams: prams) { (flag, sn) in
                if flag {
                    if sn != nil {
                        self.payDeal(pay_type: pay_type, sn: sn!)
                    }
                } else {
                    if sn?.haveTextStr() == true {
                        OLAlertManager.share.payHide()
                        self.delegate?.jPayWayViewCompleteData()
                    }
                }
            }
        }
    }
    
    private func payDeal(pay_type: String, sn: String) {
        UserInfo.share.order_sn = sn
        if model.service_type == .vip {
            UserInfo.share.order_type = "2"
        } else {
            UserInfo.share.order_type = "1"
        }
        OLAlertManager.share.payHide()
        JPayApiManager.share.pay(pay_type: pay_type)
    }
}
