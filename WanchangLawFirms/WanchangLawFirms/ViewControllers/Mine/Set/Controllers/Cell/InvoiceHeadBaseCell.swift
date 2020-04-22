//
//  InvoiceHeadBaseCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/26.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceHeadBaseCell: BaseCell {
    
    let titleLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLab)
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(120)?.heightIs(30)
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
