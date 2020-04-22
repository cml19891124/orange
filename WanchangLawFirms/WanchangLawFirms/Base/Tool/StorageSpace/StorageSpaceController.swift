//
//  StorageSpaceController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/11.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 存储空间清理
class StorageSpaceController: BaseController {
    
    var model: StorageModel!
    convenience init(model: StorageModel) {
        self.init()
        self.model = model
    }
    
    private var dataArr: [StorageModel] = [StorageModel]()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: kLeftSpaceS)
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        temp.register(StorageSpaceCell.self, forCellReuseIdentifier: "StorageSpaceCell")
        self.view.addSubview(temp)
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model.name
        dataArr = StorageManager.initWithShare().getFileListInFolder(withPath: model.path)
        self.tabView.reloadData()
    }

}

extension StorageSpaceController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempM = dataArr[indexPath.row]
        let cell = tabView.dequeueReusableCell(withIdentifier: "StorageSpaceCell", for: indexPath) as! StorageSpaceCell
        cell.model = tempM
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tempM = dataArr[indexPath.row]
        if tempM.isDir {
            let vc = StorageSpaceController.init(model: tempM)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
