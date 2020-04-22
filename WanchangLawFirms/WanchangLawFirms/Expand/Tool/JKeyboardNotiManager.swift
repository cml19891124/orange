//
//  JKeyboardNotiManager.swift
//  OLegal
//
//  Created by lh on 2018/11/26.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JKeyboardNotiManagerDelegate: NSObjectProtocol {
    func jkeyboardHeightChange(kH: CGFloat, duration: Double)
    func jkeyboardWillHide(kH: CGFloat, duration: Double)
}

/// 键盘监听
class JKeyboardNotiManager: NSObject {
    
    static let share = JKeyboardNotiManager()
    
    weak var delegate: JKeyboardNotiManagerDelegate?
    
    override init() {
        super.init()
        self.addNotification()
    }

}

extension JKeyboardNotiManager {
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(note:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillChange(note: Notification) {
        let userInfo = note.userInfo! as NSDictionary
        let keyboardFrame = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! CGRect
        let keyboardDuration = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double
        let kH = keyboardFrame.size.height
        self.delegate?.jkeyboardHeightChange(kH: kH, duration: keyboardDuration)
    }
    
    @objc private func keyboardWillHide(_ note: Notification) {
        let userInfo = note.userInfo! as NSDictionary
        let keyboardFrame = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! CGRect
        let keyboardDuration = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double
        let kH = keyboardFrame.size.height
        self.delegate?.jkeyboardWillHide(kH: kH, duration: keyboardDuration)
    }
    
}
