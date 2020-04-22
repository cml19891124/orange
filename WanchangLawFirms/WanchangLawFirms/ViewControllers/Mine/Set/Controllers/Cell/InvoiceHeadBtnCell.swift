//
//  InvoiceHeadBtnCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/26.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceHeadBtnCell: InvoiceHeadBaseCell {
    
    let tailBtn: HImgRightAlignmentBtn = HImgRightAlignmentBtn.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.right, nil, nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        tailBtn.setTitle("增值税普通发票", for: .normal)
//        tailBtn.setImage(UIImage.init(named: "arrow_right_gray"), for: .normal)
        self.addSubview(tailBtn)
        _ = tailBtn.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.leftSpaceToView(titleLab, 0)?.heightIs(30)
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
