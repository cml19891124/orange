//
//  ChatImageTransition.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/16.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

enum ChatImageTransitionType {
    case present
    case dismiss
}

class ChatImageTransition: NSObject {
    
    private var type: ChatImageTransitionType
    private var rect: CGRect
    
    private var smallCenter: CGPoint {
        get {
            return CGPoint.init(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
        }
    }
    private var smallRaidus: CGFloat {
        get {
            if Int(rect.width) == Int(rect.height) {
                return rect.width / 2
            }
            return CGFloat(sqrtf(Float(rect.width * rect.width + rect.height * rect.height)) / 2)
        }
    }
    private let bigCenter = CGPoint.init(x: kDeviceWidth / 2, y: kDeviceHeight / 2)
    private let bigRadius = CGFloat(sqrtf(Float(kDeviceWidth * kDeviceWidth + kDeviceHeight * kDeviceHeight)) / 2)
    
    init(type: ChatImageTransitionType, rect: CGRect) {
        self.type = type
        self.rect = rect
        super.init()
    }

}

extension ChatImageTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if type == .present {
            self.presentAnimation(transitionContext: transitionContext)
        } else {
            self.dismissAnimation(transitionContext: transitionContext)
        }
    }
}

extension ChatImageTransition {
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
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
    
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
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

extension ChatImageTransition: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let transitionContext = anim.value(forKey: "transitionContext") as? UIViewControllerContextTransitioning else {
            return
        }
        if type == .present {
            transitionContext.completeTransition(true)
        } else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled {
                transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
            }
        }
    }
}
