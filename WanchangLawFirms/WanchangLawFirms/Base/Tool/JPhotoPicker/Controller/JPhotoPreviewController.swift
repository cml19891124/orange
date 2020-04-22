//
//  JPhotoPreviewController.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

/// 相片大图预览
class JPhotoPreviewController: BaseController {
    
    var dataArr: [PHAsset]!
    var current: Int = 0
    
    var isFromPreview: Bool = false
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceHeight), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.delegate = self
        temp.dataSource = self
        temp.isPagingEnabled = true
        temp.register(JPhotoPreviewCollectionCell.self, forCellWithReuseIdentifier: "JPhotoPreviewCollectionCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var selectView: JPhotoSelectView = {
        () -> JPhotoSelectView in
        let temp = JPhotoSelectView.init(bgColor: customColor(30, 157, 238), wh: 30)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectTap))
        temp.frame.size = CGSize.init(width: 44, height: 44)
        temp.addGestureRecognizer(tap)
        return temp
    }()
    private lazy var resultView: JResultView = {
        () -> JResultView in
        let temp = JResultView.init(frame: CGRect.init(x: 0, y: kDeviceHeight - 44 - kXBottomHeight, width: kDeviceWidth, height: 44 + kXBottomHeight))
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDataSource()
        if !isFromPreview {
            self.view.addSubview(resultView)
        }
    }
    
    private func getDataSource() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.selectView)
        self.collectionV.reloadData()
        self.collectionV.scrollToItem(at: IndexPath.init(row: current, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        self.refreshSelectStatus()
    }
    
    @objc private func selectTap() {
        let page = Int(self.collectionV.contentOffset.x / kDeviceWidth)
        let asset = dataArr[page]
        if asset.too_big_forbidden {
            return
        }
        if asset.selected != true {
            JPhotoCenter.share.addAsset(asset: asset)
        } else {
            JPhotoCenter.share.removeAsset(asset: asset)
        }
        self.refreshSelectStatus()
    }
    
    private func refreshSelectStatus() {
        let page = Int(self.collectionV.contentOffset.x / kDeviceWidth)
        let asset = dataArr[page]
        var index = 0
        for i in 0..<JPhotoCenter.share.selectedAsset.count {
            let a: PHAsset = JPhotoCenter.share.selectedAsset[i]
            if a.isEqual(asset) {
                index = i + 1
                break
            }
        }
        selectView.index = index
        self.title = "\(page + 1)/\(dataArr.count)"
    }

}

extension JPhotoPreviewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JPhotoPreviewCollectionCell", for: indexPath) as! JPhotoPreviewCollectionCell
        cell.asset = asset
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.resultView.isHidden {
            self.resultView.isHidden = false
            self.currentNavigationBarAlpha = 1
        } else {
            self.resultView.isHidden = true
            self.currentNavigationBarAlpha = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: kDeviceWidth, height: kDeviceHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.refreshSelectStatus()
    }
}
