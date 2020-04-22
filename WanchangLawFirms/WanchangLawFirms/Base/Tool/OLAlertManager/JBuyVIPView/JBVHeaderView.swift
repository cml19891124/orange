//
//  JBVHeaderView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/15.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JBVHeaderView: UITableViewHeaderFooterView {
    
    private lazy var titleV: JLineLabLineView = {
        () -> JLineLabLineView in
        let temp = JLineLabLineView.init(textColor: kTextBlackColor, font: kFontL, lineColor: kTextBlackColor)
        return temp
    }()
    private let line: UIView = UIView.init(lineColor: kLineGrayColor)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = kCellColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleV.bind = "buy_vip"
        self.addSubview(titleV)
        self.addSubview(line)
        _ = titleV.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(kDeviceWidth - 100)?.heightIs(30)
        _ = line.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.bottomEqualToView(self)?.heightIs(kLineHeight)
    }
    
}
