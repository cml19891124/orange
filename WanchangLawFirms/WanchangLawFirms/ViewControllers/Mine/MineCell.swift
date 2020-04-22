//
//  MineCell.swift
//  OLegal
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我的Cell基类
class MineCell: BaseCell {
    
    var bind: String! {
        didSet {
            btn.setImage(UIImage.init(named: bind), for: .normal)
            btn.setTitle(kBtnSpaceString + L$(bind), for: .normal)
        }
    }
    
    lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
        return temp
    }()
    lazy var arrow: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.right, nil, nil)
        temp.setImage(UIImage.init(named: "arrow_right_gray"), for: .normal)
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(btn)
        self.addSubview(arrow)
        
        _ = btn.sd_layout()?.leftSpaceToView(self, kLeftSpaceM)?.centerYEqualToView(self)?.widthIs(180)?.heightIs(30)
        _ = arrow.sd_layout()?.rightSpaceToView(self, kLeftSpaceM)?.centerYEqualToView(self)?.widthIs(kArrowWH)?.heightIs(kArrowWH)
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
