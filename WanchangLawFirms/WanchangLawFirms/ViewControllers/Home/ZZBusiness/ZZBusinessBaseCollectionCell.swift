//
//  ZZBusinessBaseCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 一级分类的Cell视图
class ZZBusinessBaseCollectionCell: UICollectionViewCell {
    var model: ProductModel! {
        didSet {
            imgView.sd_setImage(with: URL.init(string: model.urlStr), completed: nil)
            var str2 = ""
            if model.id == "12" {
                let temp = UserInfo.share.book_lawyer_show_str
                if temp.count > 0 {
                    str2 = "\n" + temp
                }
            } else if model.symbol == "company_other" {
                let temp = UserInfo.share.book_other_show_str
                if temp.count > 0 {
                    str2 = "\n" + temp
                }
            }
            let totalStr = model.title + str2
            lab.text = totalStr
//            if model.id == "11" {
//                let str1 = model.title + "\n"
//                let str2 = UserInfo.share.check_count_show_str
//                let totalStr = str1 + str2
//                lab.text = totalStr
//                return
//            } else {
//                lab.text = model.title
//            }
        }
    }
    
    var bind: String! {
        didSet {
            imgView.image = UIImage.init(named: bind)
            var str2 = ""
            if bind == "h_business_book_custom" {
                let temp = UserInfo.share.make_count_show_str
                if temp.count > 0 {
                    str2 = "\n" + temp
                }
            } else if bind == "h_business_book_check" {
                let temp = UserInfo.share.check_count_show_str
                if temp.count > 0 {
                    str2 = "\n" + temp
                }
            }
            let totalStr = L$(bind) + str2
            lab.text = totalStr
        }
    }
    
    
    let bView: UIView = UIView()
    let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    let lab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.center)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        self.addSubview(bView)
        bView.addSubview(imgView)
        bView.addSubview(lab)
        
        _ = bView.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(self.frame.size.width)?.heightIs(130)
        _ = imgView.sd_layout()?.centerXEqualToView(bView)?.topSpaceToView(bView, 0)?.widthIs(60)?.heightIs(60)
        _ = lab.sd_layout()?.leftSpaceToView(bView, 0)?.rightSpaceToView(bView, 0)?.topSpaceToView(imgView, 10)?.heightIs(35)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
