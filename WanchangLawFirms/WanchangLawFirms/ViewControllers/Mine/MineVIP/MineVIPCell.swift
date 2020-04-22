//
//  MineVIPCell.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineVIPCell: BaseCell {
    
    var bind: String! {
        didSet {
            imgBtn.setImage(UIImage.init(named: bind), for: .normal)
            self.titleLab.text = RemindersManager.share.remindTitle(bind: bind)
            desLab.text = RemindersManager.share.reminders(bind: bind)
        }
    }
    
//    let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    let imgBtn: UIButton = UIButton()
    let titleLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    let desLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    let line: UIView = UIView.init(lineColor: kLineGrayColor)
    let lineV: UIView = UIView.init(lineColor: kLineGrayColor)
    
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
        self.addSubview(desLab)
        self.addSubview(line)
        self.addSubview(lineV)
        
        _ = imgBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.topSpaceToView(self, kLeftSpaceS)?.widthIs(40)?.heightIs(40)
        _ = titleLab.sd_layout()?.leftSpaceToView(imgBtn, 0)?.topSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceL)?.heightIs(30)
        _ = desLab.sd_layout()?.leftEqualToView(titleLab)?.rightEqualToView(titleLab)?.topSpaceToView(titleLab, 0)?.bottomSpaceToView(self, kLeftSpaceS)
        _ = line.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(kLineHeight)
        _ = lineV.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.rightSpaceToView(self, kLeftSpaceL)?.bottomEqualToView(self)?.heightIs(kLineHeight)
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
