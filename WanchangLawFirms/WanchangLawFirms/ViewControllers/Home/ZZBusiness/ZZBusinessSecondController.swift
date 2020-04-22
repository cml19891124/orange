//
//  ZZBusinessSecondController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业 - 首页二级分类
class ZZBusinessSecondController: BaseController {
    
    var titleBind: String = ""
    
    private lazy var listView: JColNotiView = {
        () -> JColNotiView in
        let temp = JColNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), direction: UICollectionView.ScrollDirection.vertical)
        temp.backgroundColor = kCellColor
        temp.dataSource = self
        let collectionV = temp.collectionV
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.register(ZZBusinessLeftCollectionCell.self, forCellWithReuseIdentifier: "ZZBusinessLeftCollectionCell")
        collectionV.register(ZZBusinessRightCollectionCell.self, forCellWithReuseIdentifier: "ZZBusinessRightCollectionCell")
        self.view.addSubview(temp)
        return temp
    }()
    private var dataArr: [ProductModel] = [ProductModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$(titleBind)
        self.listView.collectionV.mj_header.beginRefreshing()
    }

}

extension ZZBusinessSecondController: JColNotiViewDataSource {
    func jColNotiViewDataSource(vv: JColNotiView, isHeader: Bool) {
        if isHeader {
            self.headerDataSource()
        } else {
            self.footerDataSource()
        }
    }
    
    private func headerDataSource() {
        var id = "5"
        if titleBind == "h_business_book_check" {
            id = "6"
        } else if titleBind == "h_business_book_other" {
            id = "7"
        } else if titleBind == "h_business_underline_service" {
            id = "10"
        }
        HomeManager.share.serviceList(id: id) { (arr) in
            self.listView.j_header.endRefreshing()
            self.dataArr.removeAll()
            if arr != nil && arr!.count > 0 {
                for m in arr! {
                    if m.type == "1" {
                        self.dataArr.append(m)
                    }
                }
                self.listView.collectionV.bounces = false
            }
            self.listView.collectionV.reloadData()
        }
    }
    
    private func footerDataSource() {
        
    }
}

extension ZZBusinessSecondController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let col = indexPath.row % 2
        let model = dataArr[indexPath.item]
        if col == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZZBusinessLeftCollectionCell", for: indexPath) as! ZZBusinessLeftCollectionCell
            cell.model = model
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZZBusinessRightCollectionCell", for: indexPath) as! ZZBusinessRightCollectionCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[indexPath.item]
        let vc = ZZBusinessDetailController()
        vc.id = model.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = kDeviceWidth / 2
        let h = (kDeviceHeight - kNavHeight) / 3
        return CGSize.init(width: w, height: h)
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
