//
//  ClassicCaseCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class ClassicCaseCollectionCell: UICollectionViewCell {
    
    var cModel: HCategoryModel! {
        didSet {
            if dataArr.count == 0 {
                self.listView.tabView.mj_header.beginRefreshing()
            }
        }
    }
    private var dataArr: [HomeModel] = [HomeModel]()
    private lazy var headV: CCCHeadView = {
        () -> CCCHeadView in
        let temp = CCCHeadView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 240))
        return temp
    }()
    
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: self.bounds, style: .plain, space: 0)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(CCCCell.self, forCellReuseIdentifier: "CCCCell")
        tabView.register(CCCHeaderView.self, forHeaderFooterViewReuseIdentifier: "CCCHeaderView")
        tabView.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.addSubview(temp)
        return temp
    }()
    private var page: Int = 2
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ClassicCaseCollectionCell: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        } else {
            self.getFooterDataSource()
        }
    }
}

extension ClassicCaseCollectionCell {
    private func getHeaderDataSource() {
        var prams: NSDictionary
        if cModel.recommend == "1" {
            prams = ["cid": cModel.id,"page":"1","recommend":"1","child":"1"]
        } else {
            prams = ["cid": cModel.id,"page":"1"]
        }
        HomeManager.share.postsList(prams: prams) { (arr) in
            self.listView.j_header.endRefreshing()
            self.page = 2
            self.dataArr.removeAll()
            guard let temp = arr else {
                return
            }
            if temp.count < 10 {
                self.listView.j_footer.jRefreshNoMoreData()
            } else {
                self.listView.j_footer.jRefreshReset()
            }
            for m in temp {
                self.dataArr.append(m)
            }
            if self.cModel.recommend == "1" {
                if self.dataArr.count > 0 {
                    self.headV.model = self.dataArr[0]
                    self.listView.tabView.tableHeaderView = self.headV
                    self.dataArr.remove(at: 0)
                } else {
                    self.listView.tabView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
                }
            } else {
                self.listView.tabView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
            }
            self.listView.tabView.reloadData()
        }
    }
    
    private func getFooterDataSource() {
        var prams: NSDictionary
        if cModel.recommend == "1" {
            prams = ["cid": cModel.id,"page":"\(page)","recommend":"1","child":"1"]
        } else {
            prams = ["cid": cModel.id,"page":"\(page)"]
        }
        HomeManager.share.postsList(prams: prams) { (arr) in
            self.listView.j_footer.endRefreshing()
            self.page += 1
            guard let temp = arr else {
                return
            }
            if temp.count < 10 {
                self.listView.j_footer.jRefreshNoMoreData()
            }
            for m in temp {
                self.dataArr.append(m)
            }
            self.listView.tabView.reloadData()
        }
    }
}

extension ClassicCaseCollectionCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CCCCell", for: indexPath) as! CCCCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.row]
        let vc = ArticleDetailController()
        vc.model = model
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.dataArr.count > 0 {
            let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CCCHeaderView") as! CCCHeaderView
            if cModel.id == "6" {
                vv.titleBtn.setTitle(kBtnSpaceString + L$("h_hot_case2"), for: .normal)
            }
            return vv
        }
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.dataArr.count > 0 {
            return 50
        }
        return 0.01
    }
    

}








