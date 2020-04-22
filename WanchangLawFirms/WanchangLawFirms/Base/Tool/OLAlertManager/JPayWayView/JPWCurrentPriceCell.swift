//
//  JPWCurrentPriceCell.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JPWCurrentPriceCell: BaseCell {
    
    let lab1: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    let lab2: UILabel = UILabel.init(kFontL, kOrangeDarkColor, NSTextAlignment.right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(lab1)
        self.addSubview(lab2)
        
        _ = lab1.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.widthIs(100)?.heightIs(30)
        _ = lab2.sd_layout()?.rightSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.widthIs(150)?.heightIs(30)
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
