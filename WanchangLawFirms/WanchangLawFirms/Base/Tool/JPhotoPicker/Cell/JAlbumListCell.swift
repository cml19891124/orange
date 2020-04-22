//
//  JAlbumListCell.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

class JAlbumListCell: BaseCell {
    
    var model: JAlbumListModel! {
        didSet {
            JPhotoManager.share.fetchImageInAsset(asset: model.coverAsset, size: CGSize.init(width: 200, height: 200), mode: .fast) { (asset, img, dict) in
                self.imgView.image = img
            }
            titleLab.text = model.albumName + "(\(model.count))"
        }
    }
    
    private lazy var imgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init()
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        return temp
    }()
    private lazy var titleLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init()
        temp.textColor = UIColor.black
        temp.font = UIFont.systemFont(ofSize: 16)
        temp.textAlignment = .left
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(imgView)
        self.addSubview(titleLab)
        
        _ = imgView.sd_layout()?.leftSpaceToView(self, 10)?.centerYEqualToView(self)?.widthIs(60)?.heightIs(60)
        _ = titleLab.sd_layout()?.leftSpaceToView(imgView, 10)?.centerYEqualToView(self)?.rightSpaceToView(self, 50)?.heightIs(30)
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
