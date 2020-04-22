//
//  CCCCell.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class CCCCell: BaseCell {
    
    var model: HomeModel! {
        didSet {
            titleLab.text = model.title
            let tempStr = kBtnSpaceString + model.pv
            hotBtn.setTitle(tempStr, for: .normal)
            imgView.sd_setImage(with: URL.init(string: model.urlStr), completed: nil)
        }
    }
    
    private let titleLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFill)
    private let hotBtn: UIButton = UIButton.init(kFontS, kOrangeDarkColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        hotBtn.setImage(UIImage.init(named: "hot_icon"), for: .normal)
        titleLab.adjustsFontSizeToFitWidth = false
        self.addSubview(titleLab)
        self.addSubview(imgView)
        self.addSubview(hotBtn)
        _ = imgView.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.bottomSpaceToView(self, kLeftSpaceS)?.widthIs(80)
        _ = hotBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.bottomSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.heightIs(20)
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(imgView, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.bottomSpaceToView(hotBtn, 0)
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
