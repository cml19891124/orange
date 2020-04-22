//
//  CCCHeaderView.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class CCCHeaderView: UITableViewHeaderFooterView {
    
    private let spaceV: UIView = UIView()
    lazy var titleBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
        temp.setTitle(kBtnSpaceString + L$("h_hot_case"), for: .normal)
        temp.setImage(UIImage.reminderImage(), for: .normal)
        return temp
    }()
    let line: UIView = UIView.init(lineColor: kLineGrayColor)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = kCellColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        spaceV.backgroundColor = kBaseColor
        self.addSubview(spaceV)
        self.addSubview(titleBtn)
        self.addSubview(line)
        _ = spaceV.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(10)
        _ = titleBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.bottomEqualToView(self)?.widthIs(150)?.heightIs(40)
        _ = line.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(kLineHeight)
    }

}
