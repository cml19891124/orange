//
//  MineTailCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineTailCell: MineCell {
    
    let tailLab: UILabel = UILabel.init(kFontMS, kOrangeDarkColor, NSTextAlignment.right)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(tailLab)
        _ = tailLab.sd_layout()?.rightSpaceToView(arrow, 0)?.centerYEqualToView(self)?.widthIs(100)?.heightIs(30)
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
