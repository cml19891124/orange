//
//  JPhotoResultShowView.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

protocol JPhotoResultShowViewDelegate: NSObjectProtocol {
    func jphotoResultShowViewCameraAlbumClick(isCamera: Bool)
}

class JPhotoResultShowView: UIView {
    
    var per_wh: CGFloat = (kDeviceWidth - 40) / 3
    
    weak var delegate: JPhotoCenterDelegate?
    weak var camera_delegate: JPhotoResultShowViewDelegate?

    private lazy var collectionView: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: self.bounds, scrollDirection: UICollectionView.ScrollDirection.vertical)
        temp.backgroundColor = kCellColor
        temp.delegate = self
        temp.dataSource = self
        temp.register(JPhotoResultShowCell.self, forCellWithReuseIdentifier: "JPhotoResultShowCell")
        temp.register(JPhotoResultShowAddCell.self, forCellWithReuseIdentifier: "JPhotoResultShowAddCell")
        self.addSubview(temp)
        _ = temp.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        JPhotoCenter.share.setupConfigure(configure: JPhotoConfigure.init(mediaType: .image, cutType: .onlyCut, showGif: false))
        JPhotoCenter.share.selectedAsset.removeAll()
        JPhotoCenter.share.delegate = self
        self.collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(jphotoCenterEnd(assets:)), name: NSNotification.Name(rawValue: JPhoto_Noti_Select_Change), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JPhotoResultShowView: JPhotoCenterDelegate {
    @objc func jphotoCenterEnd(assets: [PHAsset]) {
        self.collectionView.reloadData()
        self.delegate?.jphotoCenterEnd(assets: assets)
    }

    func jPhotoCenterUploadFinish() {
        self.delegate?.jPhotoCenterUploadFinish!()
    }
}

extension JPhotoResultShowView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = JPhotoCenter.share.selectedAsset.count + 1
        if count > 9 {
            count = 9
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == JPhotoCenter.share.selectedAsset.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JPhotoResultShowAddCell", for: indexPath) as! JPhotoResultShowAddCell
            return cell
        }
        let asset = JPhotoCenter.share.selectedAsset[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JPhotoResultShowCell", for: indexPath) as! JPhotoResultShowCell
        cell.asset = asset
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == JPhotoCenter.share.selectedAsset.count {
            
            let alertCon = UIAlertController.init(title: "选择方式", message: nil, preferredStyle: .actionSheet)
            let actionCamera = UIAlertAction.init(title: L$("camera"), style: .default) { (action) in
                self.camera_delegate?.jphotoResultShowViewCameraAlbumClick(isCamera: true)
            }
            let actionAlbum = UIAlertAction.init(title: L$("album"), style: .default) { (action) in
                self.camera_delegate?.jphotoResultShowViewCameraAlbumClick(isCamera: false)
            }
            let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
            alertCon.addAction(actionCamera)
            alertCon.addAction(actionAlbum)
            alertCon.addAction(actionCancel)
            JAuthorizeManager.init(view: self).responseChainViewController().present(alertCon, animated: true, completion: nil)
            
            //                let nav = BaseNavigationController.init(rootViewController: JAlbumListController())
            //                JAuthorizeManager.init(view: self).responseChainViewController().present(nav, animated: true, completion: nil)
        } else {
            JAuthorizeManager.init(view: self).photoLibraryAuthorization {
                let vc = JPhotoPreviewController()
                vc.current = indexPath.item
                vc.dataArr = JPhotoCenter.share.selectedAsset
                vc.isFromPreview = true
                JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: per_wh, height: per_wh)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
}
