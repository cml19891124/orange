//
//  MBChooseTitleCollectionReusableView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/25.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBChooseTitleCollectionReusableView: UICollectionReusableView {
    let lab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private let line: UIView = UIView.init(lineColor: kLineGrayColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(lab)
        self.addSubview(line)
        
        _ = lab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(70)?.heightIs(30)
        _ = line.sd_layout()?.leftSpaceToView(lab, 0)?.centerYEqualToView(lab)?.rightSpaceToView(self, kLeftSpaceS)?.heightIs(1)
    }
}
