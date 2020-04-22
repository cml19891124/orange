//
//  LRManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/3.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 单例 注册管理
class LRManager: NSObject {
    static let share: LRManager = LRManager()
    
    /// 手机号登陆
    func pubLogin(prams: NSDictionary, success: @escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pub_login, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                self.loginDeal(dict: dict[net_key_result] as? NSDictionary)
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 短信校验码登陆
    func pubLoginSms(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pub_login_sms, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                self.loginDeal(dict: dict[net_key_result] as? NSDictionary)
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 第三方授权登陆
    func pubLoginOauth(prams: NSDictionary) {
        HTTPManager.share.ask(isGet: false, url: api_pub_login_oauth, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                self.loginDeal(dict: dict[net_key_result] as? NSDictionary)
                JRootVCManager.share.rootMain()
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
            }
        }) { (error) in
            
        }
    }
    
    /// 登陆成功后信息处理
    private func loginDeal(dict: NSDictionary?) {
        let token = dict?["token"] as? String
        let expire = dict?["expired"] as? String
        let cryptDict = dict?["crypt"] as? NSDictionary
        let key = cryptDict?["key"] as? String
        let iv = cryptDict?["iv"] as? String
        UserInfo.setUserToken(text: token)
        UserInfo.setUserExpired(text: expire)
        UserInfo.setUserAESKey(text: key)
        UserInfo.setUserAESIv(text: iv)
    }

    /// 用户注册
    func pubReg(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pub_reg, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 获取短信校验码
    func pubSmsCode(prams: NSDictionary, success:@escaping(Bool, String?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_pub_sms_code, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let result = dict[net_key_result] as? String
                success(true, result)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false, nil)
            }
        }) { (error) in
            success(false, nil)
        }
    }
    
    /// 获取邮箱
    func pubEmailCode(prams: NSDictionary, success:@escaping(Bool, String?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_pub_email_code, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let result = dict[net_key_result] as? String
                success(true, result)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false, nil)
            }
        }) { (err) in
            success(false, nil)
        }
    }
    
    /// 设置新密码
    func pubReset(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pub_reset, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 邮箱重置密码
    func pubResetEmail(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pub_reset_email, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 登陆成功后获取验证码，不再输入手机号，直接请求接口即可
    func userSms(success:@escaping(Bool, String?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_user_sms, prams: NSDictionary(), needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let result = dict[net_key_result] as? String
                success(true, result)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false, nil)
            }
        }) { (err) in
            success(false, nil)
        }
    }
}

extension LRManager {
    /// 企业注册
    func companyRegist(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pub_co_reg, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                success(false)
                PromptTool.promptText(dict[net_key_msg], 1)
            }
        }) { (err) in
            success(false)
        }
    }
    
    /// 企业重新审核
    func companyInfoExa(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_company_info_exa, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                UserInfo.share.companyInfo()
                success(true)
            } else {
                success(false)
                PromptTool.promptText(dict[net_key_msg], 1)
            }
        }) { (err) in
            success(false)
        }
    }
    
    /// 企业用户名登陆
    func companyLoginUsername(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pub_co_login_username, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                UserInfo.setIsBusiness(text: "1")
                self.loginDeal(dict: dict[net_key_result] as? NSDictionary)
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    /// 企业邮箱登陆
    func companyLoginEmail(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pub_co_login_email, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                UserInfo.setIsBusiness(text: "1")
                self.loginDeal(dict: dict[net_key_result] as? NSDictionary)
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
}
