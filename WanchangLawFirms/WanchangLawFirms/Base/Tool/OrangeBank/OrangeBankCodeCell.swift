//
//  OrangeBankCodeCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/2.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class OrangeBankCodeCell: BaseCell {
    
    let titleLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    let codeLab: UILabel = UILabel.init(kFontMS, kOrangeDarkColor, NSTextAlignment.left)
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
        self.addSubview(codeLab)
        self.addSubview(tailLab)
        
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.widthIs(90)?.heightIs(20)
        _ = codeLab.sd_layout()?.leftSpaceToView(titleLab, 0)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.heightIs(20)
        _ = tailLab.sd_layout()?.leftSpaceToView(titleLab, 0)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(codeLab, 0)?.bottomSpaceToView(self, 0)
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
