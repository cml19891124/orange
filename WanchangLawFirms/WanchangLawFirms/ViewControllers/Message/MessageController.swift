//
//  MessageController.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会话列表
class MessageController: BaseController {
    private lazy var topV: MessageTopView = {
        () -> MessageTopView in
        let temp = MessageTopView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: 50))
        temp.topV.delegate = self
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: 50 + kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kTabBarHeight - 50), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.isScrollEnabled = false
        temp.delegate = self
        temp.dataSource = self
        temp.register(MessageDealingCollectionCell.self, forCellWithReuseIdentifier: "MessageDealingCollectionCell")
        temp.register(MessageFinishCollectionCell.self, forCellWithReuseIdentifier: "MessageFinishCollectionCell")
        temp.register(MessageSystemCollectionCell.self, forCellWithReuseIdentifier: "MessageSystemCollectionCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var loginView: JTouristLoginView = {
        () -> JTouristLoginView in
        let temp = JTouristLoginView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kTabBarHeight))
        return temp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UserInfo.share.is_tourist {
            MessageManager.share.onGoRefresh()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = L$("message")
        if UserInfo.share.is_tourist {
            self.touristDeal()
        } else {
            self.topV.isHidden = false
            self.collectionV.reloadData()
            MessageManager.share.onGoRefresh()
        }
    }
    
    private func touristDeal() {
        self.view.addSubview(loginView)
    }
}

extension MessageController: JTitleChooseViewDelegate {
    func jtitleChooseViewSelected(model: JTitleChooseModel) {
        self.collectionV.setContentOffset(CGPoint.init(x: CGFloat(model.tag - 1) * kDeviceWidth, y: 0), animated: false)
    }
}

extension MessageController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageDealingCollectionCell", for: indexPath) as! MessageDealingCollectionCell
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageFinishCollectionCell", for: indexPath) as! MessageFinishCollectionCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageSystemCollectionCell", for: indexPath) as! MessageSystemCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kTabBarHeight - 50)
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
