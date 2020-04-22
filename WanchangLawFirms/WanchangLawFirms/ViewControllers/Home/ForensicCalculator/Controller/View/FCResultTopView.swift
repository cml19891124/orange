//
//  FCResultTopView.swift
//  OLegal
//
//  Created by lh on 2018/11/29.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算结果顶部视图
class FCResultTopView: UIView {
    
    var model: ForensicCalculatorModel! {
        didSet {
            var wordArr: [String] = [String]()
            if model.bind == "h_worker_compensation" {
                let str1 = "地区：" + model.areaModel!.name
                let str2 = "等级：" + model.levelModel!.val
                let str3 = "工资：" + model.text! + "元/月"
                wordArr = [str1, str2, str3]
            } else if model.bind == "h_traffic_compensation" {
                let str1 = "地区：" + model.areaModel!.name
                let str2 = "户口：" + model.hokouModel!.val
                let str3 = "等级：" + model.levelModel!.val
                let str4 = "年龄：" + model.text!
                wordArr = [str1, str2, str3, str4]
            }
            for i in 0..<wordArr.count {
                let m = JBindModel.init(bind: wordArr[i], font: kFontMS)
                modelArr.append(m)
            }
            self.collectionV.reloadData()
        }
    }
    var calcuteResult: String! {
        didSet {
            let str1 = "合计/元 （仅为勾选项的总和）\n\n"
            let str2 = calcuteResult!
            let totalStr = str1 + str2
            let mulStr = NSMutableAttributedString.init(string: totalStr)
            mulStr.addAttribute(NSAttributedString.Key.font, value: kFontXL, range: NSRange.init(location: str1.count, length: str2.count))
            resultLab.attributedText = mulStr
        }
    }
    private lazy var modelArr: [JBindModel] = [JBindModel]()
    
    private lazy var topV: UIView = {
        () -> UIView in
        let temp = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: self.frame.size.height - 50 - kCellSpaceL))
        let gradLayer = CAGradientLayer.init(frame: temp.bounds, startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 0, y: 1), colors: [kViewGradeStartColor, kViewGradeEndColor])
        temp.layer.addSublayer(gradLayer)
        return temp
    }()
    private let resultLab: UILabel = UILabel.init(kFontMS, UIColor.white, NSTextAlignment.center)
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: self.frame.size.height - 50 - kCellSpaceL, width: kDeviceWidth, height: 50), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.backgroundColor = kCellColor
        temp.delegate = self
        temp.dataSource = self
        temp.register(FCCCollectionCell.self, forCellWithReuseIdentifier: "FCCCollectionCell")
        self.addSubview(temp)
        return temp
    }()
    private lazy var spaceV: UIView = {
        () -> UIView in
        let temp = UIView.init(frame: CGRect.init(x: 0, y: self.frame.size.height - kCellSpaceL, width: kDeviceWidth, height: kCellSpaceL))
        temp.backgroundColor = kBaseColor
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.collectionV.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(topV)
        topV.addSubview(resultLab)
        self.addSubview(spaceV)
        _ = resultLab.sd_layout()?.leftSpaceToView(topV, kLeftSpaceL)?.rightSpaceToView(topV, kLeftSpaceL)?.bottomSpaceToView(topV, 0)?.topSpaceToView(topV, kNavHeight)
    }

}

extension FCResultTopView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        return CGSize.init(width: model.width, height: 30)
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
