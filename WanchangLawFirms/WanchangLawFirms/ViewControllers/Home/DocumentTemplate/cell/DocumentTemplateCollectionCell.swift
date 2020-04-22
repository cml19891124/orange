//
//  DocumentTemplateCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit


/// 文书模版
class DocumentTemplateCollectionCell: UICollectionViewCell {
    
    var cModel: HCategoryModel! {
        didSet {
            self.listView.collectionV.mj_header.beginRefreshing()
        }
    }
    
    private lazy var listView: JColNotiView = {
        () -> JColNotiView in
        let temp = JColNotiView.init(frame: self.bounds, direction: UICollectionView.ScrollDirection.vertical)
        temp.dataSource = self
        let collectionV = temp.collectionV
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.register(DTCell.self, forCellWithReuseIdentifier: "DTCell")
        self.addSubview(temp)
        return temp
    }()
    private lazy var per_w: CGFloat = {
        () -> CGFloat in
        let temp = (self.frame.size.width - kLeftSpaceS * 3) / 2
        return temp
    }()
    private var page: Int = 2
    private var dataArr: [HomeModel] = [HomeModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DocumentTemplateCollectionCell: JColNotiViewDataSource {
    func jColNotiViewDataSource(vv: JColNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        } else {
            self.getFooterDataSource()
        }
    }
    
    private func getHeaderDataSource() {
        let prams: NSDictionary = ["cid":cModel.id,"page":"1"]
        HomeManager.share.postsList(prams: prams) { (arr) in
            self.listView.j_header.endRefreshing()
            self.dataArr.removeAll()
            self.page = 2
            if arr == nil || arr!.count == 0 {
                self.listView.j_footer.jRefreshNoMoreData()
                self.listView.collectionV.reloadData()
                return
            }
            for m in arr! {
                self.dataArr.append(m)
            }
            if arr!.count < 4 {
                self.listView.j_footer.jRefreshNoMoreData()
            }
            self.listView.collectionV.reloadData()
        }
    }
    
    private func getFooterDataSource() {
        let prams: NSDictionary = ["cid":cModel.id,"page":"\(page)"]
        HomeManager.share.postsList(prams: prams) { (arr) in
            self.listView.j_footer.endRefreshing()
            self.page += 1
            if arr == nil || arr!.count == 0 {
                self.listView.j_footer.jRefreshNoMoreData()
                self.listView.collectionV.reloadData()
                return
            }
            for m in arr! {
                self.dataArr.append(m)
            }
            if arr!.count < 4 {
                self.listView.j_footer.jRefreshNoMoreData()
            }
            self.listView.collectionV.reloadData()
        }
    }
}

extension DocumentTemplateCollectionCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DTCell", for: indexPath) as! DTCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[indexPath.item]
        let vc = DTSendToEmailController()
        vc.model = model
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: per_w, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kLeftSpaceS
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kLeftSpaceS
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: kLeftSpaceS, left: kLeftSpaceS, bottom: kLeftSpaceS, right: kLeftSpaceS)
    }
}
