//
//  HHFuncView.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 首页功能视图（经典案例、文书模版，法务计算器、在线客服）
class HHFuncView: UIView {
    
    weak var delegate: HomeCollectionDelegate?
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: self.bounds, scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.backgroundColor = kCellColor
        temp.delegate = self
        temp.dataSource = self
        temp.register(HHFCollectionCell.self, forCellWithReuseIdentifier: "HHFCollectionCell")
        temp.register(HHFOnlineServiceCell.self, forCellWithReuseIdentifier: "HHFOnlineServiceCell")
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
        var temp = ["h_classic_case","h_document_template","h_forensic_calculator","h_online_service"]
        if UserInfo.share.is_business {
            temp = ["h_classic_case","h_document_template","h_online_service"]
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
    }

}

extension HHFuncView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bind = bindArr[indexPath.item]
        if bind == "h_online_service" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HHFOnlineServiceCell", for: indexPath) as! HHFOnlineServiceCell
            cell.bind = bind
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HHFCollectionCell", for: indexPath) as! HHFCollectionCell
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
