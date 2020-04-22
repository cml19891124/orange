//
//  MineFeedbackTitleCell.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineFeedbackTitleCell: BaseCell {
    
    let lab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = kBaseColor
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.widthIs(200)?.heightIs(20)
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
