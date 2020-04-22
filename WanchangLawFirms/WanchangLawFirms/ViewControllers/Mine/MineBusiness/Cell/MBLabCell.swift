//
//  MBLabCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/10.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBLabCell: MBBaseCell {
    
    let tailLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.btn.titleLabel?.font = kFontMS
        self.addSubview(tailLab)
        _ = tailLab.sd_layout()?.rightSpaceToView(arrow, kLeftSpaceS)?.centerYEqualToView(self)?.leftSpaceToView(btn, kLeftSpaceS)?.heightIs(40)
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
