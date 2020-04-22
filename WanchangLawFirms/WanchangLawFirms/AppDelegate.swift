//
//  AppDelegate.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/11/29.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupExten()
        self.setupPay()
        self.setupRootController()
        if JIconManager.share.icon_type == .spring || JIconManager.share.icon_type == .legal || JIconManager.share.icon_type == .boat || JIconManager.share.icon_type == .midAutumn || JIconManager.share.icon_type == .nation {
            let _ = JSpringFlashView.init(frame: UIScreen.main.bounds)
        }
        self.remoteNotiRegister()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if UserInfo.share.token != nil {
            if ChatManager.share.haveTask {
                UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            } else {
                JSocketHelper.share.closeSocket()
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if UserInfo.share.token != nil {
            if !JSocketHelper.share.connecting {
                JSocketHelper.share.connectionSocket()
            }
            if UserInfo.share.wexin_sn != nil {
                JShareManager.share.wechatPayCheck()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: { (dict) in
                let result = dict?["result"] as? String
                var success: Bool = false
                if result != nil && result!.count > 10 {
                    success = true
                }
                JPayApiManager.share.delegate?.jPayApiManagerPayResult(success: success)
            })
        } else if url.host == "pay" || url.host == "oauth" {
            let result = WXApi.handleOpen(url, delegate: JShareManager.share)
            return result
        } else if url.host == "qzapp" {
            let result = TencentOAuth.handleOpen(url)
            return result
        } else if url.host == "response" {
            let result = WeiboSDK.handleOpen(url, delegate: JShareManager.share)
            return result
        } else if url.isFileURL {
            if UserInfo.share.token != nil {
                let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                if data != nil {
                    if data!.count > 1024 * 1024 * 30 {
                        PromptTool.promptText("大小不能超过30M", 1)
                        return true
                    }
//                    let tempStr = (url.absoluteString as NSString).removingPercentEncoding
//                    let fileName = tempStr?.components(separatedBy: CharacterSet.init(charactersIn: "/")).last ?? ""
                    let fileName = url.lastPathComponent
                    let pathExten = (fileName as NSString).pathExtension
                    let prams: NSDictionary = ["msg_file_name":fileName,"msg_file_length":"\(data!.count)"]
                    let model = JSocketModel.init(to: "", sn: "")
                    model.type = socket_value_file
                    model.attribute = prams.mj_JSONString()
                    model.content = OSSManager.initWithShare().uniqueString(by: "chat/files/", pathExten: pathExten)
                    model.j_share_local_full_url = url
                    let vc = JShareMessageController()
                    vc.model = model
                    let nav = BaseNavigationController.init(rootViewController: vc)
                    self.window?.rootViewController?.present(nav, animated: true, completion: nil)
                }
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
}


extension AppDelegate {
    func setupRootController() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        if UserInfo.getStandard(key: standard_first_open) == nil {
            let leadPage = LeadPageController()
            window?.rootViewController = leadPage
        } else {
            if UserInfo.share.token != nil {
                let mainVC = MainTabBarController()
                window?.rootViewController = mainVC
            } else {
//                let vc = LoginController()
                let vc = ChooseRoleController()
                vc.currentNavigationBarAlpha = 0
                let nav = BaseNavigationController.init(rootViewController: vc)
                window?.rootViewController = nav
            }
        }
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate {
    func setupPay() {
        WXApi.registerApp(appKey_wechat)
        let _ = JPayApiManager.share
    }
}

extension AppDelegate {
    func setupExten() {
        Bugly.start(withAppId: appKey_bugly)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func remoteNotiRegister() {
        let application: UIApplication = UIApplication.shared
        application.applicationIconBadgeNumber = 0
        if (NSClassFromString("UNUserNotificationCenter") != nil) {
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                center.requestAuthorization(options: UNAuthorizationOptions(rawValue: UNAuthorizationOptions.alert.rawValue | UNAuthorizationOptions.badge.rawValue | UNAuthorizationOptions.sound.rawValue), completionHandler: { (granted, error) in
                    if granted == true {
                        DispatchQueue.main.async {
                            application.registerForRemoteNotifications()
                        }
                    }
                })
                center.getNotificationSettings(completionHandler: { (settings) in
                    
                })
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var tokenStr = ""
        for i in 0..<deviceToken.count {
            tokenStr += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        DEBUG("推送：" + tokenStr)
        UserInfo.setStandard(key: standard_push_token, text: tokenStr)
    }
}
