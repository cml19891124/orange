//
//  JNavConnectImgView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JNavConnectImgView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        let gradeLayer = CAGradientLayer.init(frame: self.bounds, startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 0, y: 1), colors: [kNavGradeEndColor, kViewGradeEndColor])
        self.layer.addSublayer(gradeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
