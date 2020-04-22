//
//  SetController.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 设置
class SetController: BaseController {
    
    private lazy var footV: JOKBtnView = {
        () -> JOKBtnView in
        let temp = JOKBtnView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 120))
        temp.delegate = self
        temp.btn.setTitle(L$("m_logout"), for: .normal)
        return temp
    }()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: kLeftSpaceS)
        temp.bounces = false
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = footV
        temp.register(SetNotiCell.self, forCellReuseIdentifier: "SetNotiCell")
        temp.register(MineCell.self, forCellReuseIdentifier: "MineCell")
        temp.register(SetVersionCell.self, forCellReuseIdentifier: "SetVersionCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    
    private lazy var dataArr: [[String]] = {
        () -> [[String]] in
        var temp: [[String]] = [[String]]()
        if UserInfo.share.is_business {
            let arr1 = ["m_noti_message","m_noti_sound","m_noti_vibrate"]
//            var arr2 = ["m_account_security","m_common_use"]
//            var arr3 = ["m_disclaimer","m_pay_help","m_invoice_description"]
            var arr2 = ["m_account_security","m_common_use"]
            var arr3 = ["m_disclaimer","m_invoice_description"]
            if !UserInfo.share.isMother {
                arr2 = ["m_common_use"]
//                arr3 = ["m_disclaimer","m_pay_help"]
                arr3 = ["m_disclaimer"]
            }
            let arr4 = ["mine_about_orange"]
            temp.append(arr1)
            temp.append(arr2)
            temp.append(arr3)
            temp.append(arr4)
        } else {
            let arr1 = ["m_noti_message","m_noti_sound","m_noti_vibrate"]
            let arr2 = ["m_common_use"]
            let arr3 = ["m_disclaimer","m_invoice_description"]
//            let arr4 = ["m_edit_pass","m_version"]
            let arr4 = ["m_edit_pass","mine_about_orange"]
            temp.append(arr1)
            temp.append(arr2)
            temp.append(arr3)
            temp.append(arr4)
        }
        return temp
    }()
    private lazy var noti_flag: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("set")
        noti_flag = UserInfo.getStandard(key: standard_noti_flag) ?? "111"
        self.tabView.reloadData()
    }

}

extension SetController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = dataArr[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = dataArr[indexPath.section]
        let bind = arr[indexPath.row]
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetNotiCell", for: indexPath) as! SetNotiCell
            cell.delegate = self
            cell.bind = bind
            let ns = noti_flag as NSString
            var temp = ""
            if indexPath.row == 0 {
                temp = ns.substring(with: NSRange.init(location: 0, length: 1))
            } else if indexPath.row == 1 {
                temp = ns.substring(with: NSRange.init(location: 1, length: 1))
            } else if indexPath.row == 2 {
                temp = ns.substring(with: NSRange.init(location: 2, length: 1))
            }
            if temp == "1" {
                cell.mswitch.isOn = true
            } else {
                cell.mswitch.isOn = false
            }
            return cell
        }
        if bind == "m_version" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetVersionCell", for: indexPath) as! SetVersionCell
            cell.bind = bind
            cell.trailLab.text = UserInfo.share.version
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineCell", for: indexPath) as! MineCell
        cell.bind = bind
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let arr = dataArr[indexPath.section]
        let bind = arr[indexPath.row]
        if bind == "m_edit_pass" {
            if UserInfo.share.model?.mobile.haveContentNet() == true {
                let vc = PasswordModifyController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = MineBindMobileController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if bind == "m_version" {
            self.appstore()
        } else if bind == "mine_about_orange" {
            let vc = MineBusinessAboutUsController()
            vc.currentNavigationBarAlpha = 0
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_orange_save" {
            let model = StorageModel()
            model.isDir = true
            model.name = L$(bind)
            model.path = ""
            let vc = StorageSpaceController.init(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "m_common_use" {
            let vc = CommonUseController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "m_account_security" {
            let vc = AccountSecurityController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "m_disclaimer" {
            let urlStr = BASE_URL + api_posts_info + "?symbol=" + "mianze"
            let vc = JURLController.init(urlStr: urlStr, bind: "m_disclaimer")
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "m_pay_help" {
            let urlStr = BASE_URL + api_posts_info + "?symbol=" + "zhifu"
            let vc = JURLController.init(urlStr: urlStr, bind: "m_pay_help")
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "m_invoice_description" {
            let vc = InvoiceManagerController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceL
    }

}

extension SetController {
    func appstore() {
        let urlStr = "https://itunes.apple.com/lookup?id=1318568813"
        HTTPManager.share.other_ask(isGet: true, url: urlStr, prams: NSDictionary(), needPrompt: true, successHandler: { (dict) in
            let array = dict["results"] as? NSArray
            let d1 = array?.lastObject as? NSDictionary
            let version = d1?["version"] as? String
            let desc = d1?["releaseNotes"] as? String
            if version == UserInfo.share.version {
                PromptTool.promptText(L$("p_current_latest_version"), 1)
            } else {
                JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: L$("p_check_new_version"), message: desc, sure: L$("p_go_to_update"), cancel: L$("cancel"), sureHandler: { (action) in
                    let url = URL.init(string: "https://itunes.apple.com/cn/app/id1318568813?mt=8")
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url!)
                    }
                }, cancelHandler: nil)
            }
        }) { (error) in
            
        }
    }
    
    func adhoc() {
        let url = URL.init(string: "https://fir.im/iorange")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}

extension SetController: SetNotiCellDelegate {
    func setNotiCellClick(mSwitch: UISwitch, bind: String) {
        if bind == "m_noti_message" {
            if mSwitch.isOn {
                UserInfo.setStandard(key: standard_noti_flag, text: "111")
                noti_flag = "111"
            } else {
                UserInfo.setStandard(key: standard_noti_flag, text: "000")
                noti_flag = "000"
            }
            self.tabView.reloadData()
        } else if bind == "m_noti_sound" {
            var ns = noti_flag as NSString
            var reStr: String = ""
            if mSwitch.isOn {
                reStr = "1"
                ns = ns.replacingCharacters(in: NSRange.init(location: 0, length: 1), with: "1") as NSString
            } else {
                reStr = "0"
            }
            let result = ns.replacingCharacters(in: NSRange.init(location: 1, length: 1), with: reStr)
            noti_flag = result
            UserInfo.setStandard(key: standard_noti_flag, text: result)
            self.tabView.reloadData()
        } else if bind == "m_noti_vibrate" {
            var ns = noti_flag as NSString
            var reStr: String = ""
            if mSwitch.isOn {
                reStr = "1"
                ns = ns.replacingCharacters(in: NSRange.init(location: 0, length: 1), with: "1") as NSString
            } else {
                reStr = "0"
            }
            let result = ns.replacingCharacters(in: NSRange.init(location: 2, length: 1), with: reStr)
            noti_flag = result
            UserInfo.setStandard(key: standard_noti_flag, text: result)
            self.tabView.reloadData()
        }
    }
}

extension SetController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        JAuthorizeManager.init(view: self.view).alertController(style: .actionSheet, titleStr: L$("p_sure_logout"), message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            UserInfo.share.netLogout()
        }, cancelHandler: nil)
    }
}
