//
//  ForensicCalculatorExtenCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol ForensicCalculatorExtenCellDelegate: NSObjectProtocol {
    func forensicCalculatorExtenCellClick(bind: String)
}

/// 计算器扩展
class ForensicCalculatorExtenCell: ForensicCalculatorTextCell {
    
    weak var delegate: ForensicCalculatorExtenCellDelegate?
    
    private let arrow: UIButton = UIButton.init(kFontS, kTextGrayColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.tf.delegate = self
        arrow.frame.size = CGSize.init(width: 40, height: 40)
        arrow.setImage(UIImage.init(named: "triangle_down_orange"), for: .normal)
        self.tf.rightViewMode = .always
        self.tf.rightView = arrow
        
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

extension ForensicCalculatorExtenCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.forensicCalculatorExtenCellClick(bind: bind)
        return false
    }
}
