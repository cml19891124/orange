//
//  JRefreshHeader.swift
//  Stormtrader
//
//  Created by lh on 2018/8/28.
//  Copyright © 2018年 gaming17. All rights reserved.
//MJRefreshNormalHeader

import UIKit

/// 头部刷新
class JRefreshHeader: MJRefreshGifHeader {

    private lazy var imgsArr: [UIImage] = {
        () -> [UIImage] in
        return self.dragRefreshImgs()
    }()
    
    
    override func prepare() {
        super.prepare()
        self.languageChange()
        self.setImages([imgsArr[2]], for: .idle)
        self.setImages([imgsArr[2]], for: .pulling)
        self.setImages(imgsArr, for: .refreshing)
    }
    
    func jRefreshNoMoreData() {
        self.setTitle(L$("jrefresh_all_data_loaded"), for: .noMoreData)
        JQueueManager.share.mainAsyncQueue {
            self.state = .noMoreData
        }
    }
    
    func jDelayEndRefreshing(handler:@escaping() -> Void) {
        JQueueManager.share.globalAsyncQueue {
            Thread.sleep(forTimeInterval: 0.75)
            JQueueManager.share.mainAsyncQueue {
                self.endRefreshing()
                handler()
            }
        }
    }
    
    func jVirtualRefresh() {
        JQueueManager.share.globalAsyncQueue {
            Thread.sleep(forTimeInterval: 1)
            JQueueManager.share.mainAsyncQueue {
                self.endRefreshing()
            }
        }
    }
    
//    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
//        super.scrollViewContentOffsetDidChange(change)
//        let currentP = change["new"] as? CGPoint
//        guard let currentY = currentP?.y else {
//            return
//        }
//        var temp = abs(Int32(currentY))
//        if temp > 95 {
//            temp = 95
//        } else if temp < 25 {
//            temp = 25
//        }
//        let index = Int(temp - 25) / 10
//        if temp > 49 {
//            self.setImages([self.imgsArr[index]], for: .pulling)
//        } else {
//            self.setImages([self.imgsArr[index]], for: .idle)
//        }
//    }
}

extension JRefreshHeader {
    @objc private func languageChange() {
        self.setTitle(L$("jrefresh_drop_down_refresh"), for: .idle)
        self.setTitle(L$("jrefresh_refreshing"), for: .refreshing)
        self.setTitle(L$("jrefresh_hand_refresh"), for: .pulling)
    }
}

extension JRefreshHeader {
    private func dragRefreshImgs() -> [UIImage] {
        var tempArr: [UIImage] = [UIImage]()
        for i in 1...8 {
            let img = UIImage.init(named: "drag_refresh_\(i)")
            tempArr.append(img!)
        }
        return tempArr
    }
}
