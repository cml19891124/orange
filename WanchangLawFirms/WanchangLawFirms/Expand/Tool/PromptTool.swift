//
//  PromptTool.swift
//  zhirong
//
//  Created by lh on 2017/10/19.
//  Copyright © 2017年 gaming17. All rights reserved.
//

import UIKit

class PromptTool: NSObject {
    @objc class func promptText(_ text: Any?, _ time: NSInteger) {
        let text = text as? String
        let view: UIView = ((UIApplication.shared.delegate?.window)!)!
        let prompt = MBProgressHUD.showAdded(to: view, animated: true)
        prompt.isUserInteractionEnabled = false
        prompt.mode = .text
        prompt.label.font = kFontMS
        prompt.label.text = text
        prompt.margin = 10
        prompt.removeFromSuperViewOnHide = true
        prompt.hide(animated: true, afterDelay: TimeInterval(time))
    }
    
    @objc class func promptText(_ text: String) -> MBProgressHUD {
        let view: UIView = ((UIApplication.shared.delegate?.window)!)!
        let prompt = MBProgressHUD.showAdded(to: view, animated: true)
        prompt.isUserInteractionEnabled = false
        prompt.mode = .indeterminate
        prompt.label.font = kFontMS
        prompt.label.text = text
        prompt.margin = 10
        prompt.removeFromSuperViewOnHide = true
        prompt.hide(animated: true, afterDelay: 60)
        return prompt
    }
    
    
}
