//
//  JNetAdaptImgView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/24.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JNetAdaptImgView: UIImageView {

    var end_height: CGFloat = 0
    
    convenience init(referenceWidth: CGFloat, referenceHeight: CGFloat, end_width: CGFloat) {
        self.init()
        self.contentMode = .scaleAspectFill
        self.end_height = end_width * (referenceHeight / referenceWidth)
    }

}
