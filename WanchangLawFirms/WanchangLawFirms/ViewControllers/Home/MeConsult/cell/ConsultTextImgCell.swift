//
//  ConsultTextImgCell.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我要咨询文本以及图片
class ConsultTextImgCell: ConsultTextCell {
    
    private let titleLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    lazy var photoView: JPhotoResultShowView = {
        () -> JPhotoResultShowView in
        let temp = JPhotoResultShowView.init(frame: CGRect.init(x: 0, y: 180 + kCellSpaceL, width: kDeviceWidth, height: (kDeviceWidth - 40) / 3 + 20))
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLab.text = L$("p_add_img")
        self.addSubview(photoView)
        self.addSubview(titleLab)
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.topSpaceToView(self, 180)?.widthIs(200)?.heightIs(30)
        _ = photoView.sd_layout()?.leftSpaceToView(self, 0)?.topSpaceToView(titleLab, 0)?.bottomSpaceToView(self, 0)?.rightSpaceToView(self, 0)
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
