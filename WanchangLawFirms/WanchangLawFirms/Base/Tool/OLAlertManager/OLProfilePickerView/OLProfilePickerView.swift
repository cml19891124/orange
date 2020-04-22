//
//  OLProfilePickerView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/12.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class OLProfilePickerView: UIView {
    
    weak var delegate: OLPickerViewDelegate?
    
    lazy var bgImgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init(UIView.ContentMode.scaleAspectFill)
        temp.backgroundColor = UIColor.clear
        temp.isUserInteractionEnabled = true
        temp.image = UIImage.init(named: "sex_shadow")
        self.addSubview(temp)
        return temp
    }()
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: 100), scrollDirection: UICollectionView.ScrollDirection.vertical)
        temp.delegate = self
        temp.dataSource = self
        temp.register(OLProfilePickerCollectionCell.self, forCellWithReuseIdentifier: "OLProfilePickerCollectionCell")
        bgImgView.addSubview(temp)
        _ = temp.sd_layout()?.leftEqualToView(bgImgView)?.rightEqualToView(bgImgView)?.bottomSpaceToView(bgImgView, 0)?.topSpaceToView(bgImgView, 0)
        return temp
    }()
    
    
    private var dataArr: [String] = [String]()
    
    private let w_h: CGFloat = 60
    private let space: CGFloat = 60
    private let bvHeight: CGFloat = 120
    
    convenience init(isAvatar: Bool) {
        self.init()
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.clear
        self.layer.opacity = 0
        if isAvatar {
            dataArr = ["camera", "album"]
        } else {
            dataArr = ["sex_man", "sex_woman"]
        }
        collectionV.reloadData()
        bgImgView.frame = CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: bvHeight + 30)
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        OLAlertManager.share.profilePickerHide()
    }
    
}

extension OLProfilePickerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bind = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OLProfilePickerCollectionCell", for: indexPath) as! OLProfilePickerCollectionCell
        cell.bind = bind
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: w_h, height: w_h)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bind = dataArr[indexPath.item]
        self.delegate?.olpickerViewClick(bind: bind)
        OLAlertManager.share.profilePickerHide()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let tb = (bvHeight - w_h) / 2
        let lr = (kDeviceWidth - w_h * 2 - space) / 2
        return UIEdgeInsets.init(top: tb + 30, left: lr, bottom: tb, right: lr)
    }
}
