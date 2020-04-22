//
//  InvoiceManagerController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceManagerController: BaseController {
    
    private lazy var topV: InvoiceTopView = {
        () -> InvoiceTopView in
        let temp = InvoiceTopView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: 130))
        temp.delegate = self
        return temp
    }()
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight + 130, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - 130), style: .plain, space: kLeftSpaceS)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(InvoiceManagerCell.self, forCellReuseIdentifier: "InvoiceManagerCell")
        self.view.addSubview(temp)
        return temp
    }()
    private var dataArr: [InvoiceListModel] = [InvoiceListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("m_invoice_description")
        self.view.addSubview(topV)
        self.listView.tabView.mj_header.beginRefreshing()
    }

}

extension InvoiceManagerController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getDataSource()
        } else {
            
        }
    }
    
    private func getDataSource() {
        HomeManager.share.invoiceList { (arr) in
            self.listView.tabView.mj_header.endRefreshing()
            self.dataArr.removeAll()
            if arr != nil && arr!.count > 0 {
                for m in arr! {
                    self.dataArr.append(m)
                }
            }
            self.listView.tabView.reloadData()
        }
    }
}

extension InvoiceManagerController: InvoiceTopViewDelegate {
    func invoiceTopViewClick(isApply: Bool) {
        if isApply {
            let vc = InvoiceApplyController()
            weak var weakSelf = self
            vc.block = { () in
                weakSelf?.listView.tabView.mj_header.beginRefreshing()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = InvoiceHeadController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension InvoiceManagerController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceManagerCell", for: indexPath) as! InvoiceManagerCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.dataArr[indexPath.row]
        let vc = InvoiceDataController()
        vc.id = model.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
