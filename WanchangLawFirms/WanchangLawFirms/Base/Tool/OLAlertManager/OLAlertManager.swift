//
//  OLAlertManager.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 欧伶猪所有弹框管理器
class OLAlertManager: UIView {
    
    static let share: OLAlertManager = OLAlertManager()
    
    /// 三方分享弹框
    var pickerView: OLPickerView?
    /// 性别、头像弹框
    var profilePickerView: OLProfilePickerView?
    /// UITextfield弹框
    var tfView: OLAlertTFView?
    /// 价格信息弹框
    var priceView: JCustomPayPriceView?
    /// 企业价格信息弹框
    var priceBusinessView: JBusinessCustomPayPriceView?
    /// 支付方式弹框
    var payView: JPayWayView?
    /// 购买vip弹框
    var buyVipView: JBuyVIPView?
    /// 购买企业vip弹框
    var buyBusinessVipView: JBuyBusinessVIPView?
    /// 法务计算器弹框
    var calcuteView: JCalculateAlertView?
    /// 服务评价弹框
    var commentView: OLCommentAlertView?
    /// 对公账号弹框
    var orangeBankView: OrangeBankPreviewView?
    /// 注销界面
    var logOffView: JlogOffView?
    
    /// 计算器计算模型
    var calTypeModel: JCalculateTypeModel = JCalculateTypeModel()

}

// MARK: - 法务计算器
extension OLAlertManager {
    func getCalModelArr(bind: String, success:@escaping([JCalculateModel]) -> Void) {
        if calTypeModel.caseArr.count == 0 {
            HomeManager.share.counterSetting(prams: NSDictionary()) { (m) in
                if m != nil {
                    self.calTypeModel = m!
                    self.calMArrDeal(bind: bind, success: success)
                } else {
                    self.calcuteHide()
                }
            }
        } else {
            self.calMArrDeal(bind: bind, success: success)
        }
    }
    
    private func calMArrDeal(bind: String, success:@escaping([JCalculateModel]) -> Void) {
        if bind == "h_select_area" {
            success(calTypeModel.provinceArr)
        } else if bind == "h_disability_grade" {
            success(calTypeModel.levelArr)
        } else if bind == "h_choose_hukou" {
            success(calTypeModel.residentArr)
        } else if bind == "h_choose_lawyer_type" {
            success(calTypeModel.typeArr)
        } else if bind == "h_choose_liti_type" {
            success(calTypeModel.caseArr)
        } else if bind == "h_property_involved" {
            success(calTypeModel.isOrNotArr)
        }
    }
}

// MARK: - 三方分享弹框
extension OLAlertManager {
    func pickerShow(bindArr: [String]) {
        if pickerView != nil {
            return
        }
        pickerView = OLPickerView.init(bindArr: bindArr)
        let tempH = self.pickerView!.bgImgView.frame.size.height
        UIView.animate(withDuration: 0.25) {
            self.pickerView?.layer.opacity = 1
            self.pickerView?.bgImgView.frame = CGRect.init(x: 0, y: kDeviceHeight - tempH, width: kDeviceWidth, height: tempH)
        }
    }
    
    func pickerHide() {
        let tempH = self.pickerView!.bgImgView.frame.size.height
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView?.layer.opacity = 0
            self.pickerView?.bgImgView.frame = CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: tempH)
        }) { (flag) in
            self.pickerView?.removeFromSuperview()
            self.pickerView = nil
        }
    }
    
}

// MARK: - 性别、头像弹框
extension OLAlertManager {
    func profilePickerShow(isAvatar: Bool) {
        if profilePickerView != nil {
            return
        }
        profilePickerView = OLProfilePickerView.init(isAvatar: isAvatar)
        let tempH = self.profilePickerView!.bgImgView.frame.size.height
        UIView.animate(withDuration: 0.25) {
            self.profilePickerView?.layer.opacity = 1
            self.profilePickerView?.bgImgView.frame = CGRect.init(x: 0, y: kDeviceHeight - tempH, width: kDeviceWidth, height: tempH)
        }
    }
    
    func profilePickerHide() {
        let tempH = self.profilePickerView!.bgImgView.frame.size.height
        UIView.animate(withDuration: 0.25, animations: {
            self.profilePickerView?.layer.opacity = 0
            self.profilePickerView?.bgImgView.frame = CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: tempH)
        }) { (flag) in
            self.profilePickerView?.removeFromSuperview()
            self.profilePickerView = nil
        }
    }
    
}

// MARK: - UITextfield弹框
extension OLAlertManager {
    func tfShow(titleBind: String, placeholderBind: String, text: String?) {
        if tfView != nil {
            return
        }
        tfView = OLAlertTFView.init(titleBind: titleBind, placeholderBind: placeholderBind, text: text)
        UIView.animate(withDuration: 0.25) {
            self.tfView?.layer.opacity = 1
        }
    }
    
    func tfHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.tfView?.layer.opacity = 0
        }) { (flag) in
            self.tfView?.removeFromSuperview()
            self.tfView = nil
        }
    }
    
}

// MARK: - 价格信息弹框
extension OLAlertManager {
    func priceShow(model: ProductModel) {
        if priceView != nil {
            return
        }
        priceView = JCustomPayPriceView.init(model: model)
        UIView.animate(withDuration: 0.25) {
            self.priceView?.layer.opacity = 1
        }
    }
    
    func priceHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.priceView?.layer.opacity = 0
        }) { (flag) in
            self.priceView?.removeFromSuperview()
            self.priceView = nil
        }
    }
    
}

// MARK: - 企业价格信息弹框
extension OLAlertManager {
    func priceBusinessShow(model: ProductModel) {
        if priceBusinessView != nil {
            return
        }
        priceBusinessView = JBusinessCustomPayPriceView.init(model: model)
        UIView.animate(withDuration: 0.25) {
            self.priceBusinessView?.layer.opacity = 1
        }
    }
    
    func priceBusinessHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.priceBusinessView?.layer.opacity = 0
        }) { (flag) in
            self.priceBusinessView?.removeFromSuperview()
            self.priceBusinessView = nil
        }
    }
    
}

// MARK: - 支付方式弹框：微信、支付宝支付
extension OLAlertManager {
    func payShow(model: JPayModel) {
        if payView != nil {
            return
        }
        payView = JPayWayView.init(model: model)
        UIView.animate(withDuration: 0.25) {
            self.payView?.layer.opacity = 1
            self.payView?.tabView.frame = CGRect.init(x: 0, y: kDeviceHeight - 370, width: kDeviceWidth, height: 370)
        }
    }
    
    func payHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.payView?.layer.opacity = 0
            self.payView?.tabView.frame = CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: 370)
        }) { (flag) in
            self.payView?.removeFromSuperview()
            self.payView = nil
        }
    }
    
}

// MARK: - 购买vip弹框
extension OLAlertManager {
    func buyVipShow(is_upgrade: Bool) {
        if buyVipView != nil {
            return
        }
        buyVipView = JBuyVIPView.init(is_upgrade: is_upgrade)
        UIView.animate(withDuration: 0.25) {
            self.buyVipView?.layer.opacity = 1
            self.buyVipView?.tabView.frame = CGRect.init(x: 0, y: kDeviceHeight - 500, width: kDeviceWidth, height: 500)
        }
    }
    
    func buyVipHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.buyVipView?.layer.opacity = 0
            self.buyVipView?.tabView.frame = CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: 500)
        }) { (flag) in
            self.buyVipView?.removeFromSuperview()
            self.buyVipView = nil
        }
    }
}

// MARK: - 购买企业vip弹框
extension OLAlertManager {
    func buyBusinessVipShow(is_upgrade: Bool) {
        if buyBusinessVipView != nil {
            return
        }
        buyBusinessVipView = JBuyBusinessVIPView.init(is_upgrade: is_upgrade)
        UIView.animate(withDuration: 0.25) {
            self.buyBusinessVipView?.layer.opacity = 1
            self.buyBusinessVipView?.tabView.frame = CGRect.init(x: 0, y: kDeviceHeight - 500, width: kDeviceWidth, height: 500)
        }
    }
    
    func buyBusinessVipHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.buyBusinessVipView?.layer.opacity = 0
            self.buyBusinessVipView?.tabView.frame = CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: 500)
        }) { (flag) in
            self.buyBusinessVipView?.removeFromSuperview()
            self.buyBusinessVipView = nil
        }
    }
}

// MARK: - 法务计算弹框
extension OLAlertManager {
    func calculateShow(bind: String) {
        if calcuteView != nil {
            return
        }
        calcuteView = JCalculateAlertView.init(bind: bind)
        UIView.animate(withDuration: 0.25) {
            self.calcuteView?.layer.opacity = 1
        }
    }
    
    func calcuteHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.calcuteView?.layer.opacity = 0
        }) { (flag) in
            self.calcuteView?.removeFromSuperview()
            self.calcuteView = nil
        }
    }
}

// MARK: - 服务评价弹框
extension OLAlertManager {
    func commentShow(text: String, score: Float) {
        if commentView != nil {
            return 
        }
        commentView = OLCommentAlertView.init(text: text, score: score)
        UIView.animate(withDuration: 0.25) {
            self.commentView?.layer.opacity = 1
        }
    }
    
    func commentHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.commentView?.layer.opacity = 0
        }) { (flag) in
            self.commentView?.removeFromSuperview()
            self.commentView = nil
        }
    }
    
}

/// 对公账号弹框
extension OLAlertManager {
    func orangeBankShow() {
        if orangeBankView != nil {
            return
        }
        orangeBankView = OrangeBankPreviewView.init(frame: UIScreen.main.bounds)
        UIView.animate(withDuration: 0.25) {
            self.orangeBankView?.layer.opacity = 1
        }
    }
    
    func orangeBankHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.orangeBankView?.layer.opacity = 0
        }) { (flag) in
            self.orangeBankView?.removeFromSuperview()
            self.orangeBankView = nil
        }
    }
}

/// 注销界面
extension OLAlertManager {
    func logOffShow() {
        if logOffView != nil {
            return
        }
        logOffView = JlogOffView.init(frame: UIScreen.main.bounds)
        UIView.animate(withDuration: 0.25) {
            self.logOffView?.layer.opacity = 1
        }
    }
    
    func logOffHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.logOffView?.layer.opacity = 0
        }) { (flag) in
            self.logOffView?.removeFromSuperview()
            self.logOffView = nil
        }
    }
}
