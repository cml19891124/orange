//
//  InvoiceHeadLabCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/26.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceHeadLabCell: InvoiceHeadBaseCell {

    let tailLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        tailLab.adjustsFontSizeToFitWidth = false
        self.addSubview(tailLab)
        _ = tailLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.leftSpaceToView(self.titleLab, 0)?.heightIs(40)
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
