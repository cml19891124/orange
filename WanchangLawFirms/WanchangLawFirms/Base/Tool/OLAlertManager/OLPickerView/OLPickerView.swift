//
//  OLPickerView.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol OLPickerViewDelegate: NSObjectProtocol {
    func olpickerViewClick(bind: String)
}

class OLPickerView: UIView {
    
    weak var delegate: OLPickerViewDelegate?
    
    lazy var bgImgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init(UIView.ContentMode.scaleAspectFill)
        temp.backgroundColor = kCellColor
        temp.isUserInteractionEnabled = true
        self.addSubview(temp)
        return temp
    }()
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: 100), scrollDirection: UICollectionView.ScrollDirection.vertical)
        temp.delegate = self
        temp.dataSource = self
        temp.register(OLPickerCollectionCell.self, forCellWithReuseIdentifier: "OLPickerCollectionCell")
        bgImgView.addSubview(temp)
        _ = temp.sd_layout()?.leftEqualToView(bgImgView)?.rightEqualToView(bgImgView)?.bottomSpaceToView(bgImgView, 0)?.topSpaceToView(bgImgView, 0)
        return temp
    }()
    private lazy var cancelBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(cancelClick))
        temp.setTitle(L$("cancel"), for: .normal)
        temp.layer.borderColor = kLineGrayColor.cgColor
        temp.layer.borderWidth = 1
        bgImgView.addSubview(temp)
        _ = temp.sd_layout()?.leftEqualToView(bgImgView)?.rightEqualToView(bgImgView)?.bottomSpaceToView(bgImgView, 0)?.heightIs(50)
        return temp
    }()
    
    private var col_h: CGFloat = 0
    
    private var dataArr: [String] = [String]()
    
    private var w_h: CGFloat = 70
    private var space: CGFloat = 0.0
    private var lineSpace: CGFloat = 20
    
    convenience init(bindArr: [String]) {
        self.init()
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.layer.opacity = 0
        dataArr = bindArr
        collectionV.reloadData()
        cancelBtn.isHidden = false
        if dataArr.count > 2 {
            space = (kDeviceWidth - w_h * 3) / 4
            let row = (dataArr.count - 1) / 3 + 1
            col_h += w_h * CGFloat(row) + lineSpace * CGFloat(row + 1)
        } else {
            space = (kDeviceWidth - w_h * 2) / 3
            col_h += w_h + lineSpace * 2
        }
        bgImgView.frame = CGRect.init(x: 0, y: kDeviceHeight, width: kDeviceWidth, height: col_h + 50)
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        OLAlertManager.share.pickerHide()
    }
    
    @objc private func cancelClick() {
        OLAlertManager.share.pickerHide()
    }

}

extension OLPickerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bind = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OLPickerCollectionCell", for: indexPath) as! OLPickerCollectionCell
        cell.bind = bind
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: w_h, height: w_h)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bind = dataArr[indexPath.item]
        self.delegate?.olpickerViewClick(bind: bind)
        OLAlertManager.share.pickerHide()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: lineSpace, left: space, bottom: lineSpace, right: space)
    }
}
