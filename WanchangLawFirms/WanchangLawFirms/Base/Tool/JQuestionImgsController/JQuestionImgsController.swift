//
//  JQuestionImgsController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/14.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 多图片浏览控制器（目前只有订单详情页的图片浏览）
class JQuestionImgsController: BaseController {
    
    var dataArr: [JImgModel] = [JImgModel]()
    var currentModel: JImgModel = JImgModel()
    
    convenience init(dataArr: [JImgModel], currentModel: JImgModel) {
        self.init()
        self.dataArr = dataArr
        self.currentModel = currentModel
        for i in 0..<dataArr.count {
            let m = dataArr[i]
            if m == currentModel {
                self.currentPage = i
                break
            }
        }
    }
    
    private var currentPage: Int = 0
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceHeight), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.isPagingEnabled = true
        temp.backgroundColor = UIColor.black
        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        temp.register(JQuestionImgsCollectionCell.self, forCellWithReuseIdentifier: "JQuestionImgsCollectionCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var pageCon: JPageControl = {
        () -> JPageControl in
        let temp = JPageControl.init(frame: CGRect.init(x: 0, y: kDeviceHeight - kXBottomHeight - 50, width: kDeviceWidth, height: 20))
        temp.numberOfPages = self.dataArr.count
        self.view.addSubview(temp)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionV.reloadData()
        self.pageCon.currentPage = currentPage
        self.collectionV.setContentOffset(CGPoint.init(x: kDeviceWidth * CGFloat(currentPage), y: 0), animated: false)
    }

}

extension JQuestionImgsController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JQuestionImgsCollectionCell", for: indexPath) as! JQuestionImgsCollectionCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPage = Int(scrollView.contentOffset.x / kDeviceWidth)
        self.pageCon.currentPage = currentPage
    }
}
