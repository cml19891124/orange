//
//  FastDoorBaseCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class FastDoorBaseCell: UITableViewCell {
    
    var bView: UIView = UIView()
    var tagLab: UILabel = UILabel.init(kFontXL, UIColor.white, NSTextAlignment.center)
    var logoBtn: UIButton = UIButton()
    var contentLab: UILabel = UILabel.init(kFontMS, customColor(101, 101, 101), NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.baseSetupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseSetupViews() {
        logoBtn.isUserInteractionEnabled = false
        bView.layer.cornerRadius = 20
        bView.backgroundColor = customColor(254, 249, 245)
        tagLab.backgroundColor = customColor(239, 107, 0)
        tagLab.layer.borderColor = customColor(239, 106, 1).cgColor
        tagLab.layer.borderWidth = 1
        tagLab.layer.cornerRadius = 27
        tagLab.clipsToBounds = true
        
        self.addSubview(bView)
        self.addSubview(tagLab)
        bView.addSubview(logoBtn)
        bView.addSubview(contentLab)
        
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
