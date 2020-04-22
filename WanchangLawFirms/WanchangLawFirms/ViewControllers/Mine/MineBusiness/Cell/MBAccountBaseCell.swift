//
//  MBAccountBaseCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/18.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBAccountBaseCell: BaseCell {
    
    var bind: String! {
        didSet {
            headLab.text = L$(bind)
        }
    }
    
    var hideArrow: Bool = false {
        didSet {
            self.arrow.isHidden = hideArrow
            if hideArrow {
                self.arrow.frame = CGRect.init(x: kDeviceWidth, y: 0, width: kArrowWH, height: kArrowWH)
            } else {
                self.arrow.frame = CGRect.init(x: kDeviceWidth - kArrowWH - kLeftSpaceS, y: (kCellHeight - kArrowWH) / 2, width: kArrowWH, height: kArrowWH)
            }
        }
    }
    
    let headLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    let arrow: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.arrow.frame = CGRect.init(x: kDeviceWidth, y: 0, width: kArrowWH, height: kArrowWH)
        self.arrow.image = UIImage.init(named: "arrow_right_gray")
        self.addSubview(headLab)
        self.addSubview(arrow)
        _ = headLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(80)?.heightIs(30)
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
