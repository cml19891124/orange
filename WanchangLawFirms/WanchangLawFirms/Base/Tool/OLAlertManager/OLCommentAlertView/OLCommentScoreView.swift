//
//  OLCommentScoreView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/18.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 评分视图
class OLCommentScoreView: UIView {

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
        temp.register(OLCommentScoreCollectionCell.self, forCellWithReuseIdentifier: "OLCommentScoreCollectionCell")
        self.addSubview(temp)
        return temp
    }()
    private var isBig: Bool = true
    private lazy var per_wh: CGFloat = {
        () -> CGFloat in
        if isBig {
            return 30
        }
        return 20
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
        _ = collectionV.sd_layout()?.leftSpaceToView(lab1, 0)?.centerYEqualToView(self)?.widthIs(per_wh * 5)?.heightIs(per_wh)
        _ = lab2.sd_layout()?.leftSpaceToView(collectionV, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(60)?.heightIs(20)
        self.refresh()
    }
    
    private func refresh() {
        self.lab2.text = "\(score)分"
        self.collectionV.reloadData()
    }

}

extension OLCommentScoreView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OLCommentScoreCollectionCell", for: indexPath) as! OLCommentScoreCollectionCell
        if isBig {
            cell.btn.setImage(UIImage.init(named: "comment_star_virtual_big"), for: .normal)
            cell.btn.setImage(UIImage.init(named: "comment_star_real_big"), for: .selected)
        } else {
            cell.btn.setImage(UIImage.init(named: "comment_star_virtual_small"), for: .normal)
            cell.btn.setImage(UIImage.init(named: "comment_star_real_small"), for: .selected)
        }
        if Float(indexPath.item) < score {
            cell.btn.isSelected = true
        } else {
            cell.btn.isSelected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isBig {
            self.score = Float(indexPath.item) + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: per_wh, height: per_wh)
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
