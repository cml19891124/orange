//
//  PersonCustomCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class PersonCustomCollectionCell: UICollectionViewCell {
    
    var bind: String! {
        didSet {
            btn.setImage(UIImage.init(named: bind), for: .normal)
            btn.setTitle(L$(bind), for: .normal)
//            if bind == "h_business_book_custom" {
//                let str1 = L$(bind) + "\n"
//                let str2 = "价格：1288元/次\n3次修改机会"
//                let totalStr = str1 + str2
//                let mulStr = NSMutableAttributedString.init(string: totalStr)
//                mulStr.addAttribute(NSAttributedString.Key.font, value: kFontS, range: NSRange.init(location: str1.count, length: str2.count))
//                mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kTextGrayColor, range: NSRange.init(location: str1.count, length: str2.count))
//                btn.setAttributedTitle(mulStr, for: .normal)
//                btn.titleLabel?.textAlignment = .center
//            } else if bind == "h_business_book_check" {
//                let str1 = L$(bind) + "\n"
//                let str2 = "价格：988元/次\n2次修改机会"
//                let totalStr = str1 + str2
//                let mulStr = NSMutableAttributedString.init(string: totalStr)
//                mulStr.addAttribute(NSAttributedString.Key.font, value: kFontS, range: NSRange.init(location: str1.count, length: str2.count))
//                mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kTextGrayColor, range: NSRange.init(location: str1.count, length: str2.count))
//                btn.setAttributedTitle(mulStr, for: .normal)
//                btn.titleLabel?.textAlignment = .center
//            } else {
//                btn.setTitle(L$(bind), for: .normal)
//            }
        }
    }
    var model: ProductListModel! {
        didSet {
            let urlStr = OSSManager.initWithShare().allUrlStr(by: model.thumb)
            imgView.sd_setImage(with: URL.init(string: urlStr), completed: nil)
            lab.text = model.title
        }
    }
    
    private lazy var bView: UIView = {
        () -> UIView in
        let temp = UIView()
        return temp
    }()
    private lazy var imgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init(UIView.ContentMode.scaleAspectFit)
        return temp
    }()
    private lazy var lab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.center)
        return temp
    }()
    
    private lazy var btn: JVerticalBtn = {
        () -> JVerticalBtn in
        let temp = JVerticalBtn.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        self.setupViews2()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(bView)
        bView.addSubview(imgView)
        bView.addSubview(lab)
        
        _ = bView.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(self.frame.size.width)?.heightIs(130)
        _ = imgView.sd_layout()?.centerXEqualToView(bView)?.topSpaceToView(bView, 0)?.widthIs(100)?.heightIs(100)
        _ = lab.sd_layout()?.leftSpaceToView(bView, 0)?.rightSpaceToView(bView, 0)?.topSpaceToView(imgView, 0)?.heightIs(30)
    }
    
    private func setupViews2() {
        self.addSubview(btn)
        _ = btn.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
    }
}
