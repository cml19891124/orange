//
//  ForgetPasswordController.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 找回密码界面
class ForgetPasswordController: BaseController {
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(MobileTFCell.self, forCellReuseIdentifier: "MobileTFCell")
        temp.register(CodeTFCell.self, forCellReuseIdentifier: "CodeTFCell")
        temp.register(PassTFCell.self, forCellReuseIdentifier: "PassTFCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        self.view.addSubview(temp)
        return temp
    }()
    
    private var sms_code: String?
    private var pass1: String?
    private var pass2: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("lr_forget_pass")
        self.tabView.reloadData()
    }

}

extension ForgetPasswordController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MobileTFCell", for: indexPath) as! MobileTFCell
            cell.colorSetup(placeholderColor: kPlaceholderColor, lineColor: kPlaceholderColor)
            cell.placeholder = L$("p_enter_mobile")
            cell.tf.text = UserInfo.share.mobile
            cell.leftBtn.setImage(UIImage.init(named: "forget_mobile"), for: .normal)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CodeTFCell", for: indexPath) as! CodeTFCell
            cell.logined = false
            cell.isLogin = true
            cell.isEmail = false
            cell.tf.delegate = self
            cell.colorSetup(placeholderColor: kPlaceholderColor, lineColor: kPlaceholderColor)
            cell.placeholder = L$("p_enter_code")
            cell.leftBtn.setImage(UIImage.init(named: "forget_code"), for: .normal)
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
            cell.delegate = self
            cell.btn.setTitle(L$("finish"), for: .normal)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassTFCell", for: indexPath) as! PassTFCell
        cell.tf.delegate = self
        cell.colorSetup(placeholderColor: kPlaceholderColor, lineColor: kPlaceholderColor)
        cell.leftBtn.setImage(UIImage.init(named: "forget_pass"), for: .normal)
        if indexPath.row == 2 {
            cell.placeholder = L$("p_enter_pass_new")
        } else {
            cell.placeholder = L$("p_enter_pass_new_again")
        }
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

extension ForgetPasswordController: UITextFieldDelegate {
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
        } else if textField.placeholder == L$("p_enter_pass_new") {
            pass1 = textField.text
        } else if textField.placeholder == L$("p_enter_pass_new_again") {
            pass2 = textField.text
        }
    }
}

/// 重置密码提交
extension ForgetPasswordController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        self.view.endEditing(true)
        if UserInfo.share.mobile?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_mobile"), 1)
            return
        }
        if sms_code?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_code"), 1)
            return
        }
        if pass1?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_pass_new"), 1)
            return
        }
        if pass1!.count < 8 || pass1!.count > 20 {
            PromptTool.promptText(L$("p_pass_limit"), 1)
            return
        }
        if pass2?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_pass_new_again"), 1)
            return
        }
        if pass1 != pass2 {
            PromptTool.promptText(L$("p_pass_not_equal"), 1)
            return
        }
        sender.isUserInteractionEnabled = false
        let prams: NSDictionary = ["mobile":UserInfo.share.mobile!,"code":sms_code!,"password":pass1!]
        LRManager.share.pubReset(prams: prams) { (flag) in
            if flag {
                JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "密码找回", message: "密码已重置成功，请用新密码进行登录", sure: "去登录", cancel: nil, sureHandler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }, cancelHandler: nil)
            } else {
                sender.isUserInteractionEnabled = true
            }
        }
    }
}
