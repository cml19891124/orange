//
//  HHCustomView.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 首页（我要咨询、个人定制、企业定制视图）
class HHCustomView: UIView {
    
    weak var delegate: HomeCollectionDelegate?
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: self.bounds, scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.delegate = self
        temp.dataSource = self
        temp.register(HHCCollectionCell.self, forCellWithReuseIdentifier: "HHCCollectionCell")
        self.addSubview(temp)
        return temp
    }()
    private lazy var per_w: CGFloat = {
        () -> CGFloat in
        let temp = self.frame.size.width / CGFloat(bindArr.count)
        return temp
    }()
    private lazy var bindArr: [String] = {
        () -> [String] in
        var temp = ["h_me_consult","h_person_custom"]
        if UserInfo.share.is_business {
            temp = ["h_business_consult","h_business_custom"]
        }
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.collectionV.reloadData()
        for i in 1..<bindArr.count {
            let line: UIView = UIView.init(lineColor: kLineGrayColor)
            line.frame = CGRect.init(x: CGFloat(i) * per_w, y: 0, width: 1, height: self.frame.size.height)
            self.addSubview(line)
        }
    }

}

extension HHCustomView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bind = bindArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HHCCollectionCell", for: indexPath) as! HHCCollectionCell
        cell.bind = bind
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: per_w, height: self.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bind = bindArr[indexPath.item]
        self.delegate?.homeCollectionClick(bind: bind)
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
