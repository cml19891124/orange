//
//  PhotoTFCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/14.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol PhotoTFCellDelegate: NSObjectProtocol {
    func photoTFCellClick()
}

/// 照片
class PhotoTFCell: LoginTFBaseCell {
    
    weak var delegate: PhotoTFCellDelegate?
    
    private lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick(sender:)))
        temp.layer.cornerRadius = kBtnCornerR
        temp.backgroundColor = kOrangeDarkColor
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.leftBtn.setImage(UIImage.init(named: "lr_code"), for: .normal)
        self.tf.rightViewMode = .always
        self.tf.rightView = btn
        self.tf.delegate = self
        self.titleStr(text: L$("upload_picture"))
    }
    
    @objc private func btnClick(sender: UIButton) {
        UIApplication.shared.keyWindow?.endEditing(true)
        self.delegate?.photoTFCellClick()
    }
    
    
    func titleStr(text: String) {
        btn.setTitle(text, for: .normal)
        let w = btn.sizeThatFits(CGSize.init(width: kDeviceWidth, height: 30)).width + kLeftSpaceS
        btn.frame.size = CGSize.init(width: w, height: 30)
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

extension PhotoTFCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIApplication.shared.keyWindow?.endEditing(true)
        self.delegate?.photoTFCellClick()
        return false
    }
}
