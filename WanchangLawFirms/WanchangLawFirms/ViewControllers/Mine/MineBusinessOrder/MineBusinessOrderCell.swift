//
//  MineBusinessOrderCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/17.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineBusinessOrderCell: BaseCell {
    
    var model: MessageModel! {
        didSet {
            if UserInfo.share.isMother {
                var str = "子"
                if model.co_username == UserInfo.share.business_username {
                    str = "母"
                }
                orderNumLab.text = L$("order_number") + model.order_sn + "(\(str)-\(model.co_username))"
            } else {
                orderNumLab.text = L$("order_number") + model.order_sn
            }
            timeLab.text = model.created_at.theDateYMDHMSStrFromNumStr()
//            logoImgView.image = UIImage.init(named: "h_business_consult_detail")
            logoImgView.avatar = model.avatar
            titleLab.text = model.product_title
            if model.order_status == "0" {
                if model.product_title == "律师约见" || model.product_title == "企业培训" {
                    statusLab.text = "待确认"
                    statusLab.textColor = kOrangeLightColor
                } else {
                    statusLab.text = L$("c_un_pay")
                    statusLab.textColor = kRedColor
                }
            } else if model.order_status == "1" {
                if model.product_title == "律师约见" || model.product_title == "企业培训" {
                    statusLab.text = "预约成功"
                    statusLab.textColor = kRedColor
                } else {
                    statusLab.text = L$("c_dealing")
                    statusLab.textColor = kOrangeLightColor
                }
            } else if model.order_status == "2" {
                statusLab.text = L$("c_finished")
                statusLab.textColor = kTextGrayColor
            } else if model.order_status == "4" {
                statusLab.text = L$("c_cancelled")
                statusLab.textColor = kTextGrayColor
            } else if model.order_status == "5" {
                statusLab.textColor = kTextGrayColor
                statusLab.text = "已付款"
            }
        }
    }
    
    private let orderNumLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let logoImgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: 25)
    private let titleLab: UILabel = UILabel.init(kFontM, kOrangeDarkColor, NSTextAlignment.left)
    private let statusLab: UILabel = UILabel.init(kFontS, kOrangeLightColor, NSTextAlignment.right)
    private lazy var commentBtn: CCWatchDetailBtn = {
        () -> CCWatchDetailBtn in
        var temp: CCWatchDetailBtn
        if UserInfo.share.isMother {
            temp = CCWatchDetailBtn.init(bindStr: "mine_business_service_comment")
        } else {
            temp = CCWatchDetailBtn.init(bindStr: "mine_service_comment")
        }
        return temp
    }()
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
        self.addSubview(orderNumLab)
        self.addSubview(timeLab)
        self.addSubview(logoImgView)
        self.addSubview(titleLab)
        self.addSubview(statusLab)
        self.addSubview(detailBtn)
//        self.addSubview(commentBtn)
        
        _ = orderNumLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, 0)?.rightSpaceToView(self, 80)?.heightIs(30)
        _ = statusLab.sd_layout()?.topSpaceToView(self, 0)?.rightSpaceToView(self, kLeftSpaceS)?.widthIs(150)?.heightIs(30)
        _ = logoImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(orderNumLab, 0)?.widthIs(50)?.heightIs(50)
        _ = titleLab.sd_layout()?.leftSpaceToView(logoImgView, kLeftSpaceS)?.topEqualToView(logoImgView)?.rightSpaceToView(self, 50)?.heightIs(30)
        _ = timeLab.sd_layout()?.leftEqualToView(titleLab)?.rightEqualToView(titleLab)?.topSpaceToView(titleLab, 0)?.heightIs(20)
        _ = detailBtn.sd_layout()?.centerYEqualToView(timeLab)?.rightSpaceToView(self, kLeftSpaceS)?.widthIs(70)?.heightIs(30)
//        _ = commentBtn.sd_layout()?.rightEqualToView(detailBtn)?.centerYEqualToView(titleLab)?.widthIs(commentBtn.bind_width)?.heightIs(commentBtn.bind_height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }

}
