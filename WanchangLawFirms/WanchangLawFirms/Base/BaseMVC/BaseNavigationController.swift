//
//  BaseNavigationController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/1.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 导航控制器
class BaseNavigationController: LHNavigationController {

    private var transitionType = TransitionType.system
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.backgroundImage = UIImage.navImage()
        let bar = UINavigationBar.appearance()
        bar.tintColor = UIColor.white
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: kFontL]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: kFontMS], for: UIControl.State.normal)
    }

}

extension BaseNavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true
            let bvc = viewController as? BaseController
            if bvc != nil {
                self.pushDeal(bvc: bvc!)
            } else {
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(didClickBack))
                viewController.navigationItem.hidesBackButton = true
            }
        }
        return super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let bvc = self.topViewController as? BaseController
        if (bvc != nil) {
            self.transitionType = bvc!.transitionType
        } else {
            self.transitionType = .system
        }
        return super.popViewController(animated: animated)
    }
    
    private func pushDeal(bvc: BaseController) {
        transitionType = bvc.transitionType
        if transitionType == .image {
            self.popGestureDisabled = true
            bvc.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: nil, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        } else {
            bvc.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(didClickBack))
        }
    }
    
    @objc private func didClickBack() {
        _ = self.popViewController(animated: true)
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (self.transitionType == .image) {
            return ImageTransition.init(operation: operation)
        } else if (self.transitionType == .article) {
            return ArticleTransition.init(operation: operation)
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let bvc = viewController as? BaseController else {
            self.transitionType = .system
            self.popGestureDisabled = false
            return
        }
        transitionType = bvc.transitionType
        if transitionType == .image {
            self.popGestureDisabled = true
        } else {
            self.popGestureDisabled = false
        }
    }
}
