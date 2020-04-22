//
//  OrderDetailController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/5/1.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class OrderDetailController: BaseController {
    
    var model: MessageModel!
    var status: String = "1"
    var isFromChat: Bool = false
    var co_username: String?
    var co_avatar: String?
    
    var cancelBlock = { () in
        
    }
    
    private var comment: String = ""
    private var score: Float = 5
    
    private lazy var headV: MessageDetailHeadView = {
        () -> MessageDetailHeadView in
        let temp = MessageDetailHeadView.init(model: model)
        temp.delegate = self
        return temp
    }()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.backgroundColor = kCellColor
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(MDHFileCell.self, forCellReuseIdentifier: "MDHFileCell")
        temp.register(MDOrangeBankCell.self, forCellReuseIdentifier: "MDOrangeBankCell")
        temp.register(JHeaderFooterLabView.self, forHeaderFooterViewReuseIdentifier: "JHeaderFooterLabView")
        
        temp.register(ConsultTypeCell.self, forCellReuseIdentifier: "ConsultTypeCell")
        temp.register(ConsultLawyerCell.self, forCellReuseIdentifier: "ConsultLawyerCell")
        temp.register(PersonCustomMeetPreviewCell.self, forCellReuseIdentifier: "PersonCustomMeetPreviewCell")
        temp.register(ConsultReminderCell.self, forCellReuseIdentifier: "ConsultReminderCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var commentBtnFootView: MessageDetailCommentBtnFootView = {
        () -> MessageDetailCommentBtnFootView in
        let temp = MessageDetailCommentBtnFootView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 80))
        temp.delegate = self
        return temp
    }()
    private lazy var commentOkFootView: MessageDetailCommentBtnFootView = {
        () -> MessageDetailCommentBtnFootView in
        let temp = MessageDetailCommentBtnFootView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 80))
        temp.delegate = self
        return temp
    }()
    private lazy var cancelOrderBtnView: JOKBtnView = {
        () -> JOKBtnView in
        let temp = JOKBtnView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 120))
        temp.delegate = self
        temp.btn.setTitle(L$("cancel_order"), for: .normal)
        return temp
    }()
    private lazy var cancelConfirmView: UIView = {
        () -> UIView in
        let temp = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 120))
        let cv = JCalculateResetView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth - kLeftSpaceL * 2, height: 40))
        cv.getDataSource(bind1: "cancel_order", bind2: "confirm_pay")
        cv.delegate = self
        temp.addSubview(cv)
        _ = cv.sd_layout()?.leftSpaceToView(temp, kLeftSpaceL)?.centerYEqualToView(temp)?.rightSpaceToView(temp, kLeftSpaceL)?.heightIs(40)
        return temp
    }()
    private var fileModerArr: [MessageFileModel] = [MessageFileModel]()
    
    private var wordArr: [[String]] = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("m_order_detail")
        NotificationCenter.default.addObserver(self, selector: #selector(getDataSource), name: NSNotification.Name(rawValue: model.order_sn), object: nil)
        self.getDataSource()
    }
    
    private func config() {
        if self.model.product_id == "16" {
            self.title = "约见详情"
            if self.model.order_status == "0" {
                wordArr = [["type","lawyer"],["meet"],["ok"],["reminder"]]
            } else if self.model.order_status == "4" {
                wordArr = [["type","lawyer"],["meet"],["remark"]]
            } else {
                wordArr = [["type","lawyer"],["meet"],["reminder"]]
            }
        } else if self.model.product_id == "17" {
            self.title = "培训详情"
            if self.model.order_status == "0" {
                wordArr = [["type"],["meet"],["ok"],["reminder"]]
            } else if self.model.order_status == "4" {
                wordArr = [["type"],["meet"],["remark"]]
            } else {
                wordArr = [["type"],["meet"],["reminder"]]
            }
        }
    }
    
    @objc private func getDataSource() {
        let prams: NSDictionary = ["order_sn":model.order_sn]
        HomeManager.share.orderView(prams: prams) { (m) in
            if m != nil {
                self.model = m!
                if self.model.product_id == "16" || self.model.product_id == "17" {
                    self.config()
                    if self.model.comment_at.count >= 10 {
                        let temp = MessageDetailCommentFootView.init(model: self.model)
                        temp.delegate = self
                        self.tabView.tableFooterView = temp
                        self.comment = self.model.comment_content
                        let f = Float(self.model.comment_star)
                        if f != nil {
                            self.score = f!
                        }
                    } else if self.model.order_status == "1" {
                        //                        if self.model.product_id == "16" {
                        //                            self.commentOkFootView.btn.setTitle(L$("continue_comminute"), for: .normal)
                        //                            self.tabView.tableFooterView = self.commentOkFootView
                        //                        }
                    } else if self.model.order_status == "2" {
                        self.commentOkFootView.btn.setTitle(L$("send_comment"), for: .normal)
                        self.tabView.tableFooterView = self.commentOkFootView
                    } else if self.model.order_status == "4" {
                        self.cancelOrderBtnView.btn.setTitle("预约已取消", for: .normal)
                        self.tabView.tableFooterView = self.cancelOrderBtnView
                    }
                    self.tabView.reloadData()
                    return
                }
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "chat_more"), style: .done, target: self, action: #selector(self.moreClick))
                self.tabView.tableHeaderView = self.headV
                if self.model.comment_at.count >= 10 {
                    let temp = MessageDetailCommentFootView.init(model: self.model)
                    temp.delegate = self
                    self.tabView.tableFooterView = temp
                    self.comment = self.model.comment_content
                    let f = Float(self.model.comment_star)
                    if f != nil {
                        self.score = f!
                    }
                    self.lastFiles()
                } else {
                    if self.model.order_status == "0" || self.model.order_status == "4" || self.model.order_status == "5" {
                        if self.model.order_status == "0" {
                            self.tabView.tableFooterView = self.cancelConfirmView
                        } else if self.model.order_status == "4" {
                            self.tabView.tableFooterView = self.cancelOrderBtnView
                            self.cancelOrderBtnView.btn.setTitle("订单已取消", for: .normal)
                        } else {
                            self.tabView.tableFooterView = self.cancelOrderBtnView
                            self.cancelOrderBtnView.btn.setTitle("订单已付款", for: .normal)
                        }
                        self.navigationItem.rightBarButtonItem = nil
                    } else {
                        if UserInfo.share.is_business && UserInfo.share.isMother {
                            if UserInfo.share.businessModel?.uid == self.model.uid {
                                self.tabView.tableFooterView = self.commentOkFootView
                                if self.model.order_status == "1" {
                                    self.commentOkFootView.btn.setTitle(L$("continue_comminute"), for: .normal)
                                } else if self.model.order_status == "2" {
                                    self.commentOkFootView.btn.setTitle(L$("send_comment"), for: .normal)
                                    self.lastFiles()
                                }
                            }
                        } else {
                            self.tabView.tableFooterView = self.commentOkFootView
                            if self.model.order_status == "1" {
                                self.commentOkFootView.btn.setTitle(L$("continue_comminute"), for: .normal)
                            } else if self.model.order_status == "2" {
                                self.commentOkFootView.btn.setTitle(L$("send_comment"), for: .normal)
                                self.lastFiles()
                            }
                        }
                    }
                    
                }
                self.tabView.reloadData()
            }
        }
    }
    
    private func lastFiles() {
        let prams: NSDictionary = ["order_sn": model.order_sn]
        MessageManager.share.chatFiles(prams: prams) { (arr) in
            if arr != nil && arr!.count > 0 {
                self.fileModerArr.removeAll()
                let m = arr!.first!
                let fileM = MessageFileModel()
                fileM.file_path = m.content
                fileM.file_name = m.attributeModel.msg_file_name
                fileM.file_size = m.attributeModel.msg_file_length
                self.fileModerArr.append(fileM)
                self.tabView.reloadData()
            }
        }
    }
    
}

extension OrderDetailController {
    @objc private func moreClick() {
        let alertCon = UIAlertController.init(title: "聊天内容选择", message: nil, preferredStyle: .actionSheet)
        let msgAction = UIAlertAction.init(title: "所有聊天消息", style: .default, handler: { (action) in
            self.chatRecordClick()
        })
        let fileAction = UIAlertAction.init(title: "所有聊天文件", style: .default, handler: { (action) in
            self.chatFileClick()
        })
        let cancelAction = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
        alertCon.addAction(msgAction)
        alertCon.addAction(fileAction)
        alertCon.addAction(cancelAction)
        self.present(alertCon, animated: true, completion: nil)
    }
    
    private func chatFileClick() {
        let prams: NSDictionary = ["order_sn": model.order_sn]
        let v = JPhotoPromptView.init(bind: "p_load_net_msg")
        MessageManager.share.chatMsg(prams: prams) { (flag) in
            v.removeFromSuperview()
            if flag {
                let vc = ChatRecordController()
                vc.onlyFile = true
                vc.model = self.model
                vc.co_username = self.co_username
                vc.co_avatar = self.co_avatar
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func chatRecordClick() {
        let prams: NSDictionary = ["order_sn": model.order_sn]
        let v = JPhotoPromptView.init(bind: "p_load_net_msg")
        MessageManager.share.chatMsg(prams: prams) { (flag) in
            v.removeFromSuperview()
            if flag {
                let vc = ChatRecordController()
                vc.model = self.model
                vc.co_username = self.co_username
                vc.co_avatar = self.co_avatar
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension OrderDetailController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        if sender.titleLabel?.text == L$("continue_comminute") {
            if isFromChat {
                self.navigationController?.popViewController(animated: true)
            } else {
                let vc = ChatController()
                vc.model = model
                vc.status = self.model.order_status
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if sender.titleLabel?.text == L$("send_comment") {
            OLAlertManager.share.commentShow(text: comment, score: score)
            OLAlertManager.share.commentView?.delegate = self
        } else if sender.titleLabel?.text == L$("edit_comment") {
            OLAlertManager.share.commentShow(text: comment, score: score)
            OLAlertManager.share.commentView?.delegate = self
        } else if sender.titleLabel?.text == L$("cancel_order") {
            JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "确定取消订单", message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
                let prams: NSDictionary = ["order_sn":self.model.order_sn]
                if self.model.product_id == "16" || self.model.product_id == "17" {
                    JMeetManager.share.companyInlineCancel(prams: prams, success: { (flag) in
                        if flag {
                            self.cancelBlock()
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                } else {
                    HomeManager.share.orderConfirmCancel(isCancel: true, prams: prams, success: { (flag) in
                        if flag {
                            self.cancelBlock()
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            }, cancelHandler: nil)
        }
    }
}

extension OrderDetailController: JCalculateResetViewDelegate {
    func jcalculateResetViewBtnsClick(sender: UIButton, bind: String) {
        var titleStr = "确定已支付订单？"
        var isCancel = false
        if bind == "cancel_order" {
            titleStr = "确定取消订单？"
            isCancel = true
        }
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: titleStr, message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            let prams: NSDictionary = ["order_sn":self.model.order_sn]
            HomeManager.share.orderConfirmCancel(isCancel: isCancel, prams: prams, success: { (flag) in
                if flag {
                    self.cancelBlock()
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }, cancelHandler: nil)
    }
}

extension OrderDetailController: OLCommentAlertViewDelegate {
    func olCommentAlertViewEnd(ok: Bool, text: String, score: Float) {
        self.comment = text
        self.score = score
        if ok {
            self.commit(text: text, score: "\(score)")
        }
    }
    
    private func commit(text: String, score: String) {
        let prams: NSDictionary = ["order_sn": model.order_sn,"comment_star":score,"comment_content":text]
        HomeManager.share.orderComment(prams: prams) { (flag) in
            if flag {
                self.getDataSource()
            }
        }
    }
}

extension OrderDetailController: MessageDetailHeadViewDelegate {
    func messageDetailHeadViewClick(arr: [JImgModel], selectModel: JImgModel) {
        let vc = JQuestionImgsController.init(dataArr: arr, currentModel: selectModel)
        vc.currentNavigationBarAlpha = 0
        vc.transitionType = .image
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension OrderDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if wordArr.count > 0 {
            return wordArr.count
        }
        if self.model.order_status == "0" {
            return 1
        }
        if self.fileModerArr.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if wordArr.count > 0 {
            let arr = wordArr[section]
            return arr.count
        }
        if self.model.order_status == "0" {
            return 1
        }
        return self.fileModerArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if wordArr.count > 0 {
            let arr = wordArr[indexPath.section]
            let tempStr = arr[indexPath.row]
            if tempStr == "type" {
                let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultTypeCell", for: indexPath) as! ConsultTypeCell
                cell.bind = "h_meeting_consult"
                return cell
            } else if tempStr == "lawyer" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ConsultLawyerCell", for: indexPath) as! ConsultLawyerCell
                cell.id = self.model.meetModel.choose_lawyer
                return cell
            } else if tempStr == "meet" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCustomMeetPreviewCell", for: indexPath) as! PersonCustomMeetPreviewCell
                if model.product_id == "17" {
                    cell.isTeachMeet = true
                } else {
                    cell.isTeachMeet = false
                }
                cell.model = self.model.meetModel
                return cell
            } else if tempStr == "reminder" {
                let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultReminderCell", for: indexPath) as! ConsultReminderCell
                cell.titleStr = RemindersManager.share.remindTitle(bind: "h_warm_reminder")
                if self.model.product_id == "17" {
                    cell.reminder = RemindersManager.share.reminders(bind: "h_meeting_teach")
                } else {
                    cell.reminder = RemindersManager.share.reminders(bind: "h_meeting_lawyer")
                }
                return cell
            } else if tempStr == "remark" {
                let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultReminderCell", for: indexPath) as! ConsultReminderCell
                cell.titleStr = "取消原因"
                cell.reminder = self.model.meetModel.remark
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
            cell.delegate = self
            cell.btn.setTitle(L$("cancel_order"), for: .normal)
            return cell
        }
        
        if self.model.order_status == "0" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MDOrangeBankCell", for: indexPath) as! MDOrangeBankCell
            cell.bankView.pay_code = self.model.pay_code
            cell.bankView.pay_tips = self.model.pay_tips
            return cell
        }
        let m = self.fileModerArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDHFileCell", for: indexPath) as! MDHFileCell
        cell.model = m
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if wordArr.count > 0 {
            let arr = wordArr[indexPath.section]
            let tempStr = arr[indexPath.row]
            if tempStr == "type" {
                return 90
            } else if tempStr == "lawyer" {
                return 90
            } else if tempStr == "meet" {
                if model.product_id == "17" {
                    return kCellHeight * 7
                }
                return kCellHeight * 6 + 100
            } else if tempStr == "reminder" {
                var h: CGFloat = 0
                if self.model.product_id == "17" {
                    h = RemindersManager.share.remiderHeight(bind: "h_meeting_teach", font: kFontMS, width: kDeviceWidth - kLeftSpaceS * 2)
                } else {
                    h = RemindersManager.share.remiderHeight(bind: "h_meeting_lawyer", font: kFontMS, width: kDeviceWidth - kLeftSpaceS * 2)
                }
                return h + kLeftSpaceS * 3 + 20
            } else if tempStr == "remark" {
                let str = self.model.meetModel.remark
                let h = str.height(width: kDeviceWidth - kLeftSpaceS * 2, font: kFontMS)
                return h + kLeftSpaceS * 3 + 20
            }
            return 40
        }
        
        if self.model.order_status == "0" {
            return 400
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if wordArr.count > 0 {
            let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
            return vv
        }
        let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JHeaderFooterLabView") as! JHeaderFooterLabView
        if self.model.order_status == "0" {
            return v
        }
        v.lab.text = "定制文书(仅供参考，点击右上角查看所有聊天文件)"
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if wordArr.count > 0 {
            return kCellSpaceL
        }
        if self.model.order_status == "0" {
            return kCellSpaceS
        }
        return 40
    }
}
