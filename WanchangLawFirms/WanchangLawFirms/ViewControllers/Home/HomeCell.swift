//
//  HomeCell.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 首页最新资讯视图
class HomeCell: BaseCell {
    
    var model: HomeModel! {
        didSet {
            titleLab.text = model.title
            let tempStr = kBtnSpaceString + model.pv
            hotBtn.setTitle(tempStr, for: .normal)
            imgView.sd_setImage(with: URL.init(string: model.urlStr), completed: nil)
        }
    }
    
    private let bView: UIView = UIView()
    private let titleLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFill)
    private let hotBtn: UIButton = UIButton.init(kFontS, kOrangeDarkColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = kBaseColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        hotBtn.setImage(UIImage.init(named: "hot_icon"), for: .normal)
        titleLab.adjustsFontSizeToFitWidth = false
        bView.backgroundColor = kCellColor
        self.addSubview(bView)
        bView.addSubview(titleLab)
        bView.addSubview(hotBtn)
        bView.addSubview(imgView)
        _ = bView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topEqualToView(self)?.bottomEqualToView(self)
        _ = imgView.sd_layout()?.rightSpaceToView(bView, kLeftSpaceS)?.topSpaceToView(bView, kLeftSpaceS)?.bottomSpaceToView(bView, kLeftSpaceS)?.widthIs(80)
        _ = hotBtn.sd_layout()?.leftSpaceToView(bView, kLeftSpaceS)?.bottomEqualToView(imgView)?.rightSpaceToView(bView, kLeftSpaceS)?.heightIs(20)
        _ = titleLab.sd_layout()?.leftSpaceToView(bView, kLeftSpaceS)?.rightSpaceToView(imgView, kLeftSpaceS)?.topEqualToView(imgView)?.bottomSpaceToView(hotBtn, kLeftSpaceSS)
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
