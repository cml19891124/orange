//
//  JColNotiView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/6.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JColNotiViewDataSource: NSObjectProtocol {
    func jColNotiViewDataSource(vv: JColNotiView, isHeader: Bool)
}

/// UICollectionView无内容时显示要提示的信息
class JColNotiView: UIView {
    
    weak var dataSource: JColNotiViewDataSource?
    
    lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: self.bounds, scrollDirection: UICollectionView.ScrollDirection.vertical)
        temp.mj_header = j_header
        temp.mj_footer = j_footer
        self.addSubview(temp)
        return temp
    }()
    lazy var nodataView: JNoDataView = {
        () -> JNoDataView in
        let temp = JNoDataView.init(frame: self.bounds)
        self.addSubview(temp)
        return temp
    }()
    lazy var j_header: JRefreshHeader = {
        () -> JRefreshHeader in
        let temp = JRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(headerDataSource))
        return temp!
    }()
    lazy var j_footer: JRefreshFooter = {
        () -> JRefreshFooter in
        let temp = JRefreshFooter.init(refreshingTarget: self, refreshingAction: #selector(footerDataSource))
        temp?.jRefreshNoTextMoreData()
        return temp!
    }()
    
    var direction: UICollectionView.ScrollDirection = .vertical
    var space: CGFloat = 0.0
    
    var imgName: String? {
        didSet {
            if HTTPManager.share.net_unavaliable {
                self.noNet()
            } else {
                self.noti()
            }
        }
    }
    private var lastImgStr: String?
    
    convenience init(frame: CGRect, direction: UICollectionView.ScrollDirection) {
        self.init(frame: frame)
        self.direction = direction
        collectionV.reloadData()
        nodataView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(noNet), name: NSNotification.Name(rawValue: noti_net_not_avaliable), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(netStatusChange), name: NSNotification.Name(rawValue: noti_net_status_change), object: nil)
    }
    
    @objc private func headerDataSource() {
        self.dataSource?.jColNotiViewDataSource(vv: self, isHeader: true)
    }
    
    @objc private func footerDataSource() {
        self.dataSource?.jColNotiViewDataSource(vv: self, isHeader: false)
    }
    
    @objc private func noti() {
        guard let temp = imgName else {
            nodataView.btn.setImage(nil, for: .normal)
            nodataView.lab.text = nil
            nodataView.isHidden = true
            return
        }
        nodataView.isHidden = false
        nodataView.btn.setImage(UIImage.init(named: temp), for: .normal)
        nodataView.lab.text = L$(temp)
    }
    
    @objc private func noNet() {
        if self.collectionV.numberOfSections == 0 {
            nodataView.isHidden = false
            nodataView.btn.setImage(UIImage.init(named: "no_data_net"), for: .normal)
            nodataView.lab.text = L$("no_data_net")
        }
    }
    
    @objc private func netStatusChange() {
        if self.collectionV.numberOfSections == 0 {
            self.noti()
        }
    }

}
