//
//  MineQuestionController.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我的问题
class MineQuestionController: BaseController {
    
    var isBuy: Bool = false
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .grouped, space: 0)
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(MineQuestionCountCell.self, forCellReuseIdentifier: "MineQuestionCountCell")
        temp.register(MineQuestionPriceCell.self, forCellReuseIdentifier: "MineQuestionPriceCell")
        temp.register(ConsultReminderCell.self, forCellReuseIdentifier: "ConsultReminderCell")
        temp.register(MineQuestionPayCell.self, forCellReuseIdentifier: "MineQuestionPayCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    
    private let bindArr: [[String]] = [["mine_question_have","mine_question_price"],["m_question_instruction","pay"]]
    private var model: ProductModel?
    
    private var vip_bind: String {
        get {
            if UserInfo.share.is_vip {
                return "upgrade_vip"
            }
            return "open_vip"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("mine_question")
        self.tabView.reloadData()
        self.getDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: noti_user_model_refresh), object: nil)
        JPayApiManager.share.delegate = self
    }
    
    private func getDataSource() {
        HomeManager.share.serviceDetailWithBind(bind: "mine_question") { (model) in
            self.model = model
            self.reload()
        }
    }
    
    @objc private func reload() {
        self.tabView.reloadData()
    }

}

extension MineQuestionController: JPayApiManagerDelegate {
    func jPayApiManagerPayResult(success: Bool) {
        if success {
            PromptTool.promptText(L$("p_pay_success"), 1)
            UserInfo.share.order_sn = nil
            UserInfo.share.netUserInfo()
        }
    }
}

extension MineQuestionController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = bindArr[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = bindArr[indexPath.section]
        let tempStr = arr[indexPath.row]
        if tempStr == "mine_question_have" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "MineQuestionCountCell", for: indexPath) as! MineQuestionCountCell
            cell.titleLab.text = L$("mine_question_have")
            cell.countLab.text = "\(UserInfo.share.quality_count)"
            return cell
        } else if tempStr == "mine_question_price" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "MineQuestionPriceCell", for: indexPath) as! MineQuestionPriceCell
            cell.titleLab.text = L$("mine_question_price")
            if model != nil {
                cell.priceLab.text = "¥" + model!.price
            }
            return cell
        } else if tempStr == "m_question_instruction" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultReminderCell", for: indexPath) as! ConsultReminderCell
            cell.titleStr = RemindersManager.share.remindTitle(bind: "m_question_instruction")
            cell.reminder = RemindersManager.share.reminders(bind: "mine_question")
            return cell
        }
        let cell = tabView.dequeueReusableCell(withIdentifier: "MineQuestionPayCell", for: indexPath) as! MineQuestionPayCell
        cell.calView.getDataSource(bind1: vip_bind, bind2: "buy_one")
        cell.calView.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arr = bindArr[indexPath.section]
        let tempStr = arr[indexPath.row]
        if tempStr == "m_question_instruction" {
            let h = RemindersManager.share.remiderHeight(bind: "mine_question", font: kFontMS, width: kDeviceWidth - kLeftSpaceS * 2)
            return h + kLeftSpaceS * 3 + 20
        } else if tempStr == "pay" {
            return 100
        }
        return kCellHeight
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

extension MineQuestionController: JCalculateResetViewDelegate {
    func jcalculateResetViewBtnsClick(sender: UIButton, bind: String) {
        if bind == "open_vip" || bind == "upgrade_vip" {
//            if UserInfo.share.vip_from_index == 2 {
//                PromptTool.promptText(L$("p_vip_max"), 1)
//                return
//            }
            OLAlertManager.share.buyVipShow(is_upgrade: true)
            OLAlertManager.share.buyVipView?.delegate = self
        } else if bind == "buy_one" {
            guard let m = model else {
                self.getDataSource()
                return
            }
            let payM = JPayModel.init(service_type: .vip, id: "0", price: m.price, content: m.j_content)
            OLAlertManager.share.payShow(model: payM)
            OLAlertManager.share.payView?.delegate = self
        }
    }
}

extension MineQuestionController: JBuyVipViewDelegate {
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

extension MineQuestionController: JPayWayViewDelegate {
    func jPayWayViewCompleteData() {
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "请先完善个人资料", message: "完善个人信息后，方可开通会员或进行问题咨询等其它业务", sure: "去完善", cancel: L$("cancel"), sureHandler: { (action) in
            let vc = MineProfileController()
            self.navigationController?.pushViewController(vc, animated: true)
        }, cancelHandler: nil)
    }
}
