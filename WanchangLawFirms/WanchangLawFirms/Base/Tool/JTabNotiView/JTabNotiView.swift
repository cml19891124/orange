//
//  JTabNotiView.swift
//  Stormtrader
//
//  Created by lh on 2018/11/5.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JTabNotiViewDataSource: NSObjectProtocol {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool)
}


/// UITableView无内容时显示要提示的信息
class JTabNotiView: UIView {
    
    var dataSource: JTabNotiViewDataSource?
    
    lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: self.bounds, style: style, space: space)
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
    
    var style: UITableView.Style = .plain
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

    convenience init(frame: CGRect, style: UITableView.Style, space: CGFloat) {
        self.init(frame: frame)
        self.style = style
        self.space = space
        tabView.reloadData()
        nodataView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(noNet), name: NSNotification.Name(rawValue: noti_net_not_avaliable), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(netStatusChange), name: NSNotification.Name(rawValue: noti_net_status_change), object: nil)
    }
    
    @objc private func headerDataSource() {
        self.dataSource?.jTabNotiViewDataSource(vv: self, isHeader: true)
    }
    
    @objc private func footerDataSource() {
        self.dataSource?.jTabNotiViewDataSource(vv: self, isHeader: false)
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
        if self.tabView.numberOfSections == 0 {
            nodataView.isHidden = false
            nodataView.btn.setImage(UIImage.init(named: "no_data_net"), for: .normal)
            nodataView.lab.text = L$("no_data_net")
        }
    }
    
    @objc private func netStatusChange() {
        if self.tabView.numberOfSections == 0 {
            self.noti()
        }
    }
}
