//
//  PersonCustomController.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 个人订制
class PersonCustomController: BaseController {
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), scrollDirection: UICollectionView.ScrollDirection.vertical)
        temp.backgroundColor = kLineGrayColor
        temp.delegate = self
        temp.dataSource = self
        temp.register(PersonCustomCollectionCell.self, forCellWithReuseIdentifier: "PersonCustomCollectionCell")
        temp.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        self.view.addSubview(temp)
        return temp
    }()
    
//    private let bindArr: [String] = ["h_agreement_custom","h_agreement_check","h_lawyer_letter","h_notification_letter","h_litigant_document","h_meeting_consult"]
    private let bindArr: [String] = ["h_agreement_custom","h_agreement_check","h_lawyer_letter","h_notification_letter","h_litigant_document"]
    private var dataArr: [ProductListModel] = [ProductListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("h_person_custom")
        self.collectionV.reloadData()
    }

}

extension PersonCustomController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bindArr.count + (6 - bindArr.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item >= bindArr.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            cell.backgroundColor = kCellColor
            return cell
        }
        let bind = bindArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCustomCollectionCell", for: indexPath) as! PersonCustomCollectionCell
        cell.bind = bind
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (kDeviceWidth - 1) / 2
        let h = (kDeviceHeight - kTabBarHeight - 2) / 3
        return CGSize.init(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item >= bindArr.count {
            return
        }
        let bind = bindArr[indexPath.item]
        if bind == "h_meeting_consult" {
            let vc = PersonCustomMeetController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let vc = PersonCustomTextController()
        vc.titleBind = bind
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
