//
//  MBBaseCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/15.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBBaseCell: BaseCell {
    
    var bind: String! {
        didSet {
            btn.setImage(UIImage.init(named: bind), for: .normal)
            btn.setTitle(kBtnSpaceString + L$(bind), for: .normal)
        }
    }
    var hideArrow: Bool = false {
        didSet {
            self.arrow.isHidden = hideArrow
            if hideArrow {
                self.arrow.frame = CGRect.init(x: kDeviceWidth, y: 0, width: kArrowWH, height: kArrowWH)
            } else {
                self.arrow.frame = CGRect.init(x: kDeviceWidth - kArrowWH - kLeftSpaceS, y: (kCellHeight - kArrowWH) / 2, width: kArrowWH, height: kArrowWH)
            }
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
        temp.frame = CGRect.init(x: kDeviceWidth, y: 0, width: kArrowWH, height: kArrowWH)
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(btn)
        self.addSubview(arrow)
        
        _ = btn.sd_layout()?.leftSpaceToView(self, kLeftSpaceM)?.centerYEqualToView(self)?.widthIs(180)?.heightIs(30)
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
