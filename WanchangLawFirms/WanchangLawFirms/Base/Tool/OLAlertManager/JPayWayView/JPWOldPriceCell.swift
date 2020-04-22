//
//  JPWOldPriceCell.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JPWOldPriceCell: BaseCell {
    
    var oldPrice: String? {
        didSet {
            guard let price = oldPrice else {
                return
            }
            let str1 = "  原价："
            let str2 = "¥" + price
            lab1.text = str1
            lab2.text = str2
            
            let w1 = lab1.sizeThatFits(CGSize.init(width: kDeviceWidth, height: 30)).width
            let w2 = lab2.sizeThatFits(CGSize.init(width: kDeviceWidth, height: 30)).width + kLeftSpaceS
            
            _ = line1.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.widthIs(w1)?.heightIs(1)
            _ = line2.sd_layout()?.rightSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.widthIs(w2)?.heightIs(1)
        }
    }
    
    var id: String? {
        didSet {
            guard let temp = id else {
                return
            }
            let str1 = "订单名称"
            let str2 = HomeManager.share.bindById(id: temp)
            lab1.text = str1
            lab2.text = L$(str2)
        }
    }
    
    private let lab1: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private let lab2: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.right)
    private let line1: UIView = UIView.init(lineColor: kTextGrayColor)
    private let line2: UIView = UIView.init(lineColor: kTextGrayColor)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(lab1)
        self.addSubview(lab2)
        self.addSubview(line1)
        self.addSubview(line2)
        
        _ = lab1.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.widthIs(100)?.heightIs(30)
        _ = lab2.sd_layout()?.rightSpaceToView(self, kLeftSpaceL + 5)?.centerYEqualToView(self)?.widthIs(150)?.heightIs(30)
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
