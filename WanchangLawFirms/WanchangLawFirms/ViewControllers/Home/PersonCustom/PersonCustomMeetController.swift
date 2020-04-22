//
//  PersonCustomMeetController.swift
//  OLegal
//
//  Created by lh on 2018/11/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 个人订制 - 会面咨询
class PersonCustomMeetController: BaseController {
    
    var isPreview: Bool = false
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .grouped, space: 0)
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(ConsultFlowCell.self, forCellReuseIdentifier: "ConsultFlowCell")
        temp.register(ConsultTypeCell.self, forCellReuseIdentifier: "ConsultTypeCell")
        temp.register(PersonCustomMeetCell.self, forCellReuseIdentifier: "PersonCustomMeetCell")
        temp.register(PersonCustomMeetPreviewCell.self, forCellReuseIdentifier: "PersonCustomMeetPreviewCell")
        temp.register(ConsultReminderCell.self, forCellReuseIdentifier: "ConsultReminderCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    
    private var wordArr: [[String]] {
        get {
            if isPreview {
                return [["flow","type"],["meet"],["ok"],["reminder"]]
            }
            return [["flow","type"],["meet"],["reminder","ok"]]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("h_meeting_consult")
        self.tabView.reloadData()
    }
    
}

extension PersonCustomMeetController: UITableViewDelegate, UITableViewDataSource {
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
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultFlowCell", for: indexPath) as! ConsultFlowCell
            cell.bind = "h_watch_flow"
            cell.type_bind = "h_meeting_consult"
            return cell
        } else if tempStr == "type" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultTypeCell", for: indexPath) as! ConsultTypeCell
            cell.bind = "h_meeting_consult"
            return cell
        } else if tempStr == "meet" {
            if isPreview {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCustomMeetPreviewCell", for: indexPath) as! PersonCustomMeetPreviewCell
                return cell
            }
            let cell = tabView.dequeueReusableCell(withIdentifier: "PersonCustomMeetCell", for: indexPath) as! PersonCustomMeetCell
            return cell
        } else if tempStr == "reminder" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultReminderCell", for: indexPath) as! ConsultReminderCell
            cell.titleStr = RemindersManager.share.remindTitle(bind: "h_warm_reminder")
            cell.reminder = RemindersManager.share.reminders(bind: "h_meeting_consult")
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
        cell.delegate = self
        if isPreview {
            cell.btn.setTitle(L$("h_meet_data_modify"), for: .normal)
        } else {
            cell.btn.setTitle(L$("submit"), for: .normal)
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
        } else if tempStr == "meet" {
            if isPreview {
                return kCellHeight * 7 + 50 + 1
            }
            return 50 * 5 + 260 + kCellHeight * 3 + 80 * 3 + 1
        } else if tempStr == "reminder" {
            let h = RemindersManager.share.remiderHeight(bind: "h_meeting_consult", font: kFontMS, width: kDeviceWidth - kLeftSpaceS * 2)
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

extension PersonCustomMeetController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        isPreview = !isPreview
        self.tabView.reloadData()
    }
}
