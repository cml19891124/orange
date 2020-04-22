//
//  JTitleChooseView.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JTitleChooseViewDelegate: NSObjectProtocol {
    func jtitleChooseViewSelected(model: JTitleChooseModel)
}

/// 标题、下划线、选中视图
class JTitleChooseView: UIView {
    
    weak var delegate: JTitleChooseViewDelegate?
    
    var dataArr: [JTitleChooseModel]! {
        didSet {
            if dataArr.count > 0 {
                if dataArr.count < 6 {
                    per_width = self.frame.size.width / CGFloat(dataArr.count)
                } else {
                    per_width = 80
                }
                self.collectionView.reloadData()
                self.selectedModel = dataArr[0]
            }
        }
    }
    
    private var selectedModel: JTitleChooseModel! {
        didSet {
            let text = L$(selectedModel.bind) as NSString
            let lineW = text.boundingRect(with: CGSize.init(width: self.frame.size.width, height: self.frame.size.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : selectedModel.textFont], context: nil).width + kLeftSpaceL
            lineV.frame = CGRect.init(x: CGFloat(selectedModel.tag - 1) * per_width + (per_width - lineW) / 2, y: self.frame.size.height - 2, width: lineW, height: 2)
            lineV.backgroundColor = selectedModel.lineColor
        }
    }
    
    private var per_width: CGFloat = 0.0
    
    private lazy var collectionView: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: self.bounds, scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.delegate = self
        temp.dataSource = self
        temp.register(JTitleChooseCell.self, forCellWithReuseIdentifier: "JTitleChooseCell")
        self.addSubview(temp)
        return temp
    }()
    
    private let lineV: UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.collectionView.reloadData()
        self.addSubview(lineV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectIndex(index: Int) {
        for i in 0..<dataArr.count {
            let m = dataArr[i]
            if i == index {
                m.selected = true
            } else {
                m.selected = false
            }
        }
        let m = dataArr[index]
        self.change(model: m)
    }
    
    private func change(model: JTitleChooseModel) {
        self.collectionView.reloadData()
        self.delegate?.jtitleChooseViewSelected(model: model)
        self.selectedModel = model
    }

}

extension JTitleChooseView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTitleChooseCell", for: indexPath) as! JTitleChooseCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: per_width, height: self.frame.size.height)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[indexPath.item]
        for m in dataArr {
            m.selected = false
        }
        model.selected = true
        self.change(model: model)
    }
}
