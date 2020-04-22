//
//  LoginTFBaseCell.swift
//  OLegal
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 登陆文本框基类
class LoginTFBaseCell: BaseCell {
    
    let tf: UITextField = UITextField()
    let lineV: UIView = UIView()
    let doneView: JKeyboardDoneView = JKeyboardDoneView.init(bind: "")
    var placeholder: String? {
        didSet {
            if placeholder != nil {
                self.tf.attributedPlaceholder = NSAttributedString.init(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
            }
        }
    }
    
    lazy var leftBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
        temp.frame.size = CGSize.init(width: 30, height: 30)
        return temp
    }()
    
    private var placeholderColor: UIColor = kPlaceholderColor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.doneView.addTF(tf: tf)
        self.baseSetupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseSetupViews() {
        tf.returnKeyType = .done
        tf.font = kFontM
        tf.leftViewMode = .always
        tf.leftView = leftBtn
        tf.textColor = kTextBlackColor
        
        lineV.backgroundColor = UIColor.clear
        self.addSubview(tf)
        self.addSubview(lineV)
        
        _ = tf.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.heightIs(30)
        _ = lineV.sd_layout()?.leftEqualToView(tf)?.rightEqualToView(tf)?.bottomEqualToView(self)?.heightIs(kLineHeight)
    }
    
    func colorSetup(placeholderColor: UIColor, lineColor: UIColor) {
        self.placeholderColor = placeholderColor
        self.lineV.backgroundColor = lineColor
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
