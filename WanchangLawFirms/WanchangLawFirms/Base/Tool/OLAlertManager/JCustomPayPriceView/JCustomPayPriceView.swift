//
//  JCustomPayPriceView.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JCustomPayPriceViewDelegate: NSObjectProtocol {
    func jCustomPayPriceViewVipClick()
}

protocol JCompleteDataDelegate: NSObjectProtocol {
    func jNeedCompleteData(payM: JPayModel)
}

class JCustomPayPriceView: UIView {
    
    weak var delegate: JCustomPayPriceViewDelegate?
    weak var data_delegate: JCompleteDataDelegate?
    private lazy var bView: UIView = {
        () -> UIView in
        let temp = UIView.init(baseColor: UIColor.white)
        return temp
    }()
    private lazy var topView: UIView = {
        () -> UIView in
        let temp = UIView()
        let gradLayer = CAGradientLayer.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth - kLeftSpaceL * 2, height: 60), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 0, y: 1), colors: [kNavGradeStartColor, kNavGradeEndColor])
        temp.layer.addSublayer(gradLayer)
        return temp
    }()
    private lazy var titleV: JLineLabLineView = {
        () -> JLineLabLineView in
        let temp = JLineLabLineView.init(textColor: UIColor.white, font: kFontL, lineColor: UIColor.white)
        return temp
    }()
    private lazy var priceV: UIView = {
        () -> UIView in
        let temp = UIView.init(baseColor: UIColor.white)
        temp.layer.borderColor = kLineGrayColor.cgColor
        temp.layer.borderWidth = 1
        return temp
    }()
    private lazy var priceLeftLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
        return temp
    }()
    private lazy var priceRightLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.right)
        return temp
    }()
    private lazy var desLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
        return temp
    }()
    private lazy var bottomV: UIView = {
        () -> UIView in
        let temp = UIView()
        let line = UIView.init(lineColor: kLineGrayColor)
        temp.addSubview(line)
        _ = line.sd_layout()?.leftEqualToView(temp)?.rightEqualToView(temp)?.topEqualToView(temp)?.heightIs(kLineHeight)
        return temp
    }()
    private lazy var btn1: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontL, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.layer.cornerRadius = kBtnCornerR
        temp.layer.borderWidth = 1
        temp.layer.borderColor = kLineGrayColor.cgColor
        return temp
    }()
    private lazy var btn2: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontL, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.layer.cornerRadius = kBtnCornerR
        temp.layer.borderWidth = 1
        temp.layer.borderColor = kLineGrayColor.cgColor
        return temp
    }()
    private lazy var backBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kTextGrayColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.setImage(UIImage.init(named: "corss_border_white"), for: .normal)
        return temp
    }()
    
    private var vip_bind: String {
        get {
            if UserInfo.share.is_vip {
                return "upgrade_vip"
            }
            return "open_vip"
        }
    }
    

    private var model: ProductModel!
    convenience init(model: ProductModel) {
        self.init()
        self.model = model
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.layer.opacity = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        self.setupViews()
    }
    
    private func setupViews() {
        titleV.bind = model.title
        priceLeftLab.text = L$("service_fee")
        priceRightLab.text = "¥" + model.price
        if model.id != "15" {
            desLab.text = L$("service_fee_extra")
        }
        btn1.setTitle(L$(vip_bind), for: .normal)
        btn2.setTitle(L$("buy_one"), for: .normal)
        
        self.addSubview(bView)
        bView.addSubview(topView)
        topView.addSubview(titleV)
        bView.addSubview(priceV)
        priceV.addSubview(priceLeftLab)
        priceV.addSubview(priceRightLab)
        bView.addSubview(desLab)
        bView.addSubview(bottomV)
        bottomV.addSubview(btn1)
        bottomV.addSubview(btn2)
        self.addSubview(backBtn)
        
        _ = bView.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(kDeviceWidth - kLeftSpaceL * 2)?.heightIs(330)
        _ = topView.sd_layout()?.leftEqualToView(bView)?.topEqualToView(bView)?.rightEqualToView(bView)?.heightIs(60)
        _ = titleV.sd_layout()?.leftSpaceToView(topView, 50)?.rightSpaceToView(topView, 50)?.centerYEqualToView(topView)?.heightIs(30)
        _ = priceV.sd_layout()?.topSpaceToView(topView, 50)?.leftSpaceToView(bView, kLeftSpaceL)?.rightSpaceToView(bView, kLeftSpaceL)?.heightIs(50)
        _ = priceLeftLab.sd_layout()?.leftSpaceToView(priceV, kLeftSpaceL)?.centerYEqualToView(priceV)?.widthIs(80)?.heightIs(30)
        _ = priceRightLab.sd_layout()?.rightSpaceToView(priceV, kLeftSpaceL)?.centerYEqualToView(priceV)?.widthIs(100)?.heightIs(30)
        _ = desLab.sd_layout()?.leftEqualToView(priceV)?.topSpaceToView(priceV, 0)?.rightEqualToView(priceV)?.heightIs(30)
        _ = bottomV.sd_layout()?.bottomEqualToView(bView)?.leftEqualToView(bView)?.rightEqualToView(bView)?.heightIs(100)
        _ = btn1.sd_layout()?.centerYEqualToView(bottomV)?.leftSpaceToView(bottomV, kLeftSpaceL)?.widthIs((kDeviceWidth - kLeftSpaceL * 5) / 2)?.heightIs(40)
        _ = btn2.sd_layout()?.centerYEqualToView(bottomV)?.rightSpaceToView(bottomV, kLeftSpaceL)?.widthIs((kDeviceWidth - kLeftSpaceL * 5) / 2)?.heightIs(40)
        _ = backBtn.sd_layout()?.centerXEqualToView(self)?.topSpaceToView(bView, kLeftSpaceL)?.widthIs(40)?.heightIs(40)
    }
    
    @objc private func btnsClick(sender: UIButton) {
        OLAlertManager.share.priceHide()
        if sender.isEqual(btn1) {
            if UserInfo.share.vip_from_index == 2 {
                PromptTool.promptText(L$("p_vip_max"), 1)
                return
            }
            self.delegate?.jCustomPayPriceViewVipClick()
        } else if sender.isEqual(btn2) {
            let payM = JPayModel.init(service_type: JPayModelServiceType.custom, id: model.id, price: model.price, content: model.j_content)
            payM.images = model.j_images
            payM.files = model.j_files
            payM.j_isDocument = model.j_isDocument
            payM.j_pid = model.j_pid
            payM.j_email = model.j_email
            if data_delegate != nil {
                self.data_delegate?.jNeedCompleteData(payM: payM)
            } else {
                OLAlertManager.share.payShow(model: payM)
            }
        }
    }

}
