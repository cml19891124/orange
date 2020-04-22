//
//  DocumentTemplateChooseView.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 文书模版选择视图
class DocumentTemplateChooseView: UIView {
    
    weak var delegate: JTitleChooseViewDelegate?
    var modelArr: [HCategoryModel]! {
        didSet {
            if dataArr.count > 0 {
                return
            }
            for i in 0..<modelArr.count {
                let cM = modelArr[i]
                let jM = JTitleChooseModel.init(bind: cM.title, normalTextColor: kTextBlackColor, selectedTextColor: kTextBlackColor, lineColor: kOrangeLightColor, textFont: kFontM, tag: i + 1)
                dataArr.append(jM)
            }
            self.collectionV.reloadData()
        }
    }
    private var dataArr: [JTitleChooseModel] = [JTitleChooseModel]()
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: self.bounds, scrollDirection: UICollectionView.ScrollDirection.vertical)
        temp.delegate = self
        temp.dataSource = self
        temp.register(DTCCollectionCell.self, forCellWithReuseIdentifier: "DTCCollectionCell")
        self.addSubview(temp)
        return temp
    }()
    private lazy var per_w: CGFloat = {
        () -> CGFloat in
        return self.frame.size.width
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kBaseColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DocumentTemplateChooseView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DTCCollectionCell", for: indexPath) as! DTCCollectionCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.item]
        for m in self.dataArr {
            m.selected = false
        }
        model.selected = true
        collectionView.reloadData()
        self.delegate?.jtitleChooseViewSelected(model: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: per_w, height: kCellHeight)
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
