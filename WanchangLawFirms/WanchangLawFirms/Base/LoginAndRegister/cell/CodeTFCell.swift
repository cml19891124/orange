//
//  CodeTFCell.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 校验码
class CodeTFCell: LoginTFBaseCell {
    
    var logined: Bool = false
    var isLogin: Bool = false
    var isEmail: Bool = false
    
    private lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick(sender:)))
        temp.layer.cornerRadius = kBtnCornerR
        temp.backgroundColor = kOrangeDarkColor
        return temp
    }()
    
    private lazy var timer: Timer = {
        () -> Timer in
        let temp = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        return temp
    }()
    private var count: Int = 60
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.leftBtn.setImage(UIImage.init(named: "lr_code"), for: .normal)
        self.tf.rightViewMode = .always
        self.tf.keyboardType = .numberPad
        self.tf.rightView = btn
        self.titleStr(text: L$("lr_get_code"))
    }
    
    @objc private func btnClick(sender: UIButton) {
        UIApplication.shared.keyWindow?.endEditing(true)
        if logined {
            if isEmail {
                
            } else {
                self.userSms(sender: sender)
            }
        } else {
            if isEmail {
                if UserInfo.share.business_email?.haveTextStr() != true {
                    PromptTool.promptText("请输入邮箱", 1)
                    return
                }
                sender.isUserInteractionEnabled = false
                self.checkEmail(email: UserInfo.share.business_email!) { (flag) in
                    if self.isLogin {
                        if flag {
                            self.emailCode(email: UserInfo.share.business_email!)
                        } else {
                            PromptTool.promptText("该邮箱未注册", 1)
                            sender.isUserInteractionEnabled = true
                        }
                    } else {
                        if flag {
                            PromptTool.promptText("该邮箱已绑定", 1)
                            sender.isUserInteractionEnabled = true
                        } else {
                            self.emailCode(email: UserInfo.share.business_email!)
                        }
                    }
                }
            } else {
                if UserInfo.share.mobile?.haveTextStr() != true && UserInfo.share.change_mobile?.haveTextStr() != true {
                    PromptTool.promptText("请输入手机号", 1)
                    return
                }
                var mobile: String = ""
                if UserInfo.share.change_mobile?.haveTextStr() == true {
                    mobile = UserInfo.share.change_mobile ?? ""
                } else {
                    if UserInfo.share.mobile?.haveTextStr() != true {
                        PromptTool.promptText("请输入手机号", 1)
                        return
                    }
                    mobile = UserInfo.share.mobile ?? ""
                }
                sender.isUserInteractionEnabled = false
//                self.checkMobile(mobile: mobile) { (flag) in
//                    if self.isLogin {
//                        if flag {
//                            self.smsCode(mobile: mobile)
//                        } else {
//                            PromptTool.promptText("该手机号未注册", 1)
//                            sender.isUserInteractionEnabled = true
//                        }
//                    } else {
//                        if flag {
//                            PromptTool.promptText("该手机号已绑定", 1)
//                            sender.isUserInteractionEnabled = true
//                        } else {
//                            self.smsCode(mobile: mobile)
//                        }
//                    }
//                }
                self.smsCode(mobile: mobile)
            }
        }
    }
    
    private func checkMobile(mobile: String, success:@escaping(Bool) -> Void) {
        let prams: NSDictionary = ["key":"mobile","val":mobile]
        UserInfo.share.pubCheckUser(prams: prams) { (flag) in
            success(flag)
        }
    }
    
    private func checkEmail(email: String, success:@escaping(Bool) -> Void) {
        let prams: NSDictionary = ["key":"co_email","val":email]
        UserInfo.share.pubCheckUser(prams: prams) { (flag) in
            success(flag)
        }
    }
    
    private func smsCode(mobile: String) {
        btn.isUserInteractionEnabled = false
        let prams: NSDictionary = ["mobile":mobile]
        LRManager.share.pubSmsCode(prams: prams) { (flag, smsCode) in
            if flag {
                self.timer.fireDate = Date.distantPast
                self.tf.text = smsCode
                self.tf.becomeFirstResponder()
            } else {
                self.btn.isUserInteractionEnabled = true
            }
        }
    }
    
    private func emailCode(email: String) {
        btn.isUserInteractionEnabled = false
        let prams: NSDictionary = ["email":email]
        LRManager.share.pubEmailCode(prams: prams) { (flag, emailCode) in
            if flag {
                self.timer.fireDate = Date.distantPast
                self.tf.text = emailCode
                self.tf.becomeFirstResponder()
            } else {
                self.btn.isUserInteractionEnabled = true
            }
        }
    }
    
    private func userSms(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        LRManager.share.userSms { (flag, code) in
            if flag {
                self.timer.fireDate = Date.distantPast
                self.tf.text = code
                self.tf.becomeFirstResponder()
            } else {
                sender.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc private func timerAction() {
        count -= 1
        if count <= 0 {
            self.timer.fireDate = Date.distantFuture
            btn.isUserInteractionEnabled = true
            count = 60
            self.titleStr(text: L$("lr_re_get_code"))
        } else {
            let str = String.init(format: "%d%@", count, L$("lr_seconds"))
            self.titleStr(text: str)
        }
    }
    
    private func titleStr(text: String) {
        btn.setTitle(text, for: .normal)
        let w = btn.sizeThatFits(CGSize.init(width: kDeviceWidth, height: 30)).width + kLeftSpaceS
        btn.frame.size = CGSize.init(width: w, height: 30)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
