//
//  ChatImageTransitionPercent.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/25.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ChatImageTransitionPercent: UIPercentDrivenInteractiveTransition {
    static let share = ChatImageTransitionPercent()
    
    weak var navigation: UINavigationController?
    
    private var isInteraction: Bool = false
    private var isPop: Bool = false
    private var rect: CGRect = CGRect()
    
    private var b_pop: ChatImageTransition {
        get {
            return ChatImageTransition.init(type: .dismiss, rect: rect)
        }
    }
    private var b_push: ChatImageTransition {
        get {
            return ChatImageTransition.init(type: .present, rect: rect)
        }
    }
    
    
    func addPanGestureIn(vv: UIView, rect: CGRect) {
        self.rect = rect
        vv.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(gesture:)))
        vv.addGestureRecognizer(pan)
    }
    
}

extension ChatImageTransitionPercent {
    @objc private func panAction(gesture: UIPanGestureRecognizer) {
        let rate = gesture.translation(in: UIApplication.shared.keyWindow).x / UIScreen.main.bounds.size.width
        let velocity = gesture.velocity(in: UIApplication.shared.keyWindow).x
        switch gesture.state {
        case .began:
            isInteraction = true
            self.navigation?.popViewController(animated: true)
            
            break
        case .changed:
            isInteraction = false
            self.update(rate)
            break
        case .ended:
            isInteraction = false
            if rate >= 0.4 {
                self.finish()
            } else {
                if velocity > 1000 {
                    self.finish()
                } else {
                    self.cancel()
                }
            }
            break
        default:
            isInteraction = false
            self.cancel()
            break
        }
    }
}

extension ChatImageTransitionPercent: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteraction ? isPop ? self : nil : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var obj: UIViewControllerAnimatedTransitioning?
        if operation == .pop {
            isPop = true
            obj = b_pop
        } else if operation == .push {
            isPop = false
            obj = b_push
        }
        return obj
    }
}
