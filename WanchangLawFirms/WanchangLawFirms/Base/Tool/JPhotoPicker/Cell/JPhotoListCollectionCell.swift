//
//  JPhotoListCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

protocol JPhotoListCollectionCellDelegate: NSObjectProtocol {
    func jPhotoListCollectionCellClick()
}

class JPhotoListCollectionCell: UICollectionViewCell {
    
    weak var delegate: JPhotoListCollectionCellDelegate?
    
    var asset: PHAsset! {
        didSet {
            if asset.img == nil {
                JPhotoManager.share.fetchImageInAsset(asset: self.asset, size: CGSize.init(width: 200, height: 200), mode: .fast) { (asset, img, dict) in
                    self.imgView.image = img
                }
            } else {
                self.imgView.image = asset.img
            }
            var index = 0
            for i in 0..<JPhotoCenter.share.selectedAsset.count {
                let a = JPhotoCenter.share.selectedAsset[i]
                if a.isEqual(asset) {
                    index = i + 1
                    asset.selected = true
                    break
                }
            }
            selectView.index = index
            if asset.mediaType == .video {
                self.dataView.isHidden = false
                self.dataView.imgName = "JPhoto_video"
                self.dataView.length = asset.fileSize
            } else {
                if JPhotoCenter.share.configure.showGif && asset.is_gif {
                    self.dataView.isHidden = false
                    self.dataView.imgName = "JPhoto_gif"
                    self.dataView.length = asset.fileSize
                } else {
                    self.dataView.isHidden = true
                }
            }
        }
    }
    
    private lazy var imgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init()
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        return temp
    }()
    private lazy var selectView: JPhotoSelectView = {
        () -> JPhotoSelectView in
        let temp = JPhotoSelectView.init(bgColor: customColor(30, 157, 238), wh: 26)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectTap))
        temp.addGestureRecognizer(tap)
        return temp
    }()
    private lazy var dataView: JPhotoDataView = {
        () -> JPhotoDataView in
        let temp = JPhotoDataView.init(h: 25)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(imgView)
        self.addSubview(selectView)
        self.addSubview(dataView)
        
        _ = imgView.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
        _ = selectView.sd_layout()?.rightEqualToView(self)?.topEqualToView(self)?.widthIs(36)?.heightIs(36)
        _ = dataView.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(25)
    }
    
    @objc private func selectTap() {
        if asset.too_big_forbidden {
            return
        }
        if asset.selected != true {
            JPhotoCenter.share.addAsset(asset: asset)
        } else {
            JPhotoCenter.share.removeAsset(asset: asset)
        }
        self.delegate?.jPhotoListCollectionCellClick()
    }
    
}
