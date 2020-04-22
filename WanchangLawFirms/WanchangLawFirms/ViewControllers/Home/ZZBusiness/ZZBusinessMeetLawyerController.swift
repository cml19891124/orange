//
//  ZZBusinessMeetLawyerController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业律师约见
class ZZBusinessMeetLawyerController: BaseController {
    
    var lawyer: LawyerModel!
    var isTeachMeet: Bool = false
    var isPreview: Bool = false {
        didSet {
            self.config()
        }
    }
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.separatorStyle = .none
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(ConsultFlowCell.self, forCellReuseIdentifier: "ConsultFlowCell")
        tabView.register(ConsultMeetTypeCell.self, forCellReuseIdentifier: "ConsultMeetTypeCell")
        tabView.register(ConsultLawyerCell.self, forCellReuseIdentifier: "ConsultLawyerCell")
        tabView.register(PersonCustomMeetCell.self, forCellReuseIdentifier: "PersonCustomMeetCell")
        tabView.register(PersonCustomMeetPreviewCell.self, forCellReuseIdentifier: "PersonCustomMeetPreviewCell")
        tabView.register(ConsultReminderCell.self, forCellReuseIdentifier: "ConsultReminderCell")
        tabView.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        tabView.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    
    private var wordArr: [[String]] = [[String]]()
    private var order_sn: String = ""
    private var model: ProductModel = ProductModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JMeetManager.share.clear()
        self.config()
        self.listView.tabView.mj_header.beginRefreshing()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: noti_business_refresh), object: nil)
    }
    
    private func config() {
        if isTeachMeet {
            if isPreview {
                self.title = "培训详情"
                wordArr = [["flow","type"],["meet"],["ok"],["reminder"]]
            } else {
                self.title = "企业培训"
                wordArr = [["flow","type"],["meet"],["reminder","ok"]]
            }
        } else {
            if isPreview {
                self.title = "约见详情"
                wordArr = [["type","lawyer"],["meet"],["ok"],["reminder"]]
            } else {
                self.title = "律师约见"
                wordArr = [["type","lawyer"],["meet"],["reminder","ok"]]
            }
        }
        self.listView.tabView.reloadData()
    }
    
    @objc private func refresh() {
        self.listView.tabView.reloadData()
    }
    
}

extension ZZBusinessMeetLawyerController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getDataSource()
        }
    }
    
    private func getDataSource() {
        var id = "16"
        if isTeachMeet {
            id = "17"
        }
        HomeManager.share.serviceDetail(id: id) { (m) in
            if m != nil {
                self.model = m!
                self.listView.tabView.mj_header.endRefreshing()
                self.listView.tabView.reloadData()
                self.listView.tabView.bounces = false
            }
        }
    }
}

extension ZZBusinessMeetLawyerController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return wordArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = wordArr[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = wordArr[indexPath.section]
        let tempStr = arr[indexPath.row]
        if tempStr == "flow" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConsultFlowCell", for: indexPath) as! ConsultFlowCell
            cell.bind = "h_watch_flow"
            cell.type_bind = "h_meeting_consult"
            cell.content = model.content
            return cell
        } else if tempStr == "type" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConsultMeetTypeCell", for: indexPath) as! ConsultMeetTypeCell
            if isTeachMeet {
                cell.bind = "h_meeting_teach"
            } else {
                cell.bind = "h_meeting_lawyer"
            }
            cell.title = model.title
            cell.subTitle = model.sub_title
            return cell
        } else if tempStr == "lawyer" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConsultLawyerCell", for: indexPath) as! ConsultLawyerCell
            cell.lawyer = self.lawyer
            return cell
        } else if tempStr == "meet" {
            if isPreview {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCustomMeetPreviewCell", for: indexPath) as! PersonCustomMeetPreviewCell
                cell.isTeachMeet = isTeachMeet
                cell.model = JMeetManager.share.model
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCustomMeetCell", for: indexPath) as! PersonCustomMeetCell
            cell.isTeachMeet = isTeachMeet
            return cell
        } else if tempStr == "reminder" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConsultReminderCell", for: indexPath) as! ConsultReminderCell
            cell.titleStr = RemindersManager.share.remindTitle(bind: "h_warm_reminder")
//            let ns = model.desc as NSString
//            var resultStr = ""
//            if isTeachMeet {
//                resultStr = ns.replacingOccurrences(of: "****", with: "\(UserInfo.share.train_number)")
//            } else {
//                resultStr = ns.replacingOccurrences(of: "****", with: "\(UserInfo.share.meet_number)")
//            }
//            cell.reminder = resultStr
            cell.reminder = model.desc
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
        cell.delegate = self
        if isPreview {
            cell.btn.setTitle(L$("cancel_order"), for: .normal)
        } else {
            let str1 = L$("submit")
            var str2 = ""
            if isTeachMeet {
                str2 = "(剩余次数:\(UserInfo.share.train_number)次)"
            } else {
                str2 = "(剩余次数:\(UserInfo.share.meet_number)次)"
            }
            let totalStr = str1 + str2
            cell.btn.setTitle(totalStr, for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arr = wordArr[indexPath.section]
        let tempStr = arr[indexPath.row]
        if tempStr == "flow" {
            return 70
        } else if tempStr == "type" {
            return 90
        } else if tempStr == "lawyer" {
            return 90
        } else if tempStr == "meet" {
            if isTeachMeet {
                if isPreview {
                    return kCellHeight * 7 + 1
                }
                return 50 * 6 + 260 + kCellHeight * 5 + 1
            }
            if isPreview {
                return kCellHeight * 6 + 100 + 1
            }
            return 50 * 5 + 260 + kCellHeight * 3 + 80 * 3 + 1
        } else if tempStr == "reminder" {
            let h = model.desc.height(width: kDeviceWidth - kLeftSpaceS * 2, font: kFontMS)
            return h + kLeftSpaceS * 3 + 20
        }
        if isPreview {
            return 40
        }
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
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

extension ZZBusinessMeetLawyerController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        if isPreview {
            JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "确定取消？", message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
                let prams: NSDictionary = ["order_sn":self.order_sn]
                JMeetManager.share.companyInlineCancel(prams: prams) { (flag) in
                    if flag {
                        self.isPreview = false
                    }
                }
            }, cancelHandler: nil)
            return
        }
        if isTeachMeet {
            if JMeetManager.share.model.date.haveTextStr() != true {
                PromptTool.promptText("请选择预约时间", 1)
                return
            }
            if JMeetManager.share.model.address.haveTextStr() != true {
                PromptTool.promptText(L$("p_enter_teach_address"), 1)
                return
            }
            if JMeetManager.share.model.train_people.haveTextStr() != true {
                PromptTool.promptText("请填写培训对象", 1)
                return
            }
            if JMeetManager.share.model.train_content.haveTextStr() != true {
                PromptTool.promptText("请填写培训内容", 1)
                return
            }
            if JMeetManager.share.model.train_contact_mobile.haveTextStr() != true {
                PromptTool.promptText(L$("p_enter_teach_phone"), 1)
                return
            }
        } else {
            if JMeetManager.share.model.date.haveTextStr() != true {
                PromptTool.promptText("请选择预约时间", 1)
                return
            }
            if JMeetManager.share.model.meet_contact_name.haveTextStr() != true {
                PromptTool.promptText(L$("p_enter_name"), 1)
                return
            }
            if JMeetManager.share.model.meet_contact_mobile.haveTextStr() != true {
                PromptTool.promptText(L$("p_enter_contact_mobile"), 1)
                return
            }
            if JMeetManager.share.model.meet_people.haveTextStr() != true {
                PromptTool.promptText(L$("p_enter_people_count"), 1)
                return
            }
            if JMeetManager.share.model.reason.haveTextStr() != true {
                PromptTool.promptText(L$("p_enter_meet_reason"), 1)
                return
            }
        }
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "确定提交？", message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            self.sureCommit(sender: sender)
        }, cancelHandler: nil)
    }
    
    private func sureCommit(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        let mulPrams: NSMutableDictionary = NSMutableDictionary()
        if isTeachMeet {
            mulPrams["pid"] = "17"
            mulPrams["pay_type"] = "3"
            let m = JMeetManager.share.model
            mulPrams["problem"] = m.train_content
            let dict: NSDictionary = ["date":m.date,"time":m.time,"address":m.address,"train_people":m.train_people,"train_content":m.train_content,"train_contact_mobile":m.train_contact_mobile]
            mulPrams["attribute"] = dict.mj_JSONString()
        } else {
            mulPrams["pid"] = "16"
            mulPrams["pay_type"] = "3"
            let m = JMeetManager.share.model
            mulPrams["problem"] = m.reason
            let dict: NSDictionary = ["date":m.date,"time":m.time,"reason":m.reason,"meet_people":m.meet_people,"meet_contact_name":m.meet_contact_name,"meet_contact_mobile":m.meet_contact_mobile,"choose_lawyer":lawyer.id]
            mulPrams["attribute"] = dict.mj_JSONString()
        }
        
        JMeetManager.share.companyInlineLawyerCreate(isTeach: isTeachMeet, prams: mulPrams) { (flag, sn) in
            if flag {
                if sn != nil {
                    NotificationCenter.default.addObserver(self, selector: #selector(self.backClick), name: NSNotification.Name(rawValue: sn!), object: nil)
                    self.order_sn = sn!
                    self.isPreview = true
//                    UserInfo.share.conversationLoadedAdd(sn: self.order_sn)
                    self.commitSuccessAlert()
                }
            }
            sender.isUserInteractionEnabled = true
        }
    }
    
    @objc private func backClick() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func commitSuccessAlert() {
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "温馨提示", message: "您好，您的申请将会在1小时内出审核结果，请注意系统提示消息及短信。", sure: L$("sure"), cancel: nil, sureHandler: nil, cancelHandler: nil)
    }
}
