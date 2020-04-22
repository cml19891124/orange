//
//  FastDoorController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/6.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import WebKit

/// 个人版快速入门
class FastDoorController: BaseController {
    
    var content: String?
    var bind: String = ""
    private lazy var webView: WKWebView = {
        () -> WKWebView in
        let temp = WKWebView.init(isOpaque: true)
        temp.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight)
        self.view.addSubview(temp)
        return temp
    }()
    
    private let headV: FastDoorTopView = FastDoorTopView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 350))
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.tableHeaderView = headV
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 60))
        temp.register(FastDoorLeftCell.self, forCellReuseIdentifier: "FastDoorLeftCell")
        temp.register(FastDoorRightCell.self, forCellReuseIdentifier: "FastDoorRightCell")
        self.view.addSubview(temp)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "操作流程"
        self.view.backgroundColor = UIColor.white
        self.headV.titleLab.text = FastDoorManager.share.title(bind: bind)
        self.tabView.reloadData()
    }
    
    private func getDataSource() {
        guard let temp = content else {
            return
        }
        self.webView.loadHTMLString(temp, baseURL: nil)
//        let urlStr = BASE_URL + api_posts_info + "?symbol=" + "help"
//        guard let url = URL.init(string: urlStr) else {
//            return
//        }
//        let request = URLRequest.init(url: url)
//        self.webView.load(request)
    }

}

extension FastDoorController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = indexPath.row % 2
        let step = indexPath.row + 1
        if temp == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FastDoorLeftCell", for: indexPath) as! FastDoorLeftCell
            cell.tagLab.text = "\(step)"
            let logo = FastDoorManager.share.logo(bind: bind, step: step)
            cell.logoBtn.setImage(UIImage.init(named: logo), for: .normal)
            cell.contentLab.text = FastDoorManager.share.stepDesc(bind: bind, step: step)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FastDoorRightCell", for: indexPath) as! FastDoorRightCell
        cell.tagLab.text = "\(step)"
        let logo = FastDoorManager.share.logo(bind: bind, step: step)
        cell.logoBtn.setImage(UIImage.init(named: logo), for: .normal)
        cell.contentLab.text = FastDoorManager.share.stepDesc(bind: bind, step: step)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
}
