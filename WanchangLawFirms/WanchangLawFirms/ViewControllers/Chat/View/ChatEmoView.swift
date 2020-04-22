//
//  ChatEmoView.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol ChatEmoViewDelegate: NSObjectProtocol {
    func chatEmoViewClick(bind: String)
}

/// 聊天emoji表情视图
class ChatEmoView: UIView {

    weak var delegate: ChatEmoViewDelegate?
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: self.bounds, scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.backgroundColor = kBaseColor
        temp.delegate = self
        temp.dataSource = self
        temp.isPagingEnabled = true
        temp.register(ChatFuncCollectionCell.self, forCellWithReuseIdentifier: "ChatFuncCollectionCell")
        self.addSubview(temp)
        return temp
    }()
    private lazy var pageCon: JPageControl = {
        () -> JPageControl in
        let temp = JPageControl.init(frame: CGRect.init(x: kDeviceWidth / 2 - 50, y: self.frame.size.height, width: 100, height: 30))
        temp.numberOfPages = 3
        self.addSubview(temp)
        return temp
    }()
    private let space: CGFloat = 10
    private lazy var per_wh: CGFloat = {
        () -> CGFloat in
        let temp = (kDeviceWidth - space * 5) / 4
        return temp
    }()
    private lazy var bindArr: [String] = ["new_ee_angry","new_ee_anzhongguancha","new_ee_baonu","new_ee_bixin","new_ee_chongbai","new_ee_daku","new_ee_dazhaohu","new_ee_dianzan","new_ee_hanyan","new_ee_haohuang","new_ee_jiayou","new_ee_jingya","new_ee_kun","new_ee_no","new_ee_ok","new_ee_sujing","new_ee_touxiao","new_ee_tuxue","new_ee_wa","new_ee_wolaile","new_ee_wozoule","new_ee_wuyu","new_ee_yiwen","new_ee_yun"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.collectionV.reloadData()
        self.pageCon.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatEmoView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bind = bindArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatFuncCollectionCell", for: indexPath) as! ChatFuncCollectionCell
        cell.btn.setImage(UIImage.init(named: bind), for: .normal)
        cell.btn.setTitle(L$(bind), for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bind = bindArr[indexPath.item]
        self.delegate?.chatEmoViewClick(bind: bind)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: per_wh, height: per_wh)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: space, left: space, bottom: space, right: space)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + 50) / kDeviceWidth)
        self.pageCon.currentPage = index
    }
}
