//
//  ForensicCalculatorTitleCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算器标题
class ForensicCalculatorTitleCell: BaseCell {
    
    var bind: String! {
        didSet {
            vv.bind = bind
        }
    }
    
    private let vv: JLineLabLineView = JLineLabLineView.init(textColor: kTextBlackColor, font: kFontMS, lineColor: kTextBlackColor)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(vv)
        _ = vv.sd_layout()?.leftSpaceToView(self, 40)?.rightSpaceToView(self, 40)?.centerYEqualToView(self)?.heightIs(30)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
