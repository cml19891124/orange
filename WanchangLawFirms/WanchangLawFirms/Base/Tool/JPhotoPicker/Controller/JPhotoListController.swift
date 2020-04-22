//
//  JPhotoListController.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

/// 相片列表
class JPhotoListController: BaseController {
    
    var model: JAlbumListModel?
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - 44 - kXBottomHeight), scrollDirection: UICollectionView.ScrollDirection.vertical)
        temp.delegate = self
        temp.dataSource = self
        temp.register(JPhotoListCollectionCell.self, forCellWithReuseIdentifier: "JPhotoListCollectionCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var resultView: JResultView = {
        () -> JResultView in
        let temp = JResultView.init(frame: CGRect.init(x: 0, y: kDeviceHeight - 44 - kXBottomHeight, width: kDeviceWidth, height: 44 + kXBottomHeight))
        self.view.addSubview(temp)
        return temp
    }()
    private var dataArr: [PHAsset] = [PHAsset]()
    private var per_spcace: CGFloat = 4
    private lazy var per_w: CGFloat = {
        () -> CGFloat in
        let temp = (kDeviceWidth - per_spcace * 5) / 4
        return temp
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionV.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model?.albumName ?? L$("album")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: L$("cancel"), style: .done, target: self, action: #selector(cancelClick))
        self.getDataSource()
        self.resultView.isHidden = false
    }
    
    private func getDataSource() {
        self.dataArr = JPhotoManager.share.fetchAssetsInCollection(collection: self.model?.collection, asending: false)
        self.collectionV.reloadData()
        if self.model?.collection == nil {
            if self.dataArr.count > 10 {
                self.collectionV.scrollToItem(at: IndexPath.init(item: self.dataArr.count - 1, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
            }
        }
    }
    
    @objc private func cancelClick() {
        JPhotoCenter.share.cancel()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}

extension JPhotoListController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JPhotoListCollectionCell", for: indexPath) as! JPhotoListCollectionCell
        cell.delegate = self
        cell.asset = asset
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: per_w, height: per_w)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = dataArr[indexPath.row]
        let vc = JPhotoPreviewController()
        var page: Int = 0
        if asset.selected == true {
            vc.dataArr = JPhotoCenter.share.selectedAsset
            for i in 0..<JPhotoCenter.share.selectedAsset.count {
                let a = JPhotoCenter.share.selectedAsset[i]
                if a.isEqual(asset) {
                    page = i
                    break
                }
            }
        } else {
            vc.dataArr = dataArr
            page = indexPath.item
        }
        vc.current = page
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return per_spcace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return per_spcace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: per_spcace, left: per_spcace, bottom: per_spcace, right: per_spcace)
    }
}

extension JPhotoListController: JPhotoListCollectionCellDelegate {
    func jPhotoListCollectionCellClick() {
        self.collectionV.reloadData()
    }
}
