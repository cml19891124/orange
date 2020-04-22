//
//  ForensicCalculatorTextCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算文本
class ForensicCalculatorTextCell: BaseCell {
    
    var bind: String! {
        didSet {
            titleLab.text = " " + L$(bind) + "："
            let w = titleLab.sizeThatFits(CGSize.init(width: 200, height: 30)).width + kLeftSpaceL
            titleLab.frame.size = CGSize.init(width: w, height: 30)
        }
    }
    
    private lazy var titleLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.center)
        return temp
    }()
    
    lazy var tf: JTextField = {
        () -> JTextField in
        let temp = JTextField.init(font: kFontMS)
        temp.layer.cornerRadius = 20
        temp.layer.borderColor = kLineGrayColor.cgColor
        temp.layer.borderWidth = 1
        temp.leftViewMode = .always
        temp.leftView = titleLab
        return temp
    }()
    private let doneView: JKeyboardDoneView = JKeyboardDoneView.init(bind: "")
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        tf.keyboardType = .numberPad
        self.doneView.addTF(tf: tf)
        self.addSubview(tf)
        _ = tf.sd_layout()?.leftSpaceToView(self, 40)?.rightSpaceToView(self, 40)?.centerYEqualToView(self)?.heightIs(40)
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
