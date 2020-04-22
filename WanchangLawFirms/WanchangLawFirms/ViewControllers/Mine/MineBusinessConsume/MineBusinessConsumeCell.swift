//
//  MineBusinessConsumeCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/17.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineBusinessConsumeCell: BaseCell {
    
    var model: MineConsumeModel! {
        didSet {
            titleLab.text = model.title
            timeLab.text = model.created_at.theDateYMDStr()
            priceLab.text = "¥" + model.discount
            let titleStr = model.title as NSString
            if titleStr.contains("会员") {
                let nowTimeStr = model.created_at.theDateYMDPointSeparateStr()
                let arr = nowTimeStr.components(separatedBy: CharacterSet.init(charactersIn: "."))
                let t1 = arr.first
                if t1 != nil {
                    let t2 = Int(t1!)
                    if t2 != nil {
                        let t3 = t2! + 1
                        let str = "\(t3)"
                        let resultStr = (nowTimeStr as NSString).replacingOccurrences(of: t1!, with: str)
                        expireLab.text = "有效期：" + nowTimeStr + "-" + resultStr
                    }
                }
            } else {
                expireLab.text = "消费性服务"
            }
        }
    }
    
    private let titleLab: UILabel = UILabel.init(kFontM, kOrangeDarkColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
    private let expireLab: UILabel = UILabel.init(kFontS, kOrangeLightColor, NSTextAlignment.left)
    private let priceLab: UILabel = UILabel.init(kFontXL, kOrangeLightColor, NSTextAlignment.right)
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
        self.addSubview(timeLab)
        self.addSubview(expireLab)
        self.addSubview(priceLab)
        
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, 10)?.rightSpaceToView(self, 100)?.heightIs(30)
        _ = timeLab.sd_layout()?.centerYEqualToView(titleLab)?.rightSpaceToView(self, kLeftSpaceS)?.widthIs(100)?.heightIs(20)
        _ = priceLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(timeLab, 0)?.widthIs(100)?.heightIs(40)
        _ = expireLab.sd_layout()?.bottomEqualToView(priceLab)?.leftEqualToView(titleLab)?.rightSpaceToView(self, 100)?.heightIs(32)
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
