//
//  MHFuncView.swift
//  OLegal
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我的头部（会员等级、会员编号、有效日期、会员性质等）
class MHFuncView: UIView {
    
    private lazy var per_w: CGFloat = {
        () -> CGFloat in
        let temp: CGFloat = (self.frame.size.width - 3) / 4
        return temp
    }()
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: self.bounds, scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.delegate = self
        temp.dataSource = self
        temp.register(MHFCollectionCell.self, forCellWithReuseIdentifier: "MHFCollectionCell")
        self.addSubview(temp)
        return temp
    }()
    
    private var dataArr: [MHFModel] = [MHFModel]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = kBtnCornerR
        self.setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(personDataRefresh), name: NSNotification.Name(rawValue: noti_user_model_refresh), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        var bindArr: [String] = ["m_vip_level","m_vip_number","m_vip_date","m_question_count"]
        if UserInfo.share.is_business {
            bindArr = ["m_vip_level","m_vip_number","m_vip_date","m_vip_property"]
        }
        for str in bindArr {
            let model = MHFModel.init(bind: str)
            dataArr.append(model)
        }
        self.collectionV.reloadData()
        
        let h: CGFloat = 25
        let space: CGFloat = (self.frame.size.height - h) / 2
        for i in 1...3 {
            let line: UIView = UIView.init(frame: CGRect.init(x: per_w * CGFloat(i), y: space, width: 1, height: h))
            line.backgroundColor = kLineGrayColor
            self.addSubview(line)
        }
        self.personDataRefresh()
    }
    
    @objc private func personDataRefresh() {
        self.collectionV.reloadData()
    }

}

extension MHFuncView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MHFCollectionCell", for: indexPath) as! MHFCollectionCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: per_w, height: self.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
