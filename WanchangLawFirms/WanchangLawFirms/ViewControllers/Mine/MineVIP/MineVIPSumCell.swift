//
//  MineVIPSumCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/9.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineVIPSumCell: BaseCell {
    
    let lab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    let line: UIView = UIView.init(lineColor: kLineGrayColor)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(lab)
        self.addSubview(line)
        _ = lab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.rightSpaceToView(self, kLeftSpaceL)?.topSpaceToView(self, 0)?.bottomSpaceToView(self, 0)
        _ = line.sd_layout()?.leftEqualToView(self)?.bottomEqualToView(self)?.rightEqualToView(self)?.heightIs(kLineHeight)
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
