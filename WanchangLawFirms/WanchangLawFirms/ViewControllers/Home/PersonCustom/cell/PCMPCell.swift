//
//  PCMPCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/13.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会面咨询预览Cell
class PCMPCell: BaseCell {
    
    let lab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, 50)?.rightSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.heightIs(30)
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
