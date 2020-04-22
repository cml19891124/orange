//
//  MainTabBarController.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//_appearanceContainer

import UIKit

class MainTabBarController: UITabBarController {

    let homeVC = HomeController()
    let msgVC = MessageController()
    let mineVC = MineController()
    let tB = MyTabBar.init(frame: CGRect.init(x: 0, y: kDeviceHeight - kTabBarHeight - kXBottomHeight, width: kDeviceWidth, height: kTabBarHeight - kXBottomHeight))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupItem()
        self.setupChildVCs()
        tB.m_delegate = self
        self.setValue(tB, forKey: "tabBar")
        NotificationCenter.default.addObserver(self, selector: #selector(jumpToChat), name: NSNotification.Name(rawValue: noti_jump_to_chat), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unReadCount), name: NSNotification.Name(rawValue: noti_dealing_msg_need_refresh), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backClick), name: NSNotification.Name(rawValue: noti_tourist_back), object: nil)
    }
    
    @objc private func unReadCount() {
        tB.msgView.msgCount = UserInfo.share.conversationMsgUnReadCount
    }
    
    @objc private func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupItem() -> Void {
        let normalAttrs = NSMutableDictionary()
        normalAttrs[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 12)
        normalAttrs[NSAttributedString.Key.foregroundColor] = kOrangeLightColor
        
        let selectedAttrs = NSMutableDictionary()
        selectedAttrs[NSAttributedString.Key.foregroundColor] = kOrangeDarkColor
        
        switch JIconManager.share.icon_type {
        case .spring:
            selectedAttrs[NSAttributedString.Key.foregroundColor] = kSpringColor
            self.tB.tintColor = kSpringColor
            break
        case .legal:
            selectedAttrs[NSAttributedString.Key.foregroundColor] = kSpringColor
            self.tB.tintColor = kSpringColor
            break
        case .boat:
            normalAttrs[NSAttributedString.Key.foregroundColor] = kTextGrayColor
            selectedAttrs[NSAttributedString.Key.foregroundColor] = kSpringColor
            self.tB.tintColor = kSpringColor
            break
        case .midAutumn:
            normalAttrs[NSAttributedString.Key.foregroundColor] = kTextGrayColor
            selectedAttrs[NSAttributedString.Key.foregroundColor] = kSpringColor
            self.tB.tintColor = kSpringColor
            break
        case .nation:
            normalAttrs[NSAttributedString.Key.foregroundColor] = kTextGrayColor
            selectedAttrs[NSAttributedString.Key.foregroundColor] = kSpringColor
            self.tB.tintColor = kSpringColor
            break
        default:
            selectedAttrs[NSAttributedString.Key.foregroundColor] = kOrangeDarkColor
            self.tB.tintColor = kOrangeDarkColor
            break
        }
        let item = UITabBarItem.appearance()
        item.setTitleTextAttributes(normalAttrs as? [NSAttributedString.Key : Any], for: .normal)
        item.setTitleTextAttributes(selectedAttrs as? [NSAttributedString.Key : Any], for: .selected)
    }
    
    private func setupChildVCs() -> Void {
        self.setupChildVC(homeVC, "home", "tab_home_default", "tab_home_selected")
        self.setupChildVC(msgVC, "", "", "")
        if UserInfo.share.is_business {
            self.setupChildVC(mineVC, "business", "tab_mine_default", "tab_mine_selected")
        } else {
            self.setupChildVC(mineVC, "mine", "tab_mine_default", "tab_mine_selected")
        }
    }
    
    private func setupChildVC(_ vc: UIViewController, _ title: String, _ image: String, _ selectedImge: String) -> Void {
//        if title != "" {
//            vc.currentNavigationBarAlpha = 0
//        }
        if title == "home" {
            vc.currentNavigationBarAlpha = 0
        }
        let nav = BaseNavigationController.init(rootViewController: vc)
        
        self.addChild(nav)
        nav.tabBarItem.title = L$(title)
        if image.count > 0 {
            nav.tabBarItem.image = UIImage.init(named: JIconManager.share.getIcon(bind: image))?.withRenderingMode(.alwaysOriginal)
            nav.tabBarItem.selectedImage = UIImage.init(named: JIconManager.share.getIcon(bind: selectedImge))?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    deinit {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_tab_back), object: nil)
    }

}

extension MainTabBarController {
    @objc func jumpToChat() {
        JQueueManager.share.mainAsyncQueue {
            self.selectedIndex = 1
            let vc = ChatController()
            self.msgVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainTabBarController: MyTabBarDelegate {
    func myTabBarCenterClick() {
        self.selectedIndex = 1
    }
}
