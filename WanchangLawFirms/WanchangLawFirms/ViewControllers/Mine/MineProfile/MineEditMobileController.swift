//
//  MineEditMobileController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/3.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 修改手机号
class MineEditMobileController: BaseController {
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(MobileTFCell.self, forCellReuseIdentifier: "MobileTFCell")
        temp.register(CodeTFCell.self, forCellReuseIdentifier: "CodeTFCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        self.view.addSubview(temp)
        return temp
    }()
    
    private var sms_code: String?
    private var code_new: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("m_edit_mobile")
        self.tabView.reloadData()
    }
    
}

extension MineEditMobileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MobileTFCell", for: indexPath) as! MobileTFCell
            cell.colorSetup(placeholderColor: kPlaceholderColor, lineColor: kPlaceholderColor)
            cell.placeholder = L$("p_enter_mobile")
            cell.tf.text = UserInfo.share.model?.mobile
            cell.leftBtn.setImage(UIImage.init(named: "forget_mobile"), for: .normal)
            cell.tf.isUserInteractionEnabled = false
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CodeTFCell", for: indexPath) as! CodeTFCell
            cell.logined = true
            cell.isEmail = false
            cell.tf.delegate = self
            cell.colorSetup(placeholderColor: kPlaceholderColor, lineColor: kPlaceholderColor)
            cell.placeholder = L$("p_enter_code")
            cell.leftBtn.setImage(UIImage.init(named: "forget_code"), for: .normal)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MobileTFCell", for: indexPath) as! MobileTFCell
            cell.isLR = false
            cell.colorSetup(placeholderColor: kPlaceholderColor, lineColor: kPlaceholderColor)
            cell.placeholder = L$("p_enter_new_mobile")
            cell.leftBtn.setImage(UIImage.init(named: "forget_mobile"), for: .normal)
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CodeTFCell", for: indexPath) as! CodeTFCell
            cell.logined = false
            cell.isLogin = false
            cell.isEmail = false
            cell.tf.delegate = self
            cell.colorSetup(placeholderColor: kPlaceholderColor, lineColor: kPlaceholderColor)
            cell.placeholder = L$("p_enter_new_code")
            cell.leftBtn.setImage(UIImage.init(named: "forget_code"), for: .normal)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
        cell.delegate = self
        cell.btn.setTitle(L$("finish"), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 200
        }
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

extension MineEditMobileController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == L$("p_enter_code") {
            sms_code = textField.text
        } else if textField.placeholder == L$("p_enter_new_code") {
            code_new = textField.text
        }
    }
}

extension MineEditMobileController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        self.view.endEditing(true)
        if sms_code?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_code"), 1)
            return
        }
        if UserInfo.share.change_mobile?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_new_mobile"), 1)
            return
        }
        if code_new?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_new_code"), 1)
            return
        }
        sender.isUserInteractionEnabled = false
        let prams: NSDictionary = ["old_code":sms_code!,"mobile":UserInfo.share.change_mobile!,"code":code_new!]
        UserInfo.share.netMobile(prams: prams) { (flag) in
            if flag {
                UserInfo.setUserMobile(text: UserInfo.share.change_mobile)
                UserInfo.share.netUserInfo()
                JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "手机号修改成功", message: "手机号修改成功，可用新手机号进行登录。", sure: L$("sure"), cancel: nil, sureHandler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }, cancelHandler: nil)
            } else {
                sender.isUserInteractionEnabled = true
            }
        }
    }
}
