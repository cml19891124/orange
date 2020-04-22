//
//  MDHFileCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/21.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 订单详情附件
class MDHFileCell: BaseCell {
    
    var model: MessageFileModel! {
        didSet {
            let fileLogoImgName = JFileManager.share.getFileImgName(remotePath: model.file_path)
            fileLogoBtn.setImage(UIImage.init(named: fileLogoImgName), for: .normal)
            fileNameLab.text = model.file_name
            fileSizeLab.text = JPhotoManager.share.lengthStrFrom(length: Int(model.file_size))
        }
    }
    
    private let fileLogoBtn: UIButton = UIButton()
    private let fileNameLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let fileSizeLab: UILabel = UILabel.init(kFontS, kTextBlackColor, NSTextAlignment.left)
    
    private lazy var progressV: ProgressView = {
        () -> ProgressView in
        let temp = ProgressView.init(frame: CGRect.init(x: 0, y: 0, width: 38, height: 50))
        temp.isHidden = true
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        fileLogoBtn.isUserInteractionEnabled = false
        fileNameLab.adjustsFontSizeToFitWidth = false
        fileNameLab.lineBreakMode = .byTruncatingMiddle
        
        self.addSubview(fileLogoBtn)
        fileLogoBtn.addSubview(progressV)
        self.addSubview(fileNameLab)
        self.addSubview(fileSizeLab)
        
        _ = fileLogoBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(50)?.heightIs(50)
        _ = progressV.sd_layout()?.centerXEqualToView(fileLogoBtn)?.centerYEqualToView(fileLogoBtn)?.widthIs(38)?.heightIs(50)
        _ = fileNameLab.sd_layout()?.leftSpaceToView(fileLogoBtn, kLeftSpaceSS)?.rightSpaceToView(self, kLeftSpaceS)?.topEqualToView(fileLogoBtn)?.heightIs(38)
        _ = fileSizeLab.sd_layout()?.leftEqualToView(fileNameLab)?.rightEqualToView(fileNameLab)?.topSpaceToView(fileNameLab, 0)?.heightIs(12)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapClick() {
        let fileM = JFileModel.init(remotePath: model.file_path, name: model.file_name, fileSize: model.file_size)
        weak var weakSelf = self
        fileM.progress = { (value) in
            weakSelf?.progressV.progress = value
            weakSelf?.progressV.isHidden = false
        }
        fileM.success = { (endPath) in
            weakSelf?.progressV.isHidden = true
            if (endPath.haveTextStr()) {
                weakSelf?.jumpPreviewVC(path: OSSManager.initWithShare().savePath(fileM.localPath))
            }
        }
        let tempPath = JFileManager.share.alreadyExist(remotePath: fileM.remotePath)
        if tempPath != nil {
            self.jumpPreviewVC(path: OSSManager.initWithShare().savePath(tempPath!))
        } else {
            JFileManager.share.addTask(model: fileM)
        }
    }
    
    private func jumpPreviewVC(path: String) {
        let vc = JFilePreviewController()
        vc.path = path
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
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
