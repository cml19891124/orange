//
//  LeadPageController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/12.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 引导页界面
class LeadPageController: BaseController {
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: UIScreen.main.bounds, scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.delegate = self
        temp.dataSource = self
        temp.isPagingEnabled = true
        temp.bounces = false
        if #available(iOS 11.0, *) {
            temp.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        temp.register(LeadPageCollectionCell.self, forCellWithReuseIdentifier: "LeadPageCollectionCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var lab: UILabel = {
        let tmp = UILabel.init(kFontMS, kOrangeDarkColor, NSTextAlignment.right)
        tmp.text = "滑动切换"
        tmp.textAlignment = .right
        self.view.addSubview(tmp)
        return tmp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionV.reloadData()
        _ = lab.sd_layout()?.rightSpaceToView(self.view, kLeftSpaceS)?.bottomSpaceToView(self.view, kLeftSpaceL)?.widthIs(200)?.heightIs(20)
    }
    
}

extension LeadPageController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeadPageCollectionCell", for: indexPath) as! LeadPageCollectionCell
        cell.index = indexPath.item + 1
        return cell
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
}
