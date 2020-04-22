//
//  ForensicCalculatorResultCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算结果Cell
class ForensicCalculatorResultCell: BaseCell {
    
    lazy var lab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.center)
        temp.layer.cornerRadius = kBtnCornerR
        temp.layer.borderWidth = 1
        temp.layer.borderColor = kLineGrayColor.cgColor
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, 40)?.rightSpaceToView(self, 40)?.topSpaceToView(self, 0)?.bottomSpaceToView(self, 0)
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
