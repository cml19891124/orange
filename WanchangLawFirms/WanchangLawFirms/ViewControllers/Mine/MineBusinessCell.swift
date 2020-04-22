//
//  MineBusinessCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/10.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 我的企业cell
class MineBusinessCell: MineCell {
    
    private let tailLab: UILabel = UILabel.init(kFontMS, kOrangeDarkColor, NSTextAlignment.right)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(tailLab)
        _ = tailLab.sd_layout()?.rightSpaceToView(arrow, 5)?.centerYEqualToView(self)?.widthIs(100)?.heightIs(30)
        self.refresh()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: noti_business_refresh), object: nil)
    }
    
    @objc private func refresh() {
        let tempStr = UserInfo.share.businessModel?.show_title ?? "企业认证"
        btn.setTitle(kBtnSpaceString + tempStr, for: .normal)
        btn.setImage(UIImage.init(named: "mine_business"), for: .normal)
        tailLab.text = L$("m_business_checking")
        if UserInfo.share.businessModel?.status == "0" {
            tailLab.isHidden = false
        } else {
            tailLab.isHidden = true
        }
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
