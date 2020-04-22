//
//  ArticleTransition.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/2.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ArticleTransition: BaseTransition, UIViewControllerAnimatedTransitioning {
    
    private var smallCenter: CGPoint {
        get {
            return ArticleManager.share.logoImgView.center
        }
    }
    private var smallRaidus: CGFloat {
        get {
            return ArticleManager.share.logoImgView.bounds.size.width / 2
        }
    }
    private let bigCenter = CGPoint.init(x: kDeviceWidth / 2, y: kDeviceHeight / 2)
    private let bigRadius = CGFloat(sqrtf(Float(kDeviceWidth * kDeviceWidth + kDeviceHeight * kDeviceHeight)) / 2)
    
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

extension ArticleTransition {
    private func pushAnimate(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        transitionContext.containerView.addSubview(toVC.view)
        
        let startCycle = UIBezierPath.init(arcCenter: smallCenter, radius: smallRaidus, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let endCycle = UIBezierPath.init(arcCenter: bigCenter, radius: bigRadius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = endCycle.cgPath
        toVC.view.layer.mask = maskLayer
        let maskLayerAnimation = CABasicAnimation.init(keyPath: "path")
        maskLayerAnimation.delegate = self
        maskLayerAnimation.fromValue = startCycle.cgPath
        maskLayerAnimation.toValue = endCycle.cgPath
        maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        maskLayerAnimation.setValue(transitionContext, forKey: "transitionContext")
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
    private func popAnimate(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        transitionContext.containerView.addSubview(toVC.view)
        transitionContext.containerView.addSubview(fromVC.view)
        
        let startCycle = UIBezierPath.init(arcCenter: bigCenter, radius: bigRadius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let endCycle = UIBezierPath.init(arcCenter: smallCenter, radius: smallRaidus, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = endCycle.cgPath
        fromVC.view.layer.mask = maskLayer
        let maskLayerAnimation = CABasicAnimation.init(keyPath: "path")
        maskLayerAnimation.delegate = self
        maskLayerAnimation.fromValue = startCycle.cgPath
        maskLayerAnimation.toValue = endCycle.cgPath
        maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        maskLayerAnimation.setValue(transitionContext, forKey: "transitionContext")
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
}

extension ArticleTransition: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let transitionContext = anim.value(forKey: "transitionContext") as? UIViewControllerContextTransitioning else {
            return
        }
        if operation == .push {
            transitionContext.completeTransition(true)
        } else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled {
                transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
            }
        }
    }
}
