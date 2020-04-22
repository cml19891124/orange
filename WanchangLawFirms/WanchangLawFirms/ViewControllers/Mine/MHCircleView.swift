//
//  MHCircleView.swift
//  OLegal
//
//  Created by lh on 2018/11/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 头像白圈
class MHCircleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let w: CGFloat = self.frame.size.width
        for i in 0...3 {
            let j = CGFloat(4 - i)
            let space = CGFloat(10 - i * 2)
            
            let wh: CGFloat = w + space * j
            let v = UIView.init(frame: CGRect.init(x: -space / 2 * j, y: -space / 2 * j, width: wh, height: wh))
            v.layer.cornerRadius = wh / 2
            v.backgroundColor = UIColor.init(white: 1, alpha: 0.15 * CGFloat(i + 1))
            self.addSubview(v)
        }
    }

}
