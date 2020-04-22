//
//  ForensicCalculatorOKCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算按钮
class ForensicCalculatorOKCell: BaseCell {
    
    lazy var calView: JCalculateResetView = {
        () -> JCalculateResetView in
        let temp = JCalculateResetView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth - 80, height: 40))
        temp.getDataSource(bind1: "reset", bind2: "calculate")
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(calView)
        _ = calView.sd_layout()?.leftSpaceToView(self, 40)?.rightSpaceToView(self, 40)?.centerYEqualToView(self)?.heightIs(40)
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
