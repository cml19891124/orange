//
//  MyTabBar.swift
//  Stormtrader
//
//  Created by lh on 2018/11/20.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol MyTabBarDelegate: NSObjectProtocol {
    func myTabBarCenterClick()
}

class MyTabBar: UITabBar {
    
    weak var m_delegate: MyTabBarDelegate?
    private lazy var per_w: CGFloat = {
        () -> CGFloat in
        return self.width / 3
    }()
    
    lazy var msgView: MyTabMsgView = {
        () -> MyTabMsgView in
        let temp = MyTabMsgView.init(frame: CGRect.init(x: per_w, y: 0, width: per_w, height: self.height))
        temp.isUserInteractionEnabled = false
        self.addSubview(temp)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.msgView.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let vv = super.hitTest(point, with: event)
        if vv == nil {
            if self.isHidden == false {
                let x1 = kDeviceWidth / 2 - 30
                let x2 = kDeviceWidth / 2 + 30
                if point.x > x1 && point.x < x2 && point.y > -20 {
                    self.m_delegate?.myTabBarCenterClick()
                    return msgView
                }
            }
        }
        return vv
    }
    
    /// 此处修改UITabbar的hidesBottomWhenPushed的转场动画，发生在点击浮窗浏览文章时
    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == "position" {
            if ArticleManager.share.showModel != nil {
                if layer.position.x < 0 {
                    let pushFromTop = CATransition()
                    pushFromTop.duration = 0.25
                    pushFromTop.timingFunction = CAMediaTimingFunction.init(name: .easeIn)
                    pushFromTop.type = CATransitionType.push
                    pushFromTop.subtype = CATransitionSubtype.fromTop
                    return pushFromTop
                } else if layer.position.x > 0 && layer.position.y > layer.bounds.size.height && layer.position.y < UIScreen.main.bounds.size.height {
                    let pushFromBottom = CATransition()
                    pushFromBottom.duration = 0.25
                    pushFromBottom.timingFunction = CAMediaTimingFunction.init(name: .easeIn)
                    pushFromBottom.type = CATransitionType.push
                    pushFromBottom.subtype = CATransitionSubtype.fromBottom
                    return pushFromBottom
                }
            }
        }
        return super.action(for: layer, forKey: event)
    }
    
}
