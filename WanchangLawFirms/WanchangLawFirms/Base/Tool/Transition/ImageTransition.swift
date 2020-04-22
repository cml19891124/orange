//
//  ImageTransition.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/1.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ImageTransition: BaseTransition, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if (self.operation == .push) {
            self.pushAnimate(transitionContext: transitionContext)
        } else if (self.operation == .pop) {
            self.popAnimate(transitionContext: transitionContext)
        }
    }
}

extension ImageTransition {
    private func pushAnimate(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.alpha = 0
        UIView.animate(withDuration: duration, animations: {
            toVC.view.alpha = 1
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
    
    private func popAnimate(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        transitionContext.containerView.addSubview(toVC.view)
        transitionContext.containerView.addSubview(fromVC.view)
        UIView.animate(withDuration: duration, animations: {
            fromVC.view.alpha = 0
        }) { (finished) in
            let completed = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(completed)
        }
    }
}
