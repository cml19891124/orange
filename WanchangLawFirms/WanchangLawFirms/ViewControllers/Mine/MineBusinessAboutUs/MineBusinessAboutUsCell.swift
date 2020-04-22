//
//  MineBusinessAboutUsCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/21.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineBusinessAboutUsCell: BaseCell {
    
    private let bView: UIView = UIView()
    let headLab: UILabel = UILabel.init(kFontM, customColor(252, 80, 0), NSTextAlignment.left)
    let arrow: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        bView.backgroundColor = kCellColor
        bView.layer.cornerRadius = kBtnCornerR
        arrow.image = UIImage.init(named: "arrow_right_gray")
        self.addSubview(bView)
        bView.addSubview(headLab)
        bView.addSubview(arrow)
        _ = bView.sd_layout()?.leftSpaceToView(self, 30)?.rightSpaceToView(self, 30)?.topEqualToView(self)?.bottomEqualToView(self)
        _ = headLab.sd_layout()?.leftSpaceToView(bView, kLeftSpaceS)?.rightSpaceToView(bView, 50)?.centerYEqualToView(bView)?.heightIs(30)
        _ = arrow.sd_layout()?.rightSpaceToView(bView, kLeftSpaceS)?.centerYEqualToView(bView)?.widthIs(kArrowWH)?.heightIs(kArrowWH)
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
