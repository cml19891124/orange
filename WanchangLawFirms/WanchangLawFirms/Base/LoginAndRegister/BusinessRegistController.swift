//
//  BusinessRegistController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/14.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业注册界面
class BusinessRegistController: BaseController {
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .grouped, space: 0)
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(LoginTFBaseCell.self, forCellReuseIdentifier: "LoginTFBaseCell")
        temp.register(CodeTFCell.self, forCellReuseIdentifier: "CodeTFCell")
        temp.register(MobileTFCell.self, forCellReuseIdentifier: "MobileTFCell")
        temp.register(PassTFCell.self, forCellReuseIdentifier: "PassTFCell")
        temp.register(PhotoTFCell.self, forCellReuseIdentifier: "PhotoTFCell")
        temp.register(AccountUserNameTFCell.self, forCellReuseIdentifier: "AccountUserNameTFCell")
        temp.register(AccountEmailTFCell.self, forCellReuseIdentifier: "AccountEmailTFCell")
        temp.register(BusinessRegistFooterView.self, forHeaderFooterViewReuseIdentifier: "BusinessRegistFooterView")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    //m_business_name_with_login   m_business_username_with_login
    private let bindArr: [String] = ["m_business_name_with_login","m_business_username_with_login","m_business_password","m_business_mobile","m_business_mobile_code","m_business_email","m_business_email_code","m_business_code","m_business_photo","m_business_legal","m_business_id_card","m_business_contact","m_business_recommender"]
    
    
    private var name: String = ""
    private var sn: String = ""
    private var owner_name: String = ""
    private var owner_sn: String = ""
    private var contact_name: String = ""
    private var code: String = ""
    private var email_code: String = ""
    private var email: String = ""
    private var username: String = ""
    private var password: String = ""
    private var remotePath: String = ""
    private var recommender: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "企业注册"
        self.tabView.reloadData()
        JKeyboardNotiManager.share.delegate = self
    }
    
}

extension BusinessRegistController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = self.bindArr[indexPath.row]
        if bind == "m_business_photo" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTFCell", for: indexPath) as! PhotoTFCell
            cell.delegate = self
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$(bind)
            cell.leftBtn.setImage(UIImage.init(named: bind + "_lr"), for: .normal)
            if remotePath.haveTextStr() {
                cell.titleStr(text: L$("uploaded"))
            } else {
                cell.titleStr(text: L$("upload_picture"))
            }
            return cell
        } else if bind == "m_business_password" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PassTFCell", for: indexPath) as! PassTFCell
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$(bind)
            cell.leftBtn.setImage(UIImage.init(named: bind + "_lr"), for: .normal)
            cell.tf.delegate = self
            return cell
        } else if bind == "m_business_mobile" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MobileTFCell", for: indexPath) as! MobileTFCell
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$("p_enter_mobile")
            cell.tf.text = UserInfo.share.mobile
            cell.leftBtn.setImage(UIImage.init(named: bind + "_lr"), for: .normal)
            return cell
        } else if bind == "m_business_mobile_code" || bind == "m_business_email_code" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CodeTFCell", for: indexPath) as! CodeTFCell
            cell.logined = false
            cell.isLogin = false
            cell.tf.delegate = self
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$(bind)
            cell.leftBtn.setImage(UIImage.init(named: bind + "_lr"), for: .normal)
            if bind == "m_business_mobile_code" {
                cell.isEmail = false
                cell.tf.text = code
            } else if bind == "m_business_email_code" {
                cell.isEmail = true
                cell.tf.text = email_code
            }
            return cell
        } else if bind == "m_business_username_with_login" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountUserNameTFCell", for: indexPath) as! AccountUserNameTFCell
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$(bind)
            cell.leftBtn.setImage(UIImage.init(named: bind + "_lr"), for: .normal)
            cell.tf.delegate = self
            cell.doneView.bind = "p_business_username_noti"
            cell.tf.text = username
            return cell
        } else if bind == "m_business_email" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountEmailTFCell", for: indexPath) as! AccountEmailTFCell
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$(bind)
            cell.leftBtn.setImage(UIImage.init(named: bind + "_lr"), for: .normal)
            cell.tf.delegate = self
            cell.doneView.bind = ""
            cell.tf.text = email
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginTFBaseCell", for: indexPath) as! LoginTFBaseCell
        cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
        cell.placeholder = L$(bind)
        cell.leftBtn.setImage(UIImage.init(named: bind + "_lr"), for: .normal)
        cell.tf.delegate = self
        if bind == "m_business_name_with_login" {
            cell.tf.text = name
        } else if bind == "m_business_code" {
            cell.tf.text = sn
        } else if bind == "m_business_legal" {
            cell.tf.text = owner_name
        } else if bind == "m_business_id_card" {
            cell.tf.text = owner_sn
        } else if bind == "m_business_contact" {
            cell.tf.text = contact_name
        } else if bind == "m_business_recommender" {
            cell.tf.text = recommender
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BusinessRegistFooterView") as! BusinessRegistFooterView
        vv.delegate = self
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kCellHeight * 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension BusinessRegistController: PhotoTFCellDelegate {
    func photoTFCellClick() {
        OLAlertManager.share.profilePickerShow(isAvatar: true)
        OLAlertManager.share.profilePickerView?.delegate = self
    }
}

extension BusinessRegistController: OLPickerViewDelegate {
    func olpickerViewClick(bind: String) {
        if bind == "camera" {
            JAuthorizeManager.init(view: self.view).cameraAuthorization {
                let picker = UIImagePickerController.init(sourceType: .camera, mediaType: 1, allowsEditing: false)
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        } else if bind == "album" {
            JAuthorizeManager.init(view: self.view).photoLibraryAuthorization {
                let picker = UIImagePickerController.init(sourceType: .photoLibrary, mediaType: 1, allowsEditing: false)
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
}

extension BusinessRegistController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let result = picker.resultImage(info: info, isOriginal: true) else {
                return
            }
            OSSManager.initWithShare().uploadImage(result, isOriginal: true, objKey: "uploads/business/", progress: { (progress) in
                
            }) { (endPath) in
                self.remotePath = endPath
                self.tabView.reloadRows(at: [IndexPath.init(row: 8, section: 0)], with: UITableView.RowAnimation.fade)
            }
        }
    }
}

extension BusinessRegistController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        if string == "" {
            return true
        }
        if textField.placeholder == L$("m_business_id_card") {
            if textField.text != nil && textField.text!.count >= 18 {
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == L$("m_business_name_with_login") {
            name = textField.text ?? ""
        } else if textField.placeholder == L$("m_business_code") {
            sn = textField.text ?? ""
        } else if textField.placeholder == L$("m_business_legal") {
            owner_name = textField.text ?? ""
        } else if textField.placeholder == L$("m_business_id_card") {
            owner_sn = textField.text ?? ""
        } else if textField.placeholder == L$("m_business_contact") {
            contact_name = textField.text ?? ""
        } else if textField.placeholder == L$("m_business_mobile_code") {
            code = textField.text ?? ""
        } else if textField.placeholder == L$("m_business_email") {
            UserInfo.share.business_email = textField.text ?? ""
            email = textField.text ?? ""
            self.checkEmail()
        } else if textField.placeholder == L$("m_business_username_with_login") {
            username = textField.text ?? ""
            self.checkUsername()
        } else if textField.placeholder == L$("m_business_password") {
            password = textField.text ?? ""
        } else if textField.placeholder == L$("m_business_email_code") {
            email_code = textField.text ?? ""
        } else if textField.placeholder == L$("m_business_recommender") {
            recommender = textField.text ?? ""
        }
    }
    
    private func checkUsername() {
        if username.haveTextStr() == true {
            if !BaseUtil.checkAccountRegularValid(username: username) {
                PromptTool.promptText("账号名不能有特殊符号", 1)
                return
            }
            let prams: NSDictionary = ["key":"co_username","val":username]
            UserInfo.share.pubCheckUser(prams: prams) { (flag) in
                if flag {
                    PromptTool.promptText("账号名已存在", 1)
                }
            }
        }
    }
    
    private func checkEmail() {
        if email.haveTextStr() == true {
            let prams: NSDictionary = ["key":"co_email","val":email]
            UserInfo.share.pubCheckUser(prams: prams) { (flag) in
                if flag {
                    PromptTool.promptText("邮箱已存在", 1)
                }
            }
        }
    }
}

extension BusinessRegistController: JKeyboardNotiManagerDelegate {
    func jkeyboardHeightChange(kH: CGFloat, duration: Double) {
        self.tabView.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kH)
    }
    
    func jkeyboardWillHide(kH: CGFloat, duration: Double) {
        self.tabView.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight)
    }
}

extension BusinessRegistController: JOKBtnCellDelegate {
    
    /// 企业录入信息判断
    func jOKBtnCellClick(sender: UIButton) {
        self.view.endEditing(true)
        if !name.haveTextStr() {
            PromptTool.promptText(L$("p_enter_m_business_name"), 1)
            return
        }
        if !sn.haveTextStr() {
            PromptTool.promptText(L$("p_enter_m_business_code"), 1)
            return
        }
        if sn.count != 18 {
            PromptTool.promptText("统一社会信用代码为18位", 1)
            return
        }
        if !owner_name.haveTextStr() {
            PromptTool.promptText(L$("p_enter_m_business_legal"), 1)
            return
        }
        if !owner_sn.haveTextStr() {
            PromptTool.promptText(L$("p_enter_m_business_id_card"), 1)
            return
        }
        if owner_sn.count != 18 {
            PromptTool.promptText("身份证号码固定为18位", 1)
            return
        }
        if !contact_name.haveTextStr() {
            PromptTool.promptText(L$("p_enter_m_business_contact"), 1)
            return
        }
        if UserInfo.share.mobile?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_m_business_mobile"), 1)
            return
        }
        if !code.haveTextStr() {
            PromptTool.promptText("请输入手机号验证码", 1)
            return
        }
        if !BaseUtil.emailValid(email: email) {
            PromptTool.promptText(L$("p_enter_valid_email"), 1)
            return
        }
        if !email_code.haveTextStr() {
            PromptTool.promptText("请输入邮箱验证码", 1)
            return
        }
        if !username.haveTextStr() {
            PromptTool.promptText(L$("p_enter_username"), 1)
            return
        }
        if !password.haveTextStr() {
            PromptTool.promptText(L$("p_enter_pass"), 1)
            return
        }
        if username.count < 6 || username.count > 20 {
            PromptTool.promptText(L$("p_username_limit"), 1)
            return
        }
        if !BaseUtil.checkAccountRegularValid(username: username) {
            PromptTool.promptText("账号名不能有特殊符号", 1)
            return
        }
        if password.count < 8 || password.count > 20 {
            PromptTool.promptText(L$("p_pass_limit"), 1)
            return
        }
        if !self.remotePath.haveTextStr() {
            PromptTool.promptText(L$("p_enter_m_business_photo"), 1)
            return
        }
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: L$("p_sure_commit"), message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            self.lastCommit()
        }, cancelHandler: nil)
    }
    
    private func lastCommit() {
        let prams: NSDictionary = ["name":name,"sn":sn,"owner_name":owner_name,"owner_sn":owner_sn,"contact_name":contact_name,"mobile":UserInfo.share.mobile!,"code":code,"email":email,"email_code":email_code,"username":username,"password":password, "image": remotePath, "recommend_id": recommender]
        LRManager.share.companyRegist(prams: prams, success: { (flag) in
            if (flag) {
                UserInfo.setBusinessUsername(text: self.username)
                UserInfo.setBusinessEmail(text: self.email)
                JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: L$("p_commit_success"), message: "注册成功，24小时内完成审核。审核完成后会发送短信到您的手机，请注意查收。", sure: L$("sure"), cancel: nil, sureHandler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }, cancelHandler: nil)
            }
        })
    }
}
