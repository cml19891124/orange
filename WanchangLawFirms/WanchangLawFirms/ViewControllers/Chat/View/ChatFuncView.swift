//
//  ChatFuncView.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol ChatFuncViewDelegate: NSObjectProtocol {
    func chatFuncViewClick(bind: String)
}

/// 聊天功能视图
class ChatFuncView: UIView {

    weak var delegate: ChatFuncViewDelegate?
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: self.bounds, scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.backgroundColor = kBaseColor
        temp.delegate = self
        temp.dataSource = self
        temp.register(ChatFuncCollectionCell.self, forCellWithReuseIdentifier: "ChatFuncCollectionCell")
        self.addSubview(temp)
        return temp
    }()
    private let space: CGFloat = 10
    private lazy var per_wh: CGFloat = {
        () -> CGFloat in
        let temp = (kDeviceWidth - space * 5) / 4
        return temp
    }()
    private lazy var bindArr: [String] = ["chat_camera","chat_album","chat_file"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.collectionV.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ChatFuncView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        self.delegate?.chatFuncViewClick(bind: bind)
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
}
