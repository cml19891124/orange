//
//  MBImgCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/10.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBImgCell: MBBaseCell {
    
    var type: Int = 0 {
        didSet {
            if type == 0 {
                tailLab.text = "点击上传图片"
                tailLab.backgroundColor = kOrangeDarkColor
                tailLab.textColor = UIColor.white
                tailLab.textAlignment = .center
                tailLab.layer.cornerRadius = kBtnCornerR
            } else if type == 1 {
                tailLab.text = "已上传"
                tailLab.backgroundColor = UIColor.clear
                tailLab.textColor = kTextGrayColor
                tailLab.textAlignment = .right
            }
        }
    }
    
    private let tailLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.hideArrow = true
        self.btn.titleLabel?.font = kFontMS
        self.addSubview(tailLab)
        _ = tailLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(90)?.heightIs(25)
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
        if type == 0 {
            tailLab.backgroundColor = kOrangeDarkColor
        }

        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if type == 0 {
            tailLab.backgroundColor = kOrangeDarkColor
        }
    }

}
