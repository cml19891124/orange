//
//  FCResultBaseHeaderView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/16.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算结果基类
class FCResultBaseHeaderView: UITableViewHeaderFooterView {
    
    let selBtn: UIButton = UIButton()
    let titleLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    let arrow: UIButton = UIButton.init(kFontS, kTextBlackColor, UIControl.ContentHorizontalAlignment.right, nil, nil)
    let trailLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
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
        selBtn.setImage(UIImage.init(named: "check_right_gray"), for: .normal)
        selBtn.setImage(UIImage.init(named: "check_right_orange"), for: .selected)
        arrow.setImage(UIImage.init(named: "arrow_right_gray"), for: .normal)
        self.addSubview(selBtn)
        self.addSubview(titleLab)
        self.addSubview(trailLab)
        self.addSubview(arrow)
        self.addSubview(line)
        _ = selBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(30)?.heightIs(30)
        _ = titleLab.sd_layout()?.leftSpaceToView(selBtn, 0)?.centerYEqualToView(self)?.rightSpaceToView(self,150)?.heightIs(30)
        _ = trailLab.sd_layout()?.rightSpaceToView(self, 30)?.centerYEqualToView(self)?.leftSpaceToView(titleLab, 10)?.heightIs(40)
        _ = arrow.sd_layout()?.rightSpaceToView(self, kLeftSpaceM)?.centerYEqualToView(self)?.widthIs(kArrowWH)?.heightIs(kArrowWH)
        _ = line.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.bottomEqualToView(self)?.heightIs(kLineHeight)
    }
    
}
