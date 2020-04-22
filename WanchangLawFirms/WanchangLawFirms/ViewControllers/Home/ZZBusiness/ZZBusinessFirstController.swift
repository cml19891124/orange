//
//  ZZBusinessFirstController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业 - 首页一级分类（文书定制、文书审查、其它文书、线下服务等）
class ZZBusinessFirstController: BaseController {
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), scrollDirection: UICollectionView.ScrollDirection.vertical)
        temp.backgroundColor = kCellColor
        temp.delegate = self
        temp.dataSource = self
        temp.register(ZZBusinessLeftCollectionCell.self, forCellWithReuseIdentifier: "ZZBusinessLeftCollectionCell")
        temp.register(ZZBusinessRightCollectionCell.self, forCellWithReuseIdentifier: "ZZBusinessRightCollectionCell")
        self.view.addSubview(temp)
        return temp
    }()
    
//    private lazy var bindArr: [String] = {
//        () -> [String] in
//        var temp = ["h_business_book_custom","h_business_book_check","h_business_book_other"]
//        if UserInfo.share.isMother {
//            temp.append("h_business_underline_service")
//        }
//        return temp
//    }()
    private let bindArr: [String] = ["h_business_book_custom","h_business_book_check","h_business_book_other","h_business_underline_service"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("h_business_custom")
        self.collectionV.reloadData()
    }
    
}

extension ZZBusinessFirstController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let col = indexPath.row % 2
        let bind = bindArr[indexPath.item]
        if col == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZZBusinessLeftCollectionCell", for: indexPath) as! ZZBusinessLeftCollectionCell
            cell.bind = bind
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZZBusinessRightCollectionCell", for: indexPath) as! ZZBusinessRightCollectionCell
        cell.bind = bind
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bind = bindArr[indexPath.item]
        if bind == "h_business_book_check" {
            let vc = ZZBusinessDetailController()
            vc.id = "13"
            self.navigationController?.pushViewController(vc, animated: true)
            return
        } else if bind == "h_business_underline_service" {
            let vc = ZZBusinessUnderLineController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let vc = ZZBusinessSecondController()
        vc.titleBind = bind
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = kDeviceWidth / 2
        let h = (kDeviceHeight - kNavHeight) / 3
        return CGSize.init(width: w, height: h)
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
