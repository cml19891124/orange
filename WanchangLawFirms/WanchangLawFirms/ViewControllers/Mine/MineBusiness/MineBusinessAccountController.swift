//
//  MineBusinessAccountController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/10.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业子账号
class MineBusinessAccountController: BaseController {

    private var modelArr: [UserModel] = [UserModel]()
    private var h1: CGFloat = 0
    private lazy var imgView: JImgViewSelfAdapt = {
        let temp = JImgViewSelfAdapt.init(imgName: "business_account_desc", wid: kDeviceWidth)
        temp.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: temp.end_height)
        h1 = temp.end_height
        temp.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        temp.addGestureRecognizer(tap)
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight + h1, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - h1), style: .plain, space: kLeftSpaceS)
        temp.separatorColor = kLineGrayColor
        temp.bounces = false
        temp.delegate = self
        temp.dataSource = self
        temp.register(MBAccountCell.self, forCellReuseIdentifier: "MBAccountCell")
        temp.register(JHeaderFooterLabView.self, forHeaderFooterViewReuseIdentifier: "JHeaderFooterLabView")
        self.view.addSubview(temp)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = L$("m_business_account_manage")
        self.title = L$("mine_business")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "add_white"), style: .done, target: self, action: #selector(addClick))
        self.imgView.isHidden = false
        self.refresh()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: noti_business_account_refresh), object: nil)
    }
    
    @objc private func tapClick() {
        let urlStr = BASE_URL + api_posts_info + "?symbol=qy_child"
//        let vc = JSafariController.init(urlStr: urlStr, title: "母子账号介绍")
//        self.present(vc, animated: true, completion: nil)
        let vc = JURLController.init(urlStr: urlStr, bind: "母子账号介绍")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refresh() {
        if UserInfo.share.businessAccountArr.count > 0 {
            self.modelArr.removeAll()
            for m in UserInfo.share.businessAccountArr {
                if m.uid == UserInfo.share.businessModel?.uid {
                    self.modelArr.append(m)
                    break
                }
            }
            for m in UserInfo.share.businessAccountArr {
                if m.uid != UserInfo.share.businessModel?.uid {
                    self.modelArr.append(m)
                }
            }
            self.tabView.reloadData()
        }
    }
    
    @objc private func addClick() {
        if !UserInfo.share.is_vip {
            JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "温馨提示", message: "需要先开通会员才能创建子账号哦", sure: "开通会员", cancel: "取消", sureHandler: { (action) in
                let vc = MineBusinessVIPController()
                vc.isBuy = true
                self.navigationController?.pushViewController(vc, animated: true)
            }, cancelHandler: nil)
            return
        }
        let alertCon = UIAlertController.init(title: L$("m_add_branch_account"), message: nil, preferredStyle: .alert)
        let actionSure = UIAlertAction.init(title: L$("sure"), style: .default) { (action) in
            let nameTF: UITextField = alertCon.textFields![0]
            let passTF: UITextField = alertCon.textFields![1]
            self.commit(username: nameTF.text, password: passTF.text)
        }
        let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
        alertCon.addTextField { (tf) in
            tf.placeholder = L$("p_username_limit")
            tf.keyboardType = .asciiCapable
            tf.delegate = self
            tf.isSecureTextEntry = true
            tf.isSecureTextEntry = false
        }
        alertCon.addTextField { (tf) in
            tf.placeholder = L$("p_pass_limit")
            tf.keyboardType = .asciiCapable
            tf.isSecureTextEntry = true
            tf.isSecureTextEntry = false
        }
        alertCon.addAction(actionSure)
        alertCon.addAction(actionCancel)
        self.present(alertCon, animated: true, completion: nil)
    }
    
    private func commit(username: String?, password: String?) {
        if username?.haveTextStr() != true {
            return
        }
        if password?.haveTextStr() != true {
            return
        }
        if username!.count < 6 || username!.count > 20 {
            PromptTool.promptText(L$("p_username_limit"), 1)
            return
        }
        if password!.count < 8 || password!.count > 20 {
            PromptTool.promptText(L$("p_pass_limit"), 1)
            return
        }
        let prams: NSDictionary = ["username":username!,"password":password!]
        UserInfo.share.companyAccountAdd(prams: prams) { (flag) in
            if flag {
                UserInfo.share.companyAccountList(success: { (flag) in
                    
                })
            }
        }
    }

}

extension MineBusinessAccountController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let username = textField.text else {
            return
        }
        if username.count == 0 {
            return
        }
        let prams: NSDictionary = ["key":"co_username","val":username]
        UserInfo.share.pubCheckUser(prams: prams) { (flag) in
            if flag {
                PromptTool.promptText("账号名“\(username)”已存在", 1)
            }
        }
    }
}

extension MineBusinessAccountController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if modelArr.count == 1 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return modelArr.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MBAccountCell", for: indexPath) as! MBAccountCell
        if indexPath.section == 0 {
           let model = modelArr[0]
            cell.model = model
        } else {
           let model = modelArr[indexPath.row + 1]
            cell.model = model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let model = modelArr[0]
            let vc = MinuBusinessAccountDetailController()
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let model = modelArr[indexPath.row + 1]
        let vc = MinuBusinessAccountDetailController()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JHeaderFooterLabView") as! JHeaderFooterLabView
        if section == 0 {
            vv.lab.text = "母账号"
        } else {
            vv.lab.text = "子账号"
        }
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (UserInfo.share.businessModel?.vip == "0" || UserInfo.share.businessModel?.vip == "1" || UserInfo.share.businessModel?.vip == "2") && modelArr.count < 2 {
            if section == 0 {
                return 30
            }
        } else if (UserInfo.share.businessModel?.vip == "3" && modelArr.count < 3) {
            if section == 0 {
                if modelArr.count == 1 {
                    return 30
                }
            }
            if section == 1 {
                return 30
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JHeaderFooterLabView") as! JHeaderFooterLabView
        if (UserInfo.share.businessModel?.vip == "0" || UserInfo.share.businessModel?.vip == "1" || UserInfo.share.businessModel?.vip == "2") && modelArr.count < 2 {
            vv.lab.text = "点击右上角添加子账号"
        } else if (UserInfo.share.businessModel?.vip == "3" && modelArr.count < 3) {
            if section == 0 {
                if modelArr.count == 1 {
                    vv.lab.text = "点击右上角添加子账号"
                } else {
                    vv.lab.text = ""
                }
            } else if section == 1 {
                vv.lab.text = "点击右上角添加子账号"
            }
        } else {
            vv.lab.text = ""
        }
        return vv
    }
}
