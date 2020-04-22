//
//  MineVIPController.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我的vip
class MineVIPController: BaseController {
    
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
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.tableHeaderView = headV
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(ForensicCalculatorTitleCell.self, forCellReuseIdentifier: "ForensicCalculatorTitleCell")
        temp.register(MineVIPCell.self, forCellReuseIdentifier: "MineVIPCell")
        temp.register(MineVIPSumCell.self, forCellReuseIdentifier: "MineVIPSumCell")
        temp.register(ConsultReminderCell.self, forCellReuseIdentifier: "ConsultReminderCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        temp.register(MineQuestionPayCell.self, forCellReuseIdentifier: "MineQuestionPayCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var bindArr: [String] = {
        () -> [String] in
        var temp = ["m_vip_rights","vip_consult","vip_template","vip_rank","vip_sum","m_vip_regular","ok"]
        if UserInfo.share.is_business {
            temp = ["m_vip_rights","vip_consult","vip_template","business_vip_rank","vip_sum","m_vip_regular","ok"]
        }
        return temp
    }()
    
    private var vip_bind: String {
        get {
            if UserInfo.share.is_vip {
                return "upgrade_vip"
            }
            return "open_vip"
        }
    }
    private var model: MineVIPModel?

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
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: noti_user_model_refresh), object: nil)
        JPayApiManager.share.delegate = self
    }
    
    private func getDataSource() {
        let prams: NSDictionary = ["symbol":"vip"]
        HomeManager.share.vipView(prams: prams) { (model) in
            if model != nil {
                self.model = model
                self.reload()
            }
        }
    }
    
    private func getImgDataSource() {
        let prams: NSDictionary = ["symbol":"member_icon"]
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
    }

}

extension MineVIPController: JPayApiManagerDelegate {
    func jPayApiManagerPayResult(success: Bool) {
        if success {
            var titleStr = "已开通钻石会员"
            if UserInfo.share.is_vip {
                if UserInfo.share.vip_from_index == 0 {
                    titleStr = "已开通星耀会员"
                } else if UserInfo.share.vip_from_index == 1 {
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

extension MineVIPController: UITableViewDelegate, UITableViewDataSource {
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
//            if !isBuy {
//                let cell = tabView.dequeueReusableCell(withIdentifier: "MineQuestionPayCell", for: indexPath) as! MineQuestionPayCell
//                cell.calView.getDataSource(bind1: vip_bind, bind2: "buy_question")
//                cell.calView.delegate = self
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
            cell.btn.setTitle(L$(vip_bind), for: .normal)
            cell.delegate = self
            return cell
        } else if bind == "vip_sum" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineVIPSumCell", for: indexPath) as! MineVIPSumCell
            cell.lab.text = RemindersManager.share.reminders(bind: "vip_sum")
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineVIPCell", for: indexPath) as! MineVIPCell
        cell.bind = bind
        if bind == "vip_consult" {
            cell.line.isHidden = false
        } else if bind == "vip_template" {
            cell.line.isHidden = true
        } else if bind == "vip_rank" || bind == "business_vip_rank" {
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
        }
        return RemindersManager.share.remiderHeight(bind: bind, font: kFontMS, width: kDeviceWidth - kLeftSpaceL - kLeftSpaceS - 40) + kLeftSpaceS * 2 + 30
    }
    
}

extension MineVIPController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
//        if UserInfo.share.vip_from_index == 2 {
//            PromptTool.promptText(L$("p_vip_max"), 1)
//            return
//        }
        OLAlertManager.share.buyVipShow(is_upgrade: true)
        OLAlertManager.share.buyVipView?.delegate = self
    }
}

extension MineVIPController: JBuyVipViewDelegate {
    func jBuyVipViewXieYiClick() {
        let urlStr = BASE_URL + api_posts_info + "?symbol=member"
        let vc = JSafariController.init(urlStr: urlStr, title: "会员协议")
        self.present(vc, animated: true, completion: nil)
    }
    
    func jBuyVipViewCompleteData() {
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "请先完善个人资料", message: "完善个人信息后，方可开通会员或进行问题咨询等其它业务", sure: "去完善", cancel: L$("cancel"), sureHandler: { (action) in
            let vc = MineProfileController()
            self.navigationController?.pushViewController(vc, animated: true)
        }, cancelHandler: nil)
    }
}

extension MineVIPController: JCalculateResetViewDelegate {
    func jcalculateResetViewBtnsClick(sender: UIButton, bind: String) {
        if bind == "open_vip" || bind == "upgrade_vip" {
            if UserInfo.share.vip_from_index == 2 {
                PromptTool.promptText(L$("p_vip_max"), 1)
                return
            }
            OLAlertManager.share.buyVipShow(is_upgrade: true)
        } else if bind == "buy_question" {
            sender.isUserInteractionEnabled = false
            HomeManager.share.serviceDetailWithBind(bind: "mine_question") { (mo) in
                guard let m = mo else {
                    return
                }
                let payM = JPayModel.init(service_type: .vip, id: "0", price: m.price, content: m.j_content)
                OLAlertManager.share.payShow(model: payM)
                OLAlertManager.share.payView?.delegate = self
                sender.isUserInteractionEnabled = true
            }
        }
    }
}

extension MineVIPController: JPayWayViewDelegate {
    func jPayWayViewCompleteData() {
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "请先完善个人资料", message: "完善个人信息后，方可开通会员或进行问题咨询等其它业务", sure: "去完善", cancel: L$("cancel"), sureHandler: { (action) in
            let vc = MineProfileController()
            self.navigationController?.pushViewController(vc, animated: true)
        }, cancelHandler: nil)
    }
}
