//
//  ArticleListController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/6.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 文章浏览
class ArticleListController: BaseController {
    
    var titleBind: String = "h_classic_case"
    
    private lazy var topV: ClassicCaseTopView = {
        () -> ClassicCaseTopView in
        let temp = ClassicCaseTopView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: 50))
        temp.chooseView.delegate = self
        self.view.addSubview(temp)
        return temp
    }()
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: 50 + kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - 50), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.delegate = self
        temp.dataSource = self
        temp.isPagingEnabled = true
        temp.isScrollEnabled = false
        for m in categoryModelArr {
            temp.register(ClassicCaseCollectionCell.self, forCellWithReuseIdentifier: m.title)
        }
        self.view.addSubview(temp)
        return temp
    }()
    
    private var categoryModelArr: [HCategoryModel] = [HCategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$(titleBind)
        self.categoryDataSource()
    }
    
    private func categoryDataSource() {
        var pid = "6"
        if titleBind == "h_latest_information" {
            pid = "1"
        }
        let prams: NSDictionary = ["pid":pid]
        HomeManager.share.postsCategories(prams: prams) { (arr) in
            if arr != nil {
                self.categoryModelArr.removeAll()
                let first = HCategoryModel()
                first.title = "推荐"
                first.recommend = "1"
                first.id = pid
                self.categoryModelArr.append(first)
                for m in arr! {
                    self.categoryModelArr.append(m)
                }
                self.topV.modelArr = self.categoryModelArr
                self.collectionV.reloadData()
            }
        }
    }
    
}

extension ArticleListController: JTitleChooseViewDelegate {
    func jtitleChooseViewSelected(model: JTitleChooseModel) {
        self.collectionV.setContentOffset(CGPoint.init(x: CGFloat(model.tag - 1) * kDeviceWidth, y: 0), animated: false)
    }
}

extension ArticleListController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryModelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.categoryModelArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.title, for: indexPath) as! ClassicCaseCollectionCell
        cell.cModel = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: kDeviceWidth, height: kDeviceHeight - kBarStatusHeight - 88)
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

