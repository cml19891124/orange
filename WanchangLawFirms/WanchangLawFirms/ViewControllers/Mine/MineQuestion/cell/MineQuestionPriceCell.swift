//
//  MineQuestionPriceCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineQuestionPriceCell: BaseCell {
    
    let titleLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    let priceLab: UILabel = UILabel.init(kFontM, kOrangeDarkColor, NSTextAlignment.right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(titleLab)
        self.addSubview(priceLab)
        
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(150)?.heightIs(20)
        _ = priceLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(150)?.heightIs(30)
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
