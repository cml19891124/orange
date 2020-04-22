//
//  MBOrderController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/20.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MBOrderController: BaseController {

    private lazy var topV: MineOrderTopView = {
        () -> MineOrderTopView in
        let temp = MineOrderTopView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: 50))
        temp.topV.delegate = self
        self.view.addSubview(temp)
        return temp
    }()
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: 50 + kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - 50), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.isScrollEnabled = false
        temp.delegate = self
        temp.dataSource = self
        temp.register(MBOrderCollectionCell.self, forCellWithReuseIdentifier: "MBOrderCollectionCell1")
        temp.register(MBOrderCollectionCell.self, forCellWithReuseIdentifier: "MBOrderCollectionCell2")
        self.view.addSubview(temp)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("mine_order")
        self.topV.isHidden = false
        self.collectionV.reloadData()
    }
    
}

extension MBOrderController: JTitleChooseViewDelegate {
    func jtitleChooseViewSelected(model: JTitleChooseModel) {
        self.collectionV.setContentOffset(CGPoint.init(x: CGFloat(model.tag - 1) * kDeviceWidth, y: 0), animated: false)
    }
}

extension MBOrderController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MBOrderCollectionCell1", for: indexPath) as! MBOrderCollectionCell
            cell.status = "1"
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MBOrderCollectionCell2", for: indexPath) as! MBOrderCollectionCell
        cell.status = "2"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: kDeviceWidth, height: kDeviceHeight - kNavHeight - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
