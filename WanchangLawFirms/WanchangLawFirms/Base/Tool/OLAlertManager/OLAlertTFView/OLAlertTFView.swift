//
//  OLAlertTFView.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol OLAlertTFViewDelegate: NSObjectProtocol {
    func olalertTFViewOKClick(titleBind: String, text: String)
}

class OLAlertTFView: UIView {
    
    weak var delegate: OLAlertTFViewDelegate?
    lazy var bView: UIView = {
        () -> UIView in
        let temp = UIView.init(baseColor: kCellColor)
        temp.frame = CGRect.init(x: kLeftSpaceL, y: 180, width: kDeviceWidth - kLeftSpaceL * 2, height: 150)
        self.addSubview(temp)
        return temp
    }()
    private lazy var titleLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.center)
        temp.backgroundColor = kBaseColor
        bView.addSubview(temp)
        return temp
    }()
    lazy var tf: JTextField = {
        () -> JTextField in
        let temp = JTextField.init(font: kFontM)
        bView.addSubview(temp)
        return temp
    }()
    private lazy var bottomV: UIView = {
        () -> UIView in
        let temp = UIView()
        temp.backgroundColor = kLineGrayColor
        bView.addSubview(temp)
        return temp
    }()
    private lazy var cancelBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kOrangeDarkColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick(sender:)))
        temp.backgroundColor = kCellColor
        temp.setTitle(L$("cancel"), for: .normal)
        bottomV.addSubview(temp)
        return temp
    }()
    private lazy var okBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kOrangeDarkColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick(sender:)))
        temp.setTitle(L$("sure"), for: .normal)
        temp.backgroundColor = kCellColor
        bottomV.addSubview(temp)
        return temp
    }()
    
    var titleBind: String = ""
    private var isOk: Bool = false

    convenience init(titleBind: String, placeholderBind: String, text: String?) {
        self.init()
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.layer.opacity = 0
        self.titleBind = titleBind
        titleLab.text = L$(titleBind)
        tf.placeholder = L$(placeholderBind)
        tf.text = text
        self.setupView()
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    private func setupView() {
        if titleBind == "p_enter_email" || titleBind == "m_business_email" || titleBind == "m_business_id_card" {
            tf.keyboardType = .asciiCapable
            tf.isSecureTextEntry = true
            tf.isSecureTextEntry = false
        } else if titleBind == "p_enter_nickname" || titleBind == "m_business_name" || titleBind == "m_business_legal" || titleBind == "m_business_contact" || titleBind == "m_business_position" || titleBind == "m_business_business" || titleBind == "m_business_address" {
            
        } else if titleBind == "m_business_password" {
            tf.keyboardType = .asciiCapable
            tf.isSecureTextEntry = true
            tf.isSecureTextEntry = false
        } else {
            tf.keyboardType = .numberPad
        }
        tf.textAlignment = .center
        tf.becomeFirstResponder()
        tf.delegate = self
        _ = titleLab.sd_layout()?.leftEqualToView(bView)?.topEqualToView(bView)?.rightEqualToView(bView)?.heightIs(50)
        _ = tf.sd_layout()?.leftSpaceToView(bView, kLeftSpaceS)?.topSpaceToView(titleLab, 0)?.rightSpaceToView(bView, kLeftSpaceS)?.heightIs(50)
        _ = bottomV.sd_layout()?.leftEqualToView(bView)?.rightEqualToView(bView)?.bottomEqualToView(bView)?.heightIs(50)
        _ = cancelBtn.sd_layout()?.leftEqualToView(bottomV)?.bottomEqualToView(bottomV)?.rightSpaceToView(bottomV, (kDeviceWidth - kLeftSpaceL * 2) / 2)?.heightIs(49)
        _ = okBtn.sd_layout()?.leftSpaceToView(cancelBtn, 1)?.bottomEqualToView(bottomV)?.rightEqualToView(bottomV)?.heightIs(49)
    }
    
    @objc private func btnClick(sender: UIButton) {
        if sender.isEqual(okBtn) {
            isOk = true
        }
        tf.resignFirstResponder()
    }

}

extension OLAlertTFView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            isOk = true
            textField.resignFirstResponder()
            return false
        }
        if string == "" {
            return true
        }
        if textField.text != nil {
            if textField.text!.count > 50 {
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isOk {
            self.delegate?.olalertTFViewOKClick(titleBind: titleBind, text: tf.text ?? "")
        }
        OLAlertManager.share.tfHide()
    }
}
