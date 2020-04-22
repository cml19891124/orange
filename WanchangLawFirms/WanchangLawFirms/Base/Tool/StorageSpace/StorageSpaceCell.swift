//
//  StorageSpaceCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/11.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class StorageSpaceCell: BaseCell {
    
    var model: StorageModel! {
        didSet {
            if model.isDir {
                logoImgView.image = UIImage.init(named: "file_folder")
            }
            nameLab.text = model.name
            let timeStr = model.created + kBtnSpaceString
            let sizeStr = JPhotoManager.share.lengthStrFrom(length: Int(model.fileLength))
            dataLab.text = timeStr + sizeStr
        }
    }
    
    private let logoImgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    private let nameLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    private let dataLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(logoImgView)
        self.addSubview(nameLab)
        self.addSubview(dataLab)
        
        _ = logoImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(50)?.heightIs(50)
        _ = nameLab.sd_layout()?.leftSpaceToView(logoImgView, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topEqualToView(logoImgView)?.heightIs(35)
        _ = dataLab.sd_layout()?.leftEqualToView(nameLab)?.rightEqualToView(nameLab)?.topSpaceToView(nameLab, 0)?.heightIs(15)
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
