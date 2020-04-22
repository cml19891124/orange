//
//  ZZBusinessLawyersController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/28.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ZZBusinessLawyersController: BaseController {
    
    private lazy var topV: JNavConnectImgView = {
        () -> JNavConnectImgView in
        let temp = JNavConnectImgView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: 44))
        let desLab: UILabel = UILabel.init(kFontMS, UIColor.white, NSTextAlignment.center)
        desLab.frame = temp.bounds
        desLab.text = "专业律师面对面，为您排忧解难"
        temp.addSubview(desLab)
        return temp
    }()
    
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight + 44, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - 40), style: .plain, space: 0)
        temp.dataSource = self
        let tabView = temp.tabView
        tabView.separatorStyle = .none
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(ZZBusinessLawyersCell.self, forCellReuseIdentifier: "ZZBusinessLawyersCell")
        self.view.addSubview(temp)
        return temp
    }()
    private var dataArr: [LawyerModel] = [LawyerModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "律师约见"
        self.view.addSubview(topV)
        self.listView.tabView.mj_header.beginRefreshing()
    }

}

extension ZZBusinessLawyersController: JTabNotiViewDataSource {
    func jTabNotiViewDataSource(vv: JTabNotiView, isHeader: Bool) {
        if isHeader {
            self.getHeaderDataSource()
        }
    }
    
    private func getHeaderDataSource() {
        JMeetManager.share.servicesInlineLawyerList { (arr) in
            self.listView.tabView.mj_header.endRefreshing()
            self.dataArr.removeAll()
            if arr != nil {
                for m in arr! {
                    if m.username != "test" {
                        self.dataArr.append(m)
                    }
                }
            }
            self.listView.tabView.reloadData()
        }
    }
}

extension ZZBusinessLawyersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZZBusinessLawyersCell", for: indexPath) as! ZZBusinessLawyersCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
