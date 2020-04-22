//
//  ConsultMeetTypeCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/6.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ConsultMeetTypeCell: BaseCell {

    var bind: String = "" {
        didSet {
            imgBtn.setImage(UIImage.init(named: bind + "_detail"), for: .normal)
        }
    }
    var title: String = ""
    var subTitle: String = "" {
        didSet {
            let str1 = title + "\n"
            let str2 = subTitle
            let totalStr = str1 + str2
            let mulStr = NSMutableAttributedString.init(string: totalStr)
            mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kTextGrayColor, range: NSRange.init(location: str1.count, length: str2.count))
            mulStr.addAttribute(NSAttributedString.Key.font, value: kFontMS, range: NSRange.init(location: str1.count, length: str2.count))
            titleLab.attributedText = mulStr
        }
    }
    
    private lazy var imgBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
        return temp
    }()
    private let titleLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    private let line1: UIView = UIView.init(lineColor: kLineGrayColor)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.addSubview(imgBtn)
        self.addSubview(titleLab)
        self.addSubview(line1)
        
        _ = imgBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(40)?.heightIs(40)
        _ = titleLab.sd_layout()?.leftSpaceToView(imgBtn, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceSS)?.bottomSpaceToView(self, kLeftSpaceSS)
        _ = line1.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(kLineHeight)
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
