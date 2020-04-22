//
//  FastDoorRightCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class FastDoorRightCell: FastDoorBaseCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _ = bView.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.rightSpaceToView(self, kLeftSpaceL + 10)?.bottomSpaceToView(self, 0)?.heightIs(106)
        _ = tagLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceL)?.bottomSpaceToView(bView, -34)?.widthIs(54)?.heightIs(54)
        _ = logoBtn.sd_layout()?.rightSpaceToView(bView, 54)?.centerYEqualToView(bView)?.widthIs(56)?.heightIs(56)
        _ = contentLab.sd_layout()?.rightSpaceToView(logoBtn, 5)?.leftSpaceToView(bView, kLeftSpaceL)?.topSpaceToView(bView, kLeftSpaceL)?.bottomSpaceToView(bView, kLeftSpaceL)
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
