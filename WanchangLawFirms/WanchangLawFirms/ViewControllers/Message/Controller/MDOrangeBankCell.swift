//
//  MDOrangeBankCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/27.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MDOrangeBankCell: BaseCell {

    let bankView = OrangeBankView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 400))
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(bankView)
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
