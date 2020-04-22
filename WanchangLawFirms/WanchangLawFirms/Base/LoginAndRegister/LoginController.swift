//
//  LoginController.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import SafariServices

/// 登陆界面
class LoginController: BaseController {
    
    private let botH: CGFloat = 110
    private var topH: CGFloat = kBarStatusHeight + 40
    private lazy var cellH: CGFloat = {
        () -> CGFloat in
        var temp = (kDeviceHeight - topH - botH - 75) / 4
        if temp > kCellHeight {
            temp = kCellHeight
        }
        return temp
    }()
    private lazy var logoImgBtn: JVLogoBtn = {
        () -> JVLogoBtn in
        let temp = JVLogoBtn.init(logo: "lr_logo")
        temp.frame = CGRect.init(x: 0, y: kBarStatusHeight + 30, width: kDeviceWidth, height: temp.j_height)
        topH = temp.j_height + 40 + kBarStatusHeight
        temp.setImage(UIImage.init(named: "lr_logo"), for: .normal)
        self.view.addSubview(temp)
        return temp
    }()
    
    private let bWidth: CGFloat = kDeviceWidth - kLeftSpaceL * 2
    
    private lazy var bView: JShadowView = {
        () -> JShadowView in
        let temp = JShadowView.init(bgColor: UIColor.white, shadowColor: customColor(200, 143, 61))
        self.view.addSubview(temp)
        return temp
    }()
    
    private lazy var chooseView: LoginChooseView = {
        () -> LoginChooseView in
        let temp = LoginChooseView.init(frame: CGRect.init(x: 0, y: 10, width: bWidth, height: 45))
        temp.chooseView.delegate = self
        self.bView.contentView.addSubview(temp)
        return temp
    }()
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect(), style: .plain, space: 0)
        temp.separatorStyle = .none
        temp.bounces = false
        temp.delegate = self
        temp.dataSource = self
        if #available(iOS 11.0, *) {
            temp.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        temp.register(MobileTFCell.self, forCellReuseIdentifier: "MobileTFCell")
        temp.register(PassTFCell.self, forCellReuseIdentifier: "PassTFCell")
        temp.register(CodeTFCell.self, forCellReuseIdentifier: "CodeTFCell")
        temp.register(LoginBtnCell.self, forCellReuseIdentifier: "LoginBtnCell")
        temp.register(ForgetPassCell.self, forCellReuseIdentifier: "ForgetPassCell")
        temp.register(LLabCell.self, forCellReuseIdentifier: "LLabelXieyi")
        temp.register(AccountUserNameTFCell.self, forCellReuseIdentifier: "AccountUserNameTFCell")
        temp.register(AccountEmailTFCell.self, forCellReuseIdentifier: "AccountEmailTFCell")
        temp.register(LoginTFBaseCell.self, forCellReuseIdentifier: "LoginTFBaseCell")
        self.bView.contentView.addSubview(temp)
        return temp
    }()
    
    private lazy var thirdView: LoginThirdView = {
        () -> LoginThirdView in
        var tempY = kDeviceHeight - botH
        let temp = LoginThirdView.init(frame: CGRect.init(x: kLeftSpaceL, y: tempY, width: kDeviceWidth - kLeftSpaceL * 2, height: botH))
        self.view.addSubview(temp)
        return temp
    }()
    
    private var isLogin: Bool = true
    private var loginWayBind: String = "lr_code_login"
    private var wordArr: [String] = [String]()
    
    private var sms_code: String?
    private var password: String?
    
    private var username: String?
    private var email: String?
    
    private var recommender: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabView.reloadData()
        JKeyboardNotiManager.share.delegate = self
        if UserInfo.share.is_business {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "跳过", style: .done, target: self, action: #selector(jumpClick))
        }
    }
    
    @objc private func showNav() {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        username = UserInfo.share.business_username
        email = UserInfo.share.business_email
        self.setupViews()
        self.getDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(showNav), name: NSNotification.Name(rawValue: noti_tab_back), object: nil)
    }
    
    private func setupViews() {
        self.view.backgroundColor = kOrangeLightColor
        self.logoImgBtn.isHidden = false
        self.chooseView.isHidden = false
    }
    
    @objc private func jumpClick() {
//        JRootVCManager.share.touristMain()
        UserInfo.share.is_tourist = true
        let mainVC = MainTabBarController()
        mainVC.currentNavigationBarAlpha = 0
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(mainVC, animated: true)
    }

}

extension LoginController: JKeyboardNotiManagerDelegate {
    
    func jkeyboardHeightChange(kH: CGFloat, duration: Double) {
        let y1 = self.bView.origin.y
        let h1 = self.bView.frame.size.height - cellH * 2
        let del = y1 + h1 + kH - kDeviceHeight
        if del > 0 {
            UIView.animate(withDuration: duration) {
                self.bView.origin = CGPoint.init(x: kLeftSpaceL, y: y1 - del)
            }
        }
    }
    
    func jkeyboardWillHide(kH: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.bView.origin = CGPoint.init(x: kLeftSpaceL, y: self.topH)
        }
    }
}

extension LoginController: JTitleChooseViewDelegate {
    func jtitleChooseViewSelected(model: JTitleChooseModel) {
        if model.tag == 1 {
            self.isLogin = true
        } else {
            self.isLogin = false
        }
        self.getDataSource()
    }
    
    private func getDataSource() {
        if isLogin { /// 个人版登陆
            wordArr = ["mobile","pass","forget_pass","btn"]
            self.thirdView.isHidden = false
            if UserInfo.share.is_business { /// 企业版登陆
                wordArr = ["account","pass","forget_pass","btn"]
                self.thirdView.isHidden = true
            }
        } else {
            wordArr = ["mobile","code","pass","recommender","xieyi","btn"]
            self.thirdView.isHidden = true
            if UserInfo.share.is_business {
                wordArr = ["email","pass","forget_pass","btn"]
            }
        }
        bView.frame = CGRect.init(x: kLeftSpaceL, y: topH, width: bWidth, height: CGFloat(wordArr.count) * cellH + cellH + 10)
        tabView.reloadData()
        _ = tabView.sd_layout()?.leftEqualToView(bView.contentView)?.topSpaceToView(bView.contentView, cellH + 10)?.rightEqualToView(bView.contentView)?.bottomSpaceToView(bView.contentView, 0)
    }
}

extension LoginController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempStr = wordArr[indexPath.row]
        if tempStr == "mobile" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "MobileTFCell", for: indexPath) as! MobileTFCell
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$("p_enter_mobile")
            cell.tf.text = UserInfo.share.mobile
            return cell
        } else if tempStr == "account" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "AccountUserNameTFCell", for: indexPath) as! AccountUserNameTFCell
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$("p_enter_account")
            cell.tf.text = username
            cell.leftBtn.setImage(UIImage.init(named: "lr_mobile"), for: .normal)
            cell.tf.delegate = self
            return cell
        } else if tempStr == "email" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "AccountEmailTFCell", for: indexPath) as! AccountEmailTFCell
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$("p_enter_email")
            cell.tf.text = email
            cell.leftBtn.setImage(UIImage.init(named: "lr_mobile"), for: .normal)
            cell.tf.delegate = self
            return cell
        } else if tempStr == "pass" {
            if loginWayBind == "lr_pass_login" && isLogin {
                let cell = tabView.dequeueReusableCell(withIdentifier: "CodeTFCell", for: indexPath) as! CodeTFCell
                cell.logined = false
                cell.isLogin = true
                cell.isEmail = false
                cell.tf.delegate = self
                cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
                cell.placeholder = L$("p_enter_code")
                return cell
            }
            let cell = tabView.dequeueReusableCell(withIdentifier: "PassTFCell", for: indexPath) as! PassTFCell
            cell.tf.delegate = self
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$("p_enter_pass")
            cell.tf.text = nil
            password = nil
            return cell
        } else if tempStr == "code" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "CodeTFCell", for: indexPath) as! CodeTFCell
            cell.logined = false
            cell.isLogin = false
            cell.isEmail = false
            cell.tf.delegate = self
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$("p_enter_code")
            return cell
        } else if tempStr == "btn" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "LoginBtnCell", for: indexPath) as! LoginBtnCell
            if UserInfo.share.is_business {
                cell.btn.setTitle(L$("lr_login"), for: .normal)
            } else {
                if isLogin {
                    cell.btn.setTitle(L$("lr_login"), for: .normal)
                } else {
                    cell.btn.setTitle(L$("lr_register"), for: .normal)
                }
            }
            cell.delegate = self
            return cell
        } else if tempStr == "xieyi" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LLabelXieyi", for: indexPath) as! LLabCell
            cell.lab.delegate = self
            cell.lab.textColor = kTextBlackColor
            let str1 = L$("lr_click_register_means")
            let str2 = L$("lr_agreement")
            cell.lab.text = str1 + str2
            cell.lab.addClickText(str: str2, original_color: kOrangeDarkColor, click_color: kOrangeDarkClickColor)
            return cell
        } else if tempStr == "recommender" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoginTFBaseCell", for: indexPath) as! LoginTFBaseCell
            cell.colorSetup(placeholderColor: kOrangeLightColor, lineColor: kOrangeLightColor)
            cell.placeholder = L$("recommender")
            cell.leftBtn.setImage(UIImage.init(named: "m_business_recommender_lr"), for: .normal)
            cell.tf.delegate = self
            return cell
        }
        let cell = tabView.dequeueReusableCell(withIdentifier: "ForgetPassCell", for: indexPath) as! ForgetPassCell
        cell.leftLab.delegate = self
        if UserInfo.share.is_business {
            let str1 = L$("lr_no_account")
            let str2 = L$("lr_regist_instant")
            cell.leftLab.text = str1 + str2
            cell.leftLab.textColor = kTextGrayColor
            cell.leftLab.addClickText(str: str2, original_color: kOrangeDarkColor, click_color: kOrangeDarkClickColor)
            cell.rightLab.delegate = self
            cell.rightLab.text = L$("lr_forget_pass") + "?"
            cell.rightLab.addClickText(str: L$("lr_forget_pass") + "?", original_color: kTextBlackColor, click_color: kTextBlackClickColor)
        } else {
            cell.leftLab.text = L$(loginWayBind)
            cell.leftLab.addClickText(str: L$(loginWayBind), original_color: kTextBlackColor, click_color: kTextBlackClickColor)
            cell.rightLab.delegate = self
            cell.rightLab.text = L$("lr_forget_pass") + "?"
            cell.rightLab.addClickText(str: L$("lr_forget_pass") + "?", original_color: kTextBlackColor, click_color: kTextBlackClickColor)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

extension LoginController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        if string == "" {
            return true
        }
        if textField.text != nil {
            if textField.text!.count > 30 {
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == L$("p_enter_pass") {
            password = textField.text
        } else if textField.placeholder == L$("p_enter_code") {
            sms_code = textField.text
        } else if textField.placeholder == L$("p_enter_account") {
            username = textField.text
        } else if textField.placeholder == L$("p_enter_email") {
            email = textField.text
        } else if textField.placeholder == L$("recommender") {
            recommender = textField.text
        }
    }
    
}

extension LoginController: LLabelDelegate {
    func llabelClick(text: String) {
        if text == L$("lr_forget_pass") + "?" {
            if UserInfo.share.is_business {
                let vc = BusinessForgetPasswordController()
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            let vc = ForgetPasswordController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if text == L$(loginWayBind) {
            if loginWayBind == "lr_code_login" {
                loginWayBind = "lr_pass_login"
            } else {
                loginWayBind = "lr_code_login"
            }
            self.tabView.reloadData()
        } else if text == L$("lr_regist_instant") {
            let vc = BusinessRegistController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let urlStr = BASE_URL + api_posts_info + "?symbol=agree"
            let vc = JSafariController.init(urlStr: urlStr, title: "用户使用协议")
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension LoginController: LoginBtnCellDelegate {
    func loginBtnCellClick(sender: UIButton) {
        if isLogin {
            if UserInfo.share.is_business {
                self.companyUserNameLogin(sender: sender)
            } else {
                self.loginClick(sender: sender)
            }
        } else {
            if UserInfo.share.is_business {
                self.companyEmailLogin(sender: sender)
            } else {
                self.registClick(sender: sender)
            }
        }
    }
}

extension LoginController {
    /// 登陆
    private func loginClick(sender: UIButton) {
        self.view.endEditing(true)
        if UserInfo.share.mobile?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_mobile"), 1)
            return
        }
        if loginWayBind == "lr_code_login" {
            if password?.haveTextStr() != true {
                PromptTool.promptText(L$("p_enter_pass"), 1)
                return
            }
            sender.isUserInteractionEnabled = false
            let prams: NSDictionary = ["mobile":UserInfo.share.mobile!,"password":password!]
            LRManager.share.pubLogin(prams: prams) { (flag) in
                if flag {
                    UserInfo.setUserMobile(text: UserInfo.share.mobile)
                    JRootVCManager.share.rootMain()
                } else {
                    sender.isUserInteractionEnabled = true
                }
            }
        } else {
            if sms_code?.haveTextStr() != true {
                PromptTool.promptText(L$("p_enter_code"), 1)
                return
            }
            sender.isUserInteractionEnabled = false
            let prams: NSDictionary = ["mobile":UserInfo.share.mobile!,"code":sms_code!]
            LRManager.share.pubLoginSms(prams: prams) { (flag) in
                if flag {
                    UserInfo.setUserMobile(text: UserInfo.share.mobile)
                    JRootVCManager.share.rootMain()
                } else {
                    sender.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    /// 注册
    private func registClick(sender: UIButton) {
        self.view.endEditing(true)
        if UserInfo.share.mobile?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_mobile"), 1)
            return
        }
        if sms_code?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_code"), 1)
            return
        }
        if password?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_pass"), 1)
            return
        }
        if password!.count < 8 || password!.count > 20 {
            PromptTool.promptText(L$("p_pass_limit"), 1)
            return
        }
        sender.isUserInteractionEnabled = false
        let mulPrams: NSMutableDictionary = NSMutableDictionary()
        mulPrams["mobile"] = UserInfo.share.mobile!
        mulPrams["password"] = password!
        mulPrams["code"] = sms_code!
        if recommender != nil {
            mulPrams["recommend_id"] = recommender!
        }
        LRManager.share.pubReg(prams: mulPrams) { (flag) in
            if flag {
                JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: L$("p_regist_success"), message: nil, sure: L$("sure"), cancel: nil, sureHandler: { (action) in
                    self.chooseView.chooseView.selectIndex(index: 0)
                }, cancelHandler: nil)
                self.tabView.reloadData()
            }
            sender.isUserInteractionEnabled = true
        }
    }
    
    /// 企业版用户名登陆
    private func companyUserNameLogin(sender: UIButton) {
        if username?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_username"), 1)
            return
        }
        if password?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_pass"), 1)
            return
        }
        sender.isUserInteractionEnabled = false
        let prams: NSDictionary = ["username":username!,"password":password!]
        LRManager.share.companyLoginUsername(prams: prams) { (flag) in
            if (flag) {
                UserInfo.setBusinessUsername(text: self.username)
                JRootVCManager.share.rootMain()
            } else {
                sender.isUserInteractionEnabled = true
            }
        }
    }
    
    /// 企业版邮箱登陆
    private func companyEmailLogin(sender: UIButton) {
        if email?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_email"), 1)
            return
        }
        if password?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_pass"), 1)
            return
        }
        sender.isUserInteractionEnabled = false
        let prams: NSDictionary = ["email":email!,"password":password!]
        LRManager.share.companyLoginEmail(prams: prams) { (flag) in
            if (flag) {
                UserInfo.setBusinessEmail(text: self.email)
                JRootVCManager.share.rootMain()
            } else {
                sender.isUserInteractionEnabled = true
            }
        }
    }
}
