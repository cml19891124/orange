//
//  JQuestionImgsCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/14.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JQuestionImgsCollectionCell: UICollectionViewCell {
    
    var model: JImgModel! {
        didSet {
            imgView.image = model.snapImg
            weak var weakSelf = self
            OSSManager.initWithShare().downloadImage(model.remotePath, progress: { (progre) in
                
            }) { (endPath) in
                if endPath.haveTextStr() {
                    weakSelf?.imgView.image = UIImage.init(contentsOfFile: endPath)
                }
            }
        }
    }
    
    
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imgView.backgroundColor = UIColor.black
        imgView.isUserInteractionEnabled = true
        let press = UILongPressGestureRecognizer.init(target: self, action: #selector(pressClick(press:)))
        imgView.addGestureRecognizer(press)
        self.addSubview(imgView)
        _ = imgView.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
    }
    
    @objc private func pressClick(press: UILongPressGestureRecognizer) {
        if press.state != .began {
            return
        }
        let alertCon = UIAlertController.init(title: "保存照片", message: nil, preferredStyle: .actionSheet)
        let actionSave = UIAlertAction.init(title: L$("save"), style: .default) { (action) in
            guard let img = self.imgView.image else {
                return
            }
            JAuthorizeManager.init(view: self).photoLibraryAuthorization {
                JPhotoAlbumManager.share.saveImageToAlbum(image: img)
            }
        }
        let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
        alertCon.addAction(actionSave)
        alertCon.addAction(actionCancel)
        JAuthorizeManager.init(view: self).responseChainViewController().present(alertCon, animated: true, completion: nil)
    }
    
}
