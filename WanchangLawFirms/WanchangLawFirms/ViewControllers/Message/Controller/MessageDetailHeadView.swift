//
//  MessageDetailHeadView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/14.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol MessageDetailHeadViewDelegate: NSObjectProtocol {
    func messageDetailHeadViewClick(arr: [JImgModel], selectModel: JImgModel)
}

/// 订单详情头部
class MessageDetailHeadView: UIView {
    
    var model: MessageModel!
    weak var delegate: MessageDetailHeadViewDelegate?
    
    private var modelArr: [JImgModel] = [JImgModel]()
    
    private let avatarImgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    private let nameLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let contentLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private lazy var collectionV: UICollectionView = {
        () -> UICollectionView in
        let temp = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceWidth), scrollDirection: UICollectionView.ScrollDirection.vertical)
        temp.delegate = self
        temp.dataSource = self
        temp.register(JPhotoResultShowCell.self, forCellWithReuseIdentifier: "JPhotoResultShowCell")
        return temp
    }()
    private var fileModelArr: [MessageFileModel] = [MessageFileModel]()
    private lazy var tableView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect(), style: .plain, space: 0)
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(MDHFileCell.self, forCellReuseIdentifier: "MDHFileCell")
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(model: MessageModel) {
        self.init()
        self.model = model
        self.fileModelArr = model.fileModelArr
        self.dealDataSource()
    }
    
    private func setupViews() {
        self.addSubview(avatarImgView)
        self.addSubview(nameLab)
        self.addSubview(timeLab)
        self.addSubview(contentLab)
        self.addSubview(collectionV)
        self.addSubview(tableView)
        
        _ = avatarImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = nameLab.sd_layout()?.leftSpaceToView(avatarImgView, kLeftSpaceS)?.topEqualToView(avatarImgView)?.rightSpaceToView(self, kLeftSpaceS)?.heightIs(20)
        _ = timeLab.sd_layout()?.leftEqualToView(nameLab)?.rightEqualToView(nameLab)?.topSpaceToView(nameLab, 0)?.heightIs(20)
    }
    
    private func dealDataSource() {
        avatarImgView.avatar = model.avatar
        timeLab.text = model.created_at.theDateYMDHMSStrFromNumStr()
        nameLab.text = model.name
        contentLab.text = model.desc
        if model.order_status == "0" || model.order_status == "4" || model.order_status == "5" {
            nameLab.text = "订单价格：¥" + model.amount
            nameLab.textColor = kOrangeDarkColor
        }
        var imgsArr: [String] = [String]()
        let arr = self.model.images.components(separatedBy: CharacterSet.init(charactersIn: ","))
        for s in arr {
            if s.haveTextStr() == true {
                imgsArr.append(s)
            }
        }
        modelArr.removeAll()
        for str in imgsArr {
            let m = JImgModel()
            m.remotePath = str
            modelArr.append(m)
        }
        self.collectionV.reloadData()
        let contentH = contentLab.sizeThatFits(CGSize.init(width: kDeviceWidth - kLeftSpaceS * 2, height: kDeviceHeight)).height
        var imgsH: CGFloat = kCellSpaceL
        if modelArr.count > 0 {
            let row = ((modelArr.count - 1) / 3 + 1)
            let perH = (kDeviceWidth - kLeftSpaceS * 4) / 3
            imgsH = perH * CGFloat(row) + kLeftSpaceS * CGFloat(row + 1)
        }
        let topH: CGFloat = kLeftSpaceS + kLeftSpaceS + kAvatarWH
        contentLab.frame = CGRect.init(x: kLeftSpaceS, y: topH, width: kDeviceWidth - kLeftSpaceS * 2, height: contentH)
        collectionV.frame = CGRect.init(x: 0, y: topH + contentH, width: kDeviceWidth, height: imgsH)
        
        let filesH: CGFloat = CGFloat(fileModelArr.count * 70)
        tableView.frame = CGRect.init(x: 0, y: topH + contentH + imgsH, width: kDeviceWidth, height: filesH)
        tableView.reloadData()
        
        self.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: topH + contentH + imgsH + filesH)
    }
    
}

extension MessageDetailHeadView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = modelArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JPhotoResultShowCell", for: indexPath) as! JPhotoResultShowCell
        JImageDownloadManager.share.snapOSSPath(path: model.remotePath) { (endPath) in
            model.snapImg = UIImage.init(contentsOfFile: endPath)
            cell.imgView.image = model.snapImg
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modelArr[indexPath.item]
        self.delegate?.messageDetailHeadViewClick(arr: modelArr, selectModel: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (kDeviceWidth - kLeftSpaceS * 4) / 3, height: (kDeviceWidth - kLeftSpaceS * 4) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kLeftSpaceS
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kLeftSpaceS
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: kLeftSpaceS, left: kLeftSpaceS, bottom: kLeftSpaceS, right: kLeftSpaceS)
    }
}

extension MessageDetailHeadView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let m = fileModelArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDHFileCell", for: indexPath) as! MDHFileCell
        cell.model = m
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
