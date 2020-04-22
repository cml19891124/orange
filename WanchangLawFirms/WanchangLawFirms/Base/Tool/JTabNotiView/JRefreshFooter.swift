//
//  JRefreshFooter.swift
//  Stormtrader
//
//  Created by lh on 2018/8/28.
//  Copyright © 2018年 gaming17. All rights reserved.
//

import UIKit

/// 尾部刷新
class JRefreshFooter: MJRefreshAutoNormalFooter {

    override func prepare() {
        super.prepare()
        self.stateLabel.textColor = kPlaceholderColor
        self.setTitle(L$("jrefresh_pullup_load_more"), for: .idle)
        self.setTitle(L$("jrefresh_loading_data"), for: .refreshing)
    }
    
    func jRefreshNoMoreData() {
        self.stateLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(rawValue: 0.1))
        self.setTitle(L$("jrefresh_bottom_no_more_data_pro"), for: .noMoreData)
        JQueueManager.share.mainAsyncQueue {
            self.state = .noMoreData
        }
    }
    
    func jRefreshNoTextMoreData() {
        self.stateLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(rawValue: 0.1))
        self.setTitle("", for: .noMoreData)
        JQueueManager.share.mainAsyncQueue {
            self.state = .noMoreData
        }
    }
    
    func jRefreshReset() {
        self.state = .idle
    }

}
