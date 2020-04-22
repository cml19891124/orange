//
//  MineVIPHeadView.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineVIPHeadView: UIView {
    
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imgView.frame = self.bounds
        self.addSubview(imgView)
    }

}
