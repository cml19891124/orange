//
//  InvoiceDataCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/25.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceDataCell: BaseCell {
    
    let titleLab: UILabel = UILabel.init(kFontM, kTextGrayColor, NSTextAlignment.left)
    let tailLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        tailLab.adjustsFontSizeToFitWidth = false
        
        self.addSubview(titleLab)
        self.addSubview(tailLab)
        
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(100)?.heightIs(30)
        _ = tailLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.leftSpaceToView(titleLab, kLeftSpaceS)?.centerYEqualToView(self)?.heightIs(40)
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
