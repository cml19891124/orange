//
//  JBuyVIPView.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JBuyVipViewDelegate: NSObjectProtocol {
    func jBuyVipViewXieYiClick()
    func jBuyVipViewCompleteData()
}

class JBuyVIPView: UIView {
    
    weak var delegate: JBuyVipViewDelegate?
    lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: 500), style: .plain, space: kLeftSpaceS)
        temp.bounces = false
        temp.separatorColor = kLineGrayColor
        temp.delegate = self
        temp.dataSource = self
        temp.register(JBVCell.self, forCellReuseIdentifier: "JBVCell")
        temp.register(JBVHeaderView.self, forHeaderFooterViewReuseIdentifier: "JBVHeaderView")
        temp.register(JBVFooterView.self, forHeaderFooterViewReuseIdentifier: "JBVFooterView")
        self.addSubview(temp)
        return temp
    }()
    private var current_index: Int = UserInfo.share.vip_from_index
    private var from_index: Int = UserInfo.share.vip_from_index
    private var dataArr: [JVipListModel] = [JVipListModel]()
    

    convenience init(is_upgrade: Bool) {
        self.init()
        if is_upgrade && UserInfo.share.is_vip {
            from_index += 1
            current_index += 1
        }
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.layer.opacity = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        self.getDataSouce()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        OLAlertManager.share.buyVipHide()
    }
    
    private func getDataSouce() {
        UserInfo.share.getVipList { (arr) in
            if arr.count == 0 {
                PromptTool.promptText(L$("p_fail"), 1)
                OLAlertManager.share.buyVipHide()
                return
            }
            self.dataArr = arr
            self.tabView.reloadData()
        }
    }

}

extension JBuyVIPView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JBVCell", for: indexPath) as! JBVCell
        cell.model = model
        if indexPath.row == current_index {
            cell.selBtn.isSelected = true
        } else {
            cell.selBtn.isSelected = false
        }
        if indexPath.row >= from_index {
            cell.backgroundColor = kCellColor
            cell.timeBtn.backgroundColor = kOrangeDarkColor
            cell.titleLab.textColor = kTextBlackColor
            cell.priceLab.textColor = kOrangeDarkColor
            cell.desLab.textColor = kTextBlackColor
        } else {
            cell.backgroundColor = kBaseColor
            cell.timeBtn.backgroundColor = kGrayColor
            cell.titleLab.textColor = kTextGrayColor
            cell.priceLab.textColor = kTextGrayColor
            cell.desLab.textColor = kTextGrayColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= from_index {
            current_index = indexPath.row
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let m = self.dataArr[indexPath.row]
        var h = m.vip_info.height(width: kDeviceWidth - kLeftSpaceL - 150, font: kFontS) + kLeftSpaceL * 2 + 30
        if h < 100 {
            h = 100
        }
        return h
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JBVHeaderView") as! JBVHeaderView
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JBVFooterView") as! JBVFooterView
        vv.lab.delegate = self
        vv.delegate = self
        if UserInfo.share.is_vip {
            if current_index == UserInfo.share.vip_from_index {
                vv.btn.setTitle(L$("constant_vip"), for: .normal)
            } else {
                vv.btn.setTitle(L$("confirm_upgrade"), for: .normal)
            }
        } else {
            vv.btn.setTitle(L$("confirm_open"), for: .normal)
        }
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 140
    }
}

extension JBuyVIPView: LLabelDelegate {
    func llabelClick(text: String) {
        OLAlertManager.share.buyVipHide()
        self.delegate?.jBuyVipViewXieYiClick()
    }
}

extension JBuyVIPView: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        OLAlertManager.share.buyVipHide()
        if UserInfo.share.vip_from_index == 2 {
            PromptTool.promptText(L$("p_vip_max"), 1)
            return
        }
        if UserInfo.share.is_business {
            self.businessPay()
        } else {
            self.appleNonRenewalSubscriptionPay()
        }
    }
    
//    private func personPay() {
//        var product_id = "vip_1_open"
//        if UserInfo.share.is_vip {
//            if UserInfo.share.vip_from_index == 0 {
//                if current_index == 1 {
//                    product_id = "vip_1_2"
//                } else if current_index == 2 {
//                    product_id = "vip_1_3"
//                }
//            } else if UserInfo.share.vip_from_index == 1 {
//                if current_index == 2 {
//                    product_id = "vip_2_3"
//                }
//            }
//        } else {
//            if current_index == 1 {
//                product_id = "vip_2_open"
//            } else if current_index == 2 {
//                product_id = "vip_3_open"
//            }
//        }
//        let m = self.dataArr[current_index]
//        let prams: NSDictionary = ["vip":m.id,"pay_type":"5"]
//        HomeManager.share.vipOrderCreate(prams: prams) { (flag, sn) in
//            if flag {
//                if sn != nil {
//                    UserInfo.share.order_sn = sn
//                    UserInfo.share.order_type = "2"
//                    if UserInfo.getStandard(key: standard_apple_paid_uncommit) != nil {
//                        JPayApiManager.share.verifyPurchase()
//                    } else {
//                        JPayApiManager.share.applePay(productId: product_id)
//                    }
//                }
//            } else {
//                if sn?.haveTextStr() == true {
//                    self.delegate?.jBuyVipViewCompleteData()
//                }
//            }
//        }
//    }
    
    private func appleNonRenewalSubscriptionPay() {
        var product_id = "vip_1_open_non_renewal_subscription"
        if UserInfo.share.is_vip {
            if UserInfo.share.vip_from_index == 0 {
                if current_index == 1 {
                    product_id = "vip_1_2_non_renewal_subscription"
                } else if current_index == 2 {
                    product_id = "vip_1_3_non_renewal_subscription"
                }
            } else if UserInfo.share.vip_from_index == 1 {
                if current_index == 2 {
                    product_id = "vip_2_3_non_renewal_subscription"
                }
            }
        } else {
            if current_index == 1 {
                product_id = "vip_2_open_non_renewal_subscription"
            } else if current_index == 2 {
                product_id = "vip_3_open_non_renewal_subscription"
            }
        }
        let m = self.dataArr[current_index]
        let prams: NSDictionary = ["vip":m.id,"pay_type":"5"]
        HomeManager.share.vipOrderCreate(prams: prams) { (flag, sn) in
            if flag {
                if sn != nil {
                    UserInfo.share.order_sn = sn
                    UserInfo.share.order_type = "2"
                    if UserInfo.getStandard(key: standard_apple_paid_uncommit) != nil {
                        JPayApiManager.share.verifyPurchase()
                    } else {
                        JPayApiManager.share.applePay(productId: product_id)
                    }
                }
            } else {
                if sn?.haveTextStr() == true {
                    self.delegate?.jBuyVipViewCompleteData()
                }
            }
        }
    }
    
    private func businessPay() {
        let model = dataArr[current_index]
        let m = JPayModel.init(service_type: JPayModelServiceType.vip, id: "\(current_index + 1)", price: model.price, content: "")
        OLAlertManager.share.payShow(model: m)
    }
}
