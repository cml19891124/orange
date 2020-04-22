//
//  ForensicCalculatorChooseView.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol ForensicCalculatorChooseViewDelegate: NSObjectProtocol {
    func forensicCalculatorChooseViewClick(bind: String)
}

class ForensicCalculatorChooseView: UIView {
    
    weak var delegate: ForensicCalculatorChooseViewDelegate?
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: (self.frame.size.height - 50) / 2, width: self.frame.size.width, height: 50), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.bounces = false
        temp.delegate = self
        temp.dataSource = self
        temp.register(FCCCollectionCell.self, forCellWithReuseIdentifier: "FCCCollectionCell")
        self.addSubview(temp)
        return temp
    }()
    private lazy var modelArr: [JBindModel] = {
        () -> [JBindModel] in
        let bindArr: [String] = ["h_worker_compensation","h_traffic_compensation","h_lawyer_fee_calculation","h_litigation_cost_calculation"]
        var temp: [JBindModel] = [JBindModel]()
        for i in 0..<bindArr.count {
            let bind = bindArr[i]
            let model: JBindModel = JBindModel.init(bind: bind, font: kFontMS)
            if i == 0 {
                model.selected = true
            }
            temp.append(model)
        }
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        self.refresh()
    }
    
    private func refresh() {
        self.collectionV.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ForensicCalculatorChooseView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = modelArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FCCCollectionCell", for: indexPath) as! FCCCollectionCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = modelArr[indexPath.item]
        return CGSize.init(width: model.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modelArr[indexPath.item]
        for m in modelArr {
            m.selected = false
        }
        model.selected = true
        self.refresh()
        self.delegate?.forensicCalculatorChooseViewClick(bind: model.bind)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kLeftSpaceS
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: kLeftSpaceS, bottom: 0, right: kLeftSpaceS)
    }
}
