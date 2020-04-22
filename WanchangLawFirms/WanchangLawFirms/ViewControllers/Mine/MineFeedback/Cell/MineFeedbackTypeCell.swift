//
//  MineFeedbackTypeCell.swift
//  OLegal
//
//  Created by lh on 2018/11/25.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol MineFeedbackTypeCellDelegate: NSObjectProtocol {
    func mineFeedbackTypeCellClick(type: String)
}

class MineFeedbackTypeCell: BaseCell {
    
    weak var delegate: MineFeedbackTypeCellDelegate?
    
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: 10, width: kDeviceWidth, height: 50), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.bounces = false
        temp.delegate = self
        temp.dataSource = self
        temp.register(FCCCollectionCell.self, forCellWithReuseIdentifier: "FCCCollectionCell")
        self.addSubview(temp)
        return temp
    }()
    
//    private lazy var dataArr: [JBindModel] = {
//        () -> [JBindModel] in
//        let wordArr: [String] = ["m_question_consult","m_qustion_feedback","m_other"]
//        var temp = [JBindModel]()
//        for i in 0..<wordArr.count {
//            let m = JBindModel.init(bind: wordArr[i], font: kFontMS)
//            if i == 0 {
//                m.selected = true
//            }
//            temp.append(m)
//        }
//        return temp
//    }()
    private var dataArr: [JBindModel] = [JBindModel]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
//        self.collectionV.reloadData()
        self.getDataSource()
    }
    
    private func getDataSource() {
        HomeManager.share.serviceListShow { (arr) in
            self.dataArr.removeAll()
            if arr != nil && arr!.count > 0 {
                for m in arr! {
                    if m.cate_type == "1" {
                        let mo = JBindModel.init(bind: m.title, font: kFontMS)
                        mo.id = m.id
                        if mo.id == "2" {
                            mo.selected = true
                        }
                        self.dataArr.append(mo)
                    }
                }
            }
            let mo = JBindModel.init(bind: "m_other", font: kFontMS)
            mo.id = "1"
            self.dataArr.append(mo)
            self.collectionV.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MineFeedbackTypeCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FCCCollectionCell", for: indexPath) as! FCCCollectionCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataArr[indexPath.item]
        return CGSize.init(width: model.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[indexPath.item]
        for m in dataArr {
            m.selected = false
        }
        model.selected = true
        collectionView.reloadData()
//        self.delegate?.mineFeedbackTypeCellClick(type: "\(indexPath.item + 1)")
        self.delegate?.mineFeedbackTypeCellClick(type: model.id)
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
