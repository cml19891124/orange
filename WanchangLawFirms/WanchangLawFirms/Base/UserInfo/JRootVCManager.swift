//
//  JRootVCManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
/// 根控制器切换
class JRootVCManager: NSObject {
    static let share = JRootVCManager()
    
    /// 切换到登陆界面
    func rootLogin() {
        UserInfo.share.clearAll()
//        let vc = LoginController()
        let vc = ChooseRoleController()
        vc.currentNavigationBarAlpha = 0
        let nav = BaseNavigationController.init(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController = nav
    }
    
    /// 登陆成功后切换到主界面
    func rootMain() {
        UserInfo.share.is_tourist = false
        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
    }
    
    func touristMain() {
        UserInfo.share.is_tourist = true
        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
    }
    
    /// 被踢掉
    ///
    /// - Parameter content: 被踢掉的原因，如：同一账号换设备登陆
    func kickOff(content: String) {
        self.rootLogin()
        let alertCon = UIAlertController.init(title: content, message: nil, preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: L$("sure"), style: .default, handler: { (action) in
            
        })
        alertCon.addAction(sureAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertCon, animated: true, completion: nil)
    }
    
    func touristJudgeAlert() -> Bool {
        if UserInfo.share.is_tourist {
            let alertCon = UIAlertController.init(title: "需要登录，去登录？", message: nil, preferredStyle: .alert)
            let sureAction = UIAlertAction.init(title: L$("sure"), style: .default, handler: { (action) in
                NotificationCenter.default.post(name: NSNotification.Name(noti_tourist_back), object: nil)
            })
            let cancelAction = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
            alertCon.addAction(sureAction)
            alertCon.addAction(cancelAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertCon, animated: true, completion: nil)
            return true
        }
        return false
    }

}
