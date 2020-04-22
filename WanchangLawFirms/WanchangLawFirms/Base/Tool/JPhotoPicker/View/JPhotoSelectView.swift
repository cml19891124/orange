//
//  JPhotoSelectView.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JPhotoSelectView: UIView {
    
    var index: Int = 0 {
        didSet {
            if index > 0 {
                lab.text = "\(index)"
                lab.backgroundColor = bgColor
            } else {
                lab.text = ""
                lab.backgroundColor = UIColor.clear
            }
        }
    }
    var selected: Bool = false
    
    private lazy var lab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init()
        temp.font = UIFont.systemFont(ofSize: 16)
        temp.textAlignment = .center
        temp.textColor = UIColor.white
        temp.layer.borderWidth = 1
        temp.layer.borderColor = UIColor.white.cgColor
        temp.clipsToBounds = true
        return temp
    }()
    private var bgColor: UIColor = UIColor.clear
    
    convenience init(bgColor: UIColor, wh: CGFloat) {
        self.init()
        self.bgColor = bgColor
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = wh / 2
        self.addSubview(lab)
        _ = lab.sd_layout()?.rightSpaceToView(self, 3)?.centerYEqualToView(self)?.widthIs(wh)?.heightIs(wh)
    }

}
