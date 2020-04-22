//
//  PCMIconHeaderView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/28.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class PCMIconHeaderView: UITableViewHeaderFooterView {

    var model: JMeetModel!
    var bind: String! {
        didSet {
            logoImgView.image = UIImage.init(named: bind)
            var str1 = L$(bind)
            var str2 = ""
            if bind == "h_meet_time" {
                str1 += "："
                str2 = model.date
            } else if bind == "h_meet_time_duration" {
                str1 += "："
                if model.time == "0" {
                    str2 = "上午9:30-11:30"
                } else if model.time == "1" {
                    str2 = "下午14:30-16:30"
                }
            } else if bind == "h_meet_area" {
                str1 += "："
                str2 = "欧伶猪总公司"
            } else if bind == "h_meet_reason" {
                str1 += "："
                str2 = model.reason
            } else if bind == "h_meet_contact_way" {
                
            } else if bind == "h_meet_teach_area" {
                str1 += "："
                str2 = model.address
            } else if bind == "h_meet_teach_obj" {
                str1 += "："
                str2 = model.train_people
            } else if bind == "h_meet_teach_content" {
                str1 += "："
                str2 = model.train_content
            } else if bind == "h_meet_teach_phone" {
                str1 += "："
                str2 = model.train_contact_mobile
            }
            titleLab.text = str1
            desLab.text = str2
            if bind == "h_meet_contact_way" {
                line.isHidden = true
            } else {
                line.isHidden = false
            }
        }
    }
    private let logoImgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    private let titleLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    private let desLab: UILabel = UILabel.init(kFontM, kTextGrayColor, NSTextAlignment.left)
    private let line: UIView = UIView.init(lineColor: kLineGrayColor)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = kCellColor
        titleLab.adjustsFontSizeToFitWidth = false
        self.addSubview(logoImgView)
        self.addSubview(titleLab)
        self.addSubview(desLab)
        self.addSubview(line)
        _ = logoImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.widthIs(21)?.heightIs(21)
        _ = titleLab.sd_layout()?.leftSpaceToView(logoImgView, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(110)?.heightIs(30)
        _ = desLab.sd_layout()?.leftSpaceToView(titleLab, 0)?.topSpaceToView(self, 0)?.rightSpaceToView(self, kLeftSpaceS)?.bottomSpaceToView(self, 0)
        _ = line.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.bottomEqualToView(self)?.heightIs(kLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
