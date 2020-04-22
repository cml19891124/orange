//
//  OLCScoreView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/20.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class OLCScoreView: UIView {
    
    var score: Float = 5 {
        didSet {
            self.refresh()
        }
    }
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect(), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.delegate = self
        temp.dataSource = self
        temp.register(OLCCollectionCell.self, forCellWithReuseIdentifier: "OLCCollectionCell")
        self.addSubview(temp)
        return temp
    }()
    private var isBig: Bool = true
    
    private lazy var per_size: CGSize = {
        () -> CGSize in
        if isBig {
            return CGSize.init(width: 24, height: 22)
        }
        return CGSize.init(width: 16, height: 15)
    }()
    private let lab1: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let lab2: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    
    convenience init(isBig: Bool) {
        self.init()
        self.isBig = isBig
        self.lab1.text = "评分"
        self.addSubview(lab1)
        self.addSubview(lab2)
        _ = lab1.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(30)?.heightIs(20)
        _ = collectionV.sd_layout()?.leftSpaceToView(lab1, 0)?.centerYEqualToView(self)?.widthIs(per_size.width * 5)?.heightIs(per_size.height)
        _ = lab2.sd_layout()?.leftSpaceToView(collectionV, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(60)?.heightIs(20)
        self.refresh()
    }
    
    private func refresh() {
        self.lab2.text = "\(score)分"
        self.collectionV.reloadData()
    }
    
}

extension OLCScoreView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OLCCollectionCell", for: indexPath) as! OLCCollectionCell
        cell.delegate = self
        cell.item = indexPath.item
        cell.isBig = isBig
        
        let t1 = Int(score)
        let t2 = score - Float(t1)
        if Float(indexPath.item) < score - t2 {
            cell.score = 1
        } else if Float(indexPath.item) < score {
            cell.score = t2
        } else {
            cell.score = 0
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if self.isBig {
//            self.score = Float(indexPath.item) + 1
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return per_size
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
}

extension OLCScoreView: OLCCollectionCellDelegate {
    func olcCollectionCellClick(score: Float, item: Int) {
        self.score = score + Float(item)
    }
}
