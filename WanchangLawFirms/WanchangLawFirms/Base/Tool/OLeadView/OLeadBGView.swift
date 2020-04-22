//
//  OLeadBGView.swift
//  WanchangLawFirms
//
//  Created by szcy on 2019/9/30.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class OLeadBGView: UIView {

    convenience init(supView: UIView) {
        self.init(frame: UIScreen.main.bounds)
        supView.addSubview(self)
    }
    
    
    func drawCircle(rect: CGRect) {
        self.layer.sublayers?.last?.removeFromSuperlayer()
        let path = UIBezierPath.init(roundedRect: UIScreen.main.bounds, cornerRadius: 0)
        let circlePath = UIBezierPath.init(roundedRect: rect, cornerRadius: rect.size.width / 2)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.8
        self.layer.addSublayer(fillLayer)
    }

}
