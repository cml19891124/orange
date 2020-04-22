//
//  OrangeBankCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/27.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class OrangeBankCell: BaseCell {
    
    let titleLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    let tailLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    
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
        self.addSubview(tailLab)
        
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(70)?.heightIs(20)
        _ = tailLab.sd_layout()?.leftSpaceToView(titleLab, 0)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, 0)?.bottomSpaceToView(self, 0)
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
