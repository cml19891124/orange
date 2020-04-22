//
//  PCMHeaderView.swift
//  OLegal
//
//  Created by lh on 2018/11/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会面咨询头部视图
class PCMHeaderView: UITableViewHeaderFooterView {
    
    var bind: String! {
        didSet {
            if bind == "h_meet_data" {
                titleBtn.setImage(UIImage.reminderImage(), for: .normal)
            } else {
                titleBtn.setImage(UIImage.init(named: bind), for: .normal)
            }
            titleBtn.setTitle(kBtnSpaceString + L$(bind), for: .normal)
        }
    }

    private let line1: UIView = UIView.init(lineColor: kLineGrayColor)
    private let line2: UIView = UIView.init(lineColor: kLineGrayColor)
    private let titleBtn: UIButton = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = kCellColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(line1)
        self.addSubview(line2)
        self.addSubview(titleBtn)
        _ = line1.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topEqualToView(self)?.heightIs(kLineHeight)
        _ = line2.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.bottomEqualToView(self)?.heightIs(kLineHeight)
        _ = titleBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.rightSpaceToView(self, kLeftSpaceL)?.heightIs(30)
    }
    
}
