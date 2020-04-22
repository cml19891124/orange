//
//  BaseController.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 控制器基类，所有的控制器视图均继承自UIViewController
class BaseController: UIViewController {
    var transitionType: TransitionType = TransitionType.system
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kBaseColor
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    deinit {
        DEBUG("deinit")
    }

}
