//
//  CLSQuestionTitleCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/17.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class CLSQuestionTitleCell: BaseCell {
    
    let lab: UILabel = UILabel.init(UserInfo.share.chatFont, kTextBlackColor, NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, 0)?.rightSpaceToView(self, 0)?.topSpaceToView(self, 0)?.bottomSpaceToView(self, 0)
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
