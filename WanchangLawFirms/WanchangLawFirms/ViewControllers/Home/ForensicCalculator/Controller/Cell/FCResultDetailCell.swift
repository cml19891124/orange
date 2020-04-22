//
//  FCResultDetailCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/16.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算详情Cell
class FCResultDetailCell: BaseCell {
    
    var model: FCOtherDataModel! {
        didSet {
            let str1 = "\(model.age)岁抚养费金额："
            let str2 = "\(model.total)"
            let str3 = " 元"
            let totalStr = str1 + str2 + str3
            let mulStr = NSMutableAttributedString.init(string: totalStr)
            mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeDarkColor, range: NSRange.init(location: str1.count, length: str2.count))
            lab.attributedText = mulStr
        }
    }
    
    let lab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = kBaseColor
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.rightSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.heightIs(20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
