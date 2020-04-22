//
//  JTextView.swift
//  zhirong
//
//  Created by lh on 2017/10/23.
//  Copyright © 2017年 gaming17. All rights reserved.
//

import UIKit

class JTextView: UITextView {
    
    private let placeholderTV = UITextView()
    
    private var _placeholder: String?
    var placeholder: String? {
        set {
            _placeholder = newValue
            placeholderTV.text = _placeholder
        }
        get {
            return _placeholder
        }
    }
    
    override var text: String! {
        didSet {
            placeholderTV.isHidden = self.hasText
        }
    }
    
    convenience init(font: UIFont) {
        self.init()
        self.backgroundColor = UIColor.clear
        
        placeholderTV.font = font
        placeholderTV.textColor = kPlaceholderColor
        placeholderTV.isUserInteractionEnabled = false
        placeholderTV.textContainerInset = UIEdgeInsets.init(top: 8.0, left: -6.0, bottom: 8.0, right: -6.0)
        placeholderTV.backgroundColor = UIColor.clear
        self.addSubview(placeholderTV)
        
        
        self.font = font
        self.textColor = kTextBlackColor
        self.returnKeyType = .done
        self.layoutManager.allowsNonContiguousLayout = false
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
        
        _ = placeholderTV.sd_layout().leftSpaceToView(self, 6)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
        NotificationCenter.default.addObserver(self, selector: #selector(myTextDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func myTextDidChange() {
        self.placeholderTV.isHidden = self.hasText
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
