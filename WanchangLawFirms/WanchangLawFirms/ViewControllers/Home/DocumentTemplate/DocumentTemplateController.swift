//
//  DocumentTemplateController.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 文书模版
class DocumentTemplateController: BaseController {
    
    var categoryModelArr: [HCategoryModel] = [HCategoryModel]()
    
    private let choose_width: CGFloat = 80
    private lazy var chooseV: DocumentTemplateChooseView = {
        () -> DocumentTemplateChooseView in
        let temp = DocumentTemplateChooseView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: choose_width, height: kDeviceHeight - kNavHeight))
        temp.delegate = self
        self.view.addSubview(temp)
        return temp
    }()
    private var tempY: CGFloat = 0.0
    private lazy var enterView: JImgViewSelfAdapt = {
        () -> JImgViewSelfAdapt in
        let temp = JImgViewSelfAdapt.init(imgName: "document_enter", wid: kDeviceWidth - choose_width - kLeftSpaceS * 2)
        temp.frame = CGRect.init(x: choose_width + kLeftSpaceS, y: kLeftSpaceS + kNavHeight, width: kDeviceWidth - choose_width - kLeftSpaceS * 2, height: temp.end_height)
        tempY = temp.end_height + kLeftSpaceS
        temp.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(enterClick))
        temp.addGestureRecognizer(tap)
        return temp
    }()
    private lazy var explainView: JImgViewSelfAdapt = {
        () -> JImgViewSelfAdapt in
        let temp = JImgViewSelfAdapt.init(imgName: "document_business_explain", wid: kDeviceWidth - choose_width - kLeftSpaceS * 2)
        temp.frame = CGRect.init(x: choose_width + kLeftSpaceS, y: kLeftSpaceS + kNavHeight, width: kDeviceWidth - choose_width - kLeftSpaceS * 2, height: temp.end_height)
        tempY = temp.end_height + kLeftSpaceS
        return temp
    }()
    private lazy var per_w: CGFloat = {
        () -> CGFloat in
        let temp = kDeviceWidth - choose_width
        return temp
    }()
    private lazy var per_h: CGFloat = {
        () -> CGFloat in
        let temp = kDeviceHeight - kNavHeight - tempY
        return temp
    }()
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: choose_width, y: tempY + kNavHeight, width: per_w, height: per_h), scrollDirection: UICollectionView.ScrollDirection.horizontal)
        temp.delegate = self
        temp.dataSource = self
        temp.isPagingEnabled = true
        temp.isScrollEnabled = false
        for m in categoryModelArr {
            temp.register(DocumentTemplateCollectionCell.self, forCellWithReuseIdentifier: m.id)
        }
        self.view.addSubview(temp)
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("h_document_template")
        self.view.backgroundColor = kCellColor
        if UserInfo.share.is_business {
            self.view.addSubview(explainView)
        } else {
            self.view.addSubview(enterView)
        }
        self.chooseV.modelArr = self.categoryModelArr
        self.collectionV.reloadData()
    }
    
    @objc private func enterClick() {
        if UserInfo.share.is_business {
            let vc = ZZBusinessSecondController()
            vc.titleBind = "h_business_book_custom"
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = PersonCustomTextController()
            vc.titleBind = "h_agreement_custom"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension DocumentTemplateController: JTitleChooseViewDelegate {
    func jtitleChooseViewSelected(model: JTitleChooseModel) {
        self.collectionV.setContentOffset(CGPoint.init(x: CGFloat(model.tag - 1) * per_w, y: 0), animated: false)
    }
}

extension DocumentTemplateController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryModelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.categoryModelArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.id, for: indexPath) as! DocumentTemplateCollectionCell
        cell.cModel = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: per_w, height: per_h)
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
