//
//  MBVCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/27.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBVCell: BaseCell {
    
    let circleLab: UILabel = UILabel.init(kFontXXL, kTextGrayColor, NSTextAlignment.center)
    let lab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        circleLab.backgroundColor = kTextBlackColor
        circleLab.layer.cornerRadius = 2
        circleLab.clipsToBounds = true
        self.addSubview(circleLab)
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomEqualToView(self)
        _ = circleLab.sd_layout()?.leftSpaceToView(self, -10)?.topSpaceToView(self, 6)?.widthIs(4)?.heightIs(4)
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
