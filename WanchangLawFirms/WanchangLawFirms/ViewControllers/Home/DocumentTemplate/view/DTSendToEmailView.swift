//
//  DTSendToEmailView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/12.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 文书模版发送到邮箱
class DTSendToEmailView: UIView {
    
    var id: String = ""
    private let lab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let tf: JTextField = JTextField.init(font: kFontMS)
    private lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(sendClick(sender:)))
        temp.backgroundColor = kOrangeDarkColor
        return temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        JPayApiManager.share.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        tf.backgroundColor = kCellColor
        tf.placeholder = L$("p_enter_email")
        tf.text = UserInfo.share.model?.email
        tf.delegate = self
        tf.keyboardType = .asciiCapable
        tf.isSecureTextEntry = true
        tf.isSecureTextEntry = false
        lab.text = L$("send_to_email")
        btn.setTitle(L$("send"), for: .normal)
        self.addSubview(lab)
        self.addSubview(tf)
        self.addSubview(btn)
        
        _ = btn.sd_layout()?.bottomEqualToView(self)?.rightSpaceToView(self, kLeftSpaceL)?.widthIs(80)?.heightIs(40)
        _ = tf.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(btn)?.rightSpaceToView(btn, 0)?.heightIs(40)
        _ = lab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.bottomSpaceToView(tf, 0)?.rightSpaceToView(self, kLeftSpaceL)?.heightIs(30)
    }
    
    @objc private func sendClick(sender: UIButton) {
        tf.resignFirstResponder()
        if JRootVCManager.share.touristJudgeAlert() {
            return
        }
        if tf.text?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_email"), 1)
            return
        }
        if UserInfo.share.is_vip {
            sender.isUserInteractionEnabled = false
            let prams: NSDictionary = ["email":tf.text!,"id":id]
            HomeManager.share.pubEmailSend(prams: prams) { (flag) in
                sender.isUserInteractionEnabled = true
                if flag {
                    PromptTool.promptText(L$("p_send_email_success"), 1)
                }
            }
        } else {
            if UserInfo.share.is_business {
//                if !UserInfo.share.isMother {
//                    JAuthorizeManager.init(view: self).alertController(style: .alert, titleStr: "文书模版为简洁模版，仅供参考，会员可免费下载，普通用户下载价格为18元/份。但当前登陆账号为子账号，暂不支持支付。", message: nil, sure: L$("sure"), cancel: nil, sureHandler: nil, cancelHandler: nil)
//                    return
//                }
//                let m = ProductModel.init(isDocument: true, pid: id, email: tf.text!)
//                m.id = "15"
//                m.price = "18.00"
//                OLAlertManager.share.priceShow(model: m)
//                OLAlertManager.share.priceView?.delegate = self
                if UserInfo.share.isMother {
                    JAuthorizeManager.init(view: self).alertController(style: .alert, titleStr: "需要开通会员才能发送到邮箱", message: nil, sure: L$("open_vip"), cancel: L$("cancel"), sureHandler: { (action) in
                        let vc = MineBusinessVIPController()
                        vc.isBuy = true
                        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
                    }, cancelHandler: nil)
                } else {
                    JAuthorizeManager.init(view: self).alertController(style: .alert, titleStr: "需要母账号开通会员才能发送到邮箱", message: nil, sure: L$("sure"), cancel: nil, sureHandler: { (action) in
                        
                    }, cancelHandler: nil)
                }
            } else {
                JAuthorizeManager.init(view: self).alertController(style: .alert, titleStr: "需要开通会员才能发送到邮箱", message: nil, sure: L$("open_vip"), cancel: L$("cancel"), sureHandler: { (action) in
                    let vc = MineVIPController()
                    vc.isBuy = true
                    JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
                }, cancelHandler: nil)
            }
        }
    }
    
}

extension DTSendToEmailView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        if string == "" {
            return true
        }
        if textField.text != nil && textField.text!.count > 50 {
            return false
        }
        return true
    }
}

extension DTSendToEmailView: JPayApiManagerDelegate {
    func jPayApiManagerPayResult(success: Bool) {
        if success {
            JAuthorizeManager.init(view: self).alertController(style: .alert, titleStr: L$("p_send_email_success"), message: nil, sure: L$("sure"), cancel: nil, sureHandler: { (action) in
                
            }, cancelHandler: nil)
        }
    }
}

extension DTSendToEmailView: JCustomPayPriceViewDelegate {
    func jCustomPayPriceViewVipClick() {
        let vc = MineVIPController()
        vc.isBuy = true
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
    }
}





