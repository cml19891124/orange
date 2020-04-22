//
//  MBSubAccountChooseView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/9.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBSubAccountChooseView: UIView {

    weak var delegate: MBChooseViewDelegate?
    var block = { () in
        
    }
    private lazy var dataArr: [[JBindModel]] = {
        () -> [[JBindModel]] in
        let wordArr1: [String] = ["no_limit","c_un_sure","c_finished","c_dealing","c_cancelled"]
        var temp1 = [JBindModel]()
        for i in 0..<wordArr1.count {
            let m = JBindModel.init(bind: wordArr1[i], font: kFontMS)
            if i == 0 {
                m.selected = true
            }
            temp1.append(m)
        }
        var temp = [[JBindModel]]()
        temp.append(temp1)
        return temp
    }()
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 100), scrollDirection: UICollectionView.ScrollDirection.vertical)
        temp.backgroundColor = kCellColor
        temp.delegate = self
        temp.dataSource = self
        temp.register(FCCCollectionCell.self, forCellWithReuseIdentifier: "FCCCollectionCell")
        temp.register(MBChooseTitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MBChooseTitleCollectionReusableView")
        self.addSubview(temp)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        collectionV.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.isHidden = true
        self.block()
    }
    
}

extension MBSubAccountChooseView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let arr = dataArr[section]
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let arr = dataArr[indexPath.section]
        let model = arr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FCCCollectionCell", for: indexPath) as! FCCCollectionCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let arr = dataArr[indexPath.section]
        let model = arr[indexPath.row]
        return CGSize.init(width: model.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let arr = dataArr[indexPath.section]
        let model = arr[indexPath.item]
        for m in arr {
            m.selected = false
        }
        model.selected = true
        collectionView.reloadData()
        self.isHidden = true
        self.block()
        if indexPath.section == 0 {
            self.delegate?.mbChooseViewStatusClick(m: model)
        } else {
            self.delegate?.mbChooseViewTypeClick(m: model)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: kDeviceWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MBChooseTitleCollectionReusableView", for: indexPath) as! MBChooseTitleCollectionReusableView
        v.lab.text = "订单进度"
        return v
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kLeftSpaceS
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kLeftSpaceS
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: kLeftSpaceS, bottom: 0, right: kLeftSpaceS)
    }
    
}
