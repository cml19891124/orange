//
//  JAlbumListController.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 相册名列表
class JAlbumListController: BaseController {
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 10)
        temp.delegate = self
        temp.dataSource = self
        temp.register(JAlbumListCell.self, forCellReuseIdentifier: "JAlbumListCell")
        self.view.addSubview(temp)
        return temp
    }()
    private var dataArr: [JAlbumListModel] = [JAlbumListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("album")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: L$("cancel"), style: .done, target: self, action: #selector(cancelClick))
        let vc = JPhotoListController()
        self.navigationController?.pushViewController(vc, animated: false)
        self.getDataSource()
    }
    
    private func getDataSource() {
        self.dataArr = JPhotoManager.share.getAllAlbums()
        self.tabView.reloadData()
    }
    
    @objc private func cancelClick() {
        JPhotoCenter.share.cancel()
        self.dismiss(animated: true, completion: nil)
    }

}

extension JAlbumListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JAlbumListCell", for: indexPath) as! JAlbumListCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.row]
        let vc = JPhotoListController()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
