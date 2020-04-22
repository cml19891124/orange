//
//  MineBusinessVIPController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/27.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineBusinessVIPController: BaseController {
    
    var isBuy: Bool = false
    
//    private lazy var headV: JImgViewSelfAdapt = {
//        () -> JImgViewSelfAdapt in
//        let temp = JImgViewSelfAdapt.init(imgName: "m_vip_banner", wid: kDeviceWidth)
//        temp.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: temp.end_height)
//        return temp
//    }()
    private lazy var headV: JNetAdaptImgView = {
        () -> JNetAdaptImgView in
        let temp = JNetAdaptImgView.init(referenceWidth: 360, referenceHeight: 152, end_width: kDeviceWidth)
        temp.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: temp.end_height)
        return temp
    }()
    private lazy var footV: JOKBtnView = {
        () -> JOKBtnView in
        let temp = JOKBtnView.init(frame: CGRect.init(x: 0, y: kDeviceHeight - 100, width: kDeviceWidth, height: 100))
        temp.delegate = self
        self.view.addSubview(temp)
        return temp
    }()
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - 100), style: .plain, space: 0)
        temp.tableHeaderView = headV
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(ForensicCalculatorTitleCell.self, forCellReuseIdentifier: "ForensicCalculatorTitleCell")
        temp.register(MineVIPCell.self, forCellReuseIdentifier: "MineVIPCell")
        temp.register(MineBusinessVIPCell.self, forCellReuseIdentifier: "MineBusinessVIPCell")
        temp.register(MineVIPSumCell.self, forCellReuseIdentifier: "MineVIPSumCell")
        temp.register(ConsultReminderCell.self, forCellReuseIdentifier: "ConsultReminderCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        temp.register(MineQuestionPayCell.self, forCellReuseIdentifier: "MineQuestionPayCell")
        self.view.addSubview(temp)
        return temp
    }()
//    private let bindArr: [String] = ["m_vip_rights","vip_consult","vip_template","business_vip_rank","vip_sum","m_vip_regular","ok"]
    private let bindArr: [String] = ["m_vip_rights","vip_consult","vip_template","business_vip_rank","vip_sum","m_vip_regular"]
    
    private var vip_bind: String {
        get {
            if UserInfo.share.is_vip {
                return "upgrade_vip"
            }
            return "open_vip"
        }
    }
    private var model: MineBusinessVIPModel = MineBusinessVIPModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserInfo.share.is_business {
            self.title = L$("mine_business_vip")
        } else {
            self.title = L$("mine_vip")
        }
        self.reload()
        self.getDataSource()
        self.getImgDataSource()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "开通记录", style: .done, target: self, action: #selector(rightClick))
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: noti_user_model_refresh), object: nil)
        JPayApiManager.share.delegate = self
    }
    
    private func getDataSource() {
        let prams: NSDictionary = ["symbol":"vipqy"]
        HomeManager.share.businessVipView(prams: prams) { (model) in
            if model != nil {
                self.model = model!
                self.reload()
            }
        }
    }
    
    private func getImgDataSource() {
        let prams: NSDictionary = ["symbol":"company_member_icon"]
        HomeManager.share.businessVipView(prams: prams) { (model) in
            guard let m = model else {
                return
            }
            guard let s1 = (m.content as NSString).components(separatedBy: "src=").last else {
                return
            }
            guard let s2 = (s1 as NSString).components(separatedBy: "style=").first else {
                return
            }
            var result = (s2 as NSString).replacingOccurrences(of: "\\", with: "")
            result = (result as NSString).replacingOccurrences(of: "\"", with: "")
            result = (result as NSString).replacingOccurrences(of: " ", with: "")
            self.headV.sd_setImage(with: URL.init(string: result), completed: nil)
        }
    }
    
    @objc private func reload() {
        self.tabView.reloadData()
        self.footV.btn.setTitle(L$(vip_bind), for: .normal)
    }
    
    @objc private func rightClick() {
        let vc = MBVipOrderListController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MineBusinessVIPController: JPayApiManagerDelegate {
    func jPayApiManagerPayResult(success: Bool) {
        if success {
            var titleStr = "已开通黄金会员"
            if UserInfo.share.is_vip {
                if UserInfo.share.vip_from_index == 0 {
                    titleStr = "已开通钻石会员"
                } else if UserInfo.share.vip_from_index == 1 {
                    titleStr = "已开通星耀会员"
                } else if UserInfo.share.vip_from_index == 2 {
                    titleStr = "已开通荣耀会员"
                }
            }
            JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: titleStr, message: "", sure: L$("sure"), cancel: nil, sureHandler: { (action) in
                
            }, cancelHandler: nil)
            UserInfo.share.order_sn = nil
            UserInfo.share.netUserInfo()
        }
    }
}

extension MineBusinessVIPController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = bindArr[indexPath.item]
        if bind == "m_vip_rights" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForensicCalculatorTitleCell", for: indexPath) as! ForensicCalculatorTitleCell
            cell.bind = bind
            return cell
        } else if bind == "m_vip_regular" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConsultReminderCell", for: indexPath) as! ConsultReminderCell
            cell.titleStr = RemindersManager.share.remindTitle(bind: bind)
            cell.reminder = RemindersManager.share.reminders(bind: "m_vip_regular")
            return cell
        } else if bind == "ok" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
            cell.btn.setTitle(L$(vip_bind), for: .normal)
            cell.delegate = self
            return cell
        } else if bind == "vip_sum" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineVIPSumCell", for: indexPath) as! MineVIPSumCell
            cell.lab.text = RemindersManager.share.reminders(bind: "vip_sum")
            return cell
        } else if bind == "business_vip_rank" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineBusinessVIPCell", for: indexPath) as! MineBusinessVIPCell
            cell.line.isHidden = true
            cell.dataArr = self.model.businessVipModel.vipArr
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineVIPCell", for: indexPath) as! MineVIPCell
        cell.bind = bind
        if bind == "vip_consult" {
            cell.line.isHidden = false
        } else if bind == "vip_template" {
            cell.line.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bind = bindArr[indexPath.row]
        if bind == "m_vip_rights" {
            return 40
        } else if bind == "m_vip_regular" {
            return RemindersManager.share.remiderHeight(bind: "m_vip_regular", font: kFontMS, width: kDeviceWidth - kLeftSpaceL * 2) + kLeftSpaceS * 3 + 20
        } else if bind == "ok" {
            return 100
        } else if bind == "vip_sum" {
            return RemindersManager.share.remiderHeight(bind: "vip_sum", font: kFontMS, width: kDeviceWidth - kLeftSpaceL * 2) + kLeftSpaceS * 2
        } else if bind == "business_vip_rank" {
            var temp: CGFloat = 0
            for m in self.model.businessVipModel.vipArr {
                let h = m.content.height(width: kDeviceWidth - kLeftSpaceL * 2 - 40 - 15, font: kFontMS)
                temp += h
            }
            return temp + kLeftSpaceS * 2 + 30
        }
        return RemindersManager.share.remiderHeight(bind: bind, font: kFontMS, width: kDeviceWidth - kLeftSpaceL - kLeftSpaceS - 40) + kLeftSpaceS * 2 + 30
    }
    
}

extension MineBusinessVIPController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        OLAlertManager.share.buyBusinessVipShow(is_upgrade: true)
        OLAlertManager.share.buyBusinessVipView?.delegate = self
    }
}

extension MineBusinessVIPController: JBuyBusinessVIPViewDelegate {
    func jBuyBusinessVipViewXieYiClick() {
        let urlStr = BASE_URL + api_posts_info + "?symbol=qy_member"
        let vc = JSafariController.init(urlStr: urlStr, title: "会员协议")
        self.present(vc, animated: true, completion: nil)
    }
    
    func jBuyBusinessVipViewVipClick(model: JPayModel) {
        self.orderList(model: model)
    }
}

extension MineBusinessVIPController {
    private func orderList(model: JPayModel) {
        HomeManager.share.companyVipOrderList { (arr) in
            if arr != nil && arr!.count > 0 {
                for m in arr! {
                    if m.vip_id == model.id && (m.order_status == "0" || m.order_sn == "2") {
                        self.lastAlert(model: m)
                        return
                    }
                }
            }
            self.orderCreate(model: model)
        }
    }
    
    private func orderCreate(model: JPayModel) {
        let prams: NSDictionary = ["vip":model.id,"pay_type":"4","order_type":"2"]
        HomeManager.share.vipOrderCreate(prams: prams) { (flag, sn) in
            if (flag) {
                if sn != nil {
                    self.orderDetail(sn: sn!)
                }
            }
        }
    }
    
    private func orderDetail(sn: String) {
        let prams: NSDictionary = ["order_sn":sn]
        HomeManager.share.companyVipOrderView(prams: prams) { (model) in
            if model != nil {
                self.lastAlert(model: model!)
            }
        }
    }
    
    private func lastAlert(model: MessageModel) {
//        OLAlertManager.share.orangeBankShow()
//        OLAlertManager.share.orangeBankView?.bankView.vip_id = model.vip_id
//        OLAlertManager.share.orangeBankView?.bankView.price = model.amount
//        OLAlertManager.share.orangeBankView?.bankView.pay_code = model.pay_code
//        OLAlertManager.share.orangeBankView?.bankView.pay_tips = model.pay_tips
        let vc = MBVipOrderDetailController()
        vc.messageModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
