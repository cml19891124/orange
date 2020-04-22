//
//  MBVOLCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/4/5.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBVOLCell: BaseCell {
    
    var model: MessageModel! {
        didSet {
            var tempStr = ""
            if model.vip_id == "1" {
                tempStr = "黄金会员"
            } else if model.vip_id == "2" {
                tempStr = "钻石会员"
            } else if model.vip_id == "3" {
                tempStr = "星耀会员"
            } else if model.vip_id == "4" {
                tempStr = "荣耀会员"
            }
            titleLab.text = "开通" + tempStr + "-对公转账"
            orderNumLab.text = "订单编号：" + model.order_sn
            timeLab.text = model.created_at.theDateYMDHMSStrFromNumStr()
            if model.order_status == "0" {
                statusLab.text = "待付款"
            } else if model.order_status == "1" {
                statusLab.text = "已完成"
            } else if model.order_status == "2" {
                statusLab.text = "处理中"
            } else if model.order_status == "4" {
                statusLab.text = "已取消"
            }
        }
    }
    private let titleLab: UILabel = UILabel.init(kFontMS, kOrangeDarkColor, NSTextAlignment.left)
    private let orderNumLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let statusLab: UILabel = UILabel.init(kFontMS, kOrangeDarkColor, NSTextAlignment.right)
    private lazy var detailBtn: HImgRightAlignmentBtn = {
        () -> HImgRightAlignmentBtn in
        let temp = HImgRightAlignmentBtn.init(kFontS, kTextGrayColor, UIControl.ContentHorizontalAlignment.right, nil, nil)
        temp.setTitle(L$("detail"), for: .normal)
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
        self.addSubview(titleLab)
        self.addSubview(orderNumLab)
        self.addSubview(timeLab)
        self.addSubview(statusLab)
        self.addSubview(detailBtn)
        
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, 10)?.rightSpaceToView(self, 80)?.heightIs(30)
        _ = orderNumLab.sd_layout()?.leftEqualToView(titleLab)?.rightEqualToView(titleLab)?.topSpaceToView(titleLab, 0)?.heightIs(20)
        _ = timeLab.sd_layout()?.leftEqualToView(titleLab)?.rightEqualToView(titleLab)?.topSpaceToView(orderNumLab, 0)?.heightIs(20)
        _ = statusLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, 10)?.widthIs(70)?.heightIs(30)
        _ = detailBtn.sd_layout()?.centerYEqualToView(timeLab)?.rightSpaceToView(self, kLeftSpaceS)?.widthIs(70)?.heightIs(30)
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
