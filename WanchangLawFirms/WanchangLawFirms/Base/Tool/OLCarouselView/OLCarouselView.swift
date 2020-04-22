//
//  OLCarouselView.swift
//  OLegal
//
//  Created by lh on 2018/11/26.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 首页轮播视图，暂时不需要，需要时再使用该类
class OLCarouselView: UIView {
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: self.frame.size.height), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        temp.isPagingEnabled = true
        temp.register(OLCarouseCell.self, forCellWithReuseIdentifier: "OLCarouseCell")
        self.addSubview(temp)
        return temp
    }()
    private lazy var pageCon: UIPageControl = {
        () -> UIPageControl in
        let temp = UIPageControl.init(frame: CGRect.init(x: (kDeviceWidth - 80) / 2, y: self.frame.size.height - 40, width: 80, height: 20))
        temp.currentPageIndicatorTintColor = UIColor.white
        temp.isUserInteractionEnabled = false
        temp.currentPage = 0
        self.addSubview(temp)
        return temp
    }()
    private var dataArr: [OLCarouselModel] = [OLCarouselModel]()
    private lazy var timer: Timer = {
        let temp = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        return temp
    }()
    private var timeCount = 0
    private var isAutoScroll: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dataRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(dataRefresh), name: NSNotification.Name(rawValue: noti_home_slider_refresh), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func timerAction() {
        timeCount += 1
        if timeCount < 2 {
            return
        }
        timeCount = 0
        var page = pageCon.currentPage
        isAutoScroll = true
        collectionV.setContentOffset(CGPoint.init(x: kDeviceWidth * CGFloat(page + 2), y: 0), animated: true)
        if page < self.dataArr.count - 3 {
            page += 1
        } else {
            page = 0
        }
        pageCon.currentPage = page
    }
    
    @objc private func dataRefresh() {
        self.dataArr.removeAll()
        guard let str = UserInfo.getStandard(key: standard_home_slider) else {
            self.dealNoData()
            return
        }
        guard let data = str.data(using: String.Encoding.utf8) else {
            self.dealNoData()
            return
        }
        let temp1 = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        let temp2 = OLCarouselModel.mj_objectArray(withKeyValuesArray: temp1) as? [OLCarouselModel]
        guard let temp3 = temp2 else {
            self.dealNoData()
            return
        }
        if temp3.count == 0 {
            self.dealNoData()
            return
        }
        let result = temp3.sorted { (m1, m2) -> Bool in
            return m1.sort < m2.sort
        }
        for m in result {
            self.dataArr.append(m)
        }
        self.lastRefresh()
        if self.dataArr.count > 3 {
            self.timer.fireDate = Date.distantPast
        }
    }
    
    private func dealNoData() {
        let m = OLCarouselModel()
        self.dataArr.append(m)
        self.lastRefresh()
    }
    
    private func lastRefresh() {
        self.collectionV.isHidden = false
        self.pageCon.numberOfPages = self.dataArr.count
        if self.dataArr.count == 1 {
            self.pageCon.isHidden = true
        } else {
            self.pageCon.isHidden = false
            let first = self.dataArr.first!
            let last = self.dataArr.last!
            self.dataArr.insert(last, at: 0)
            self.dataArr.append(first)
            collectionV.setContentOffset(CGPoint.init(x: kDeviceWidth, y: 0), animated: false)
        }
        self.collectionV.reloadData()
    }

}

extension OLCarouselView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OLCarouseCell", for: indexPath) as! OLCarouseCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.item]
        //        let vc = JURLController.init(urlStr: model.url, bind: model.title)
        let vc = ArticleDetailController()
        vc.isCarouse = true
        let m = HomeModel()
        m.id = model.id
        m.title = model.title
        m.sub_title = model.information
        vc.model = m
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: kDeviceWidth, height: self.frame.size.height)
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
        let index = Int(scrollView.contentOffset.x / kDeviceWidth)
        var page = index - 1
        if index == 0 {
            scrollView.setContentOffset(CGPoint.init(x: kDeviceWidth * CGFloat(self.dataArr.count - 2), y: 0), animated: false)
            page = self.dataArr.count - 3
        } else if index == self.dataArr.count - 1 {
            scrollView.setContentOffset(CGPoint.init(x: kDeviceWidth, y: 0), animated: false)
            page = 0
        }
        pageCon.currentPage = page
        isAutoScroll = false
        timeCount = 0
        timer.fireDate = Date.distantPast
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / kDeviceWidth)
        var page = index - 1
        if index == 0 {
            scrollView.setContentOffset(CGPoint.init(x: kDeviceWidth * CGFloat(self.dataArr.count - 2), y: 0), animated: false)
            page = self.dataArr.count - 3
        } else if index == self.dataArr.count - 1 {
            scrollView.setContentOffset(CGPoint.init(x: kDeviceWidth, y: 0), animated: false)
            page = 0
        }
        pageCon.currentPage = page
        isAutoScroll = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isAutoScroll {
            timer.fireDate = Date.distantFuture
            isAutoScroll = true
        }
    }
}
