//
//  OrangeBankView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/27.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class OrangeBankView: UIView {
    
    var pay_code: String = ""
    var pay_tips: String = "" {
        didSet {
            self.tabView.reloadData()
        }
    }
    
    private let bindArr: [String] = ["orange_tips","orange_company","orange_account","orange_bank_name","orange_number","orange_recognizer"]
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: self.bounds, style: .plain, space: 0)
        temp.separatorStyle = .none
        temp.bounces = false
        temp.delegate = self
        temp.dataSource = self
        temp.register(OrangeBankCell.self, forCellReuseIdentifier: "OrangeBankCell")
        temp.register(OrangeBankCodeCell.self, forCellReuseIdentifier: "OrangeBankCodeCell")
        temp.register(JHeaderFooterLabView.self, forHeaderFooterViewReuseIdentifier: "JHeaderFooterLabView")
        return temp
    }()
    private var model: OrangeBankModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.getDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(tabView)
        _ = tabView.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
    }
    
    private func getDataSource() {
        HomeManager.share.companyTransferInfo { (m) in
            self.model = m
            self.tabView.reloadData()
        }
    }

}

extension OrangeBankView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = bindArr[indexPath.row]
        if bind == "orange_recognizer" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrangeBankCodeCell", for: indexPath) as! OrangeBankCodeCell
            cell.titleLab.text = L$(bind)
            cell.codeLab.text = pay_code
            cell.tailLab.text = pay_tips
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrangeBankCell", for: indexPath) as! OrangeBankCell
        cell.titleLab.text = L$(bind)
        if bind == "orange_tips" {
            cell.tailLab.text = model?.tips
        } else if bind == "orange_company" {
            cell.tailLab.text = model?.name
        } else if bind == "orange_account" {
            cell.tailLab.text = model?.account
        } else if bind == "orange_bank_name" {
            cell.tailLab.text = model?.bank
        } else if bind == "orange_number" {
            cell.tailLab.text = model?.number
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bind = bindArr[indexPath.row]
        if bind == "orange_recognizer" {
            return 100
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JHeaderFooterLabView") as! JHeaderFooterLabView
        vv.contentView.backgroundColor = kCellColor
        vv.lab.textColor = kTextBlackColor
        vv.lab.text = "线下转账信息"
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
