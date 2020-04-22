//
//  PCMDateCell.swift
//  OLegal
//
//  Created by lh on 2018/11/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会面咨询时间
class PCMDateCell: BaseCell {
    
    private let space1: CGFloat = 30
    private let space2: CGFloat = 15
    lazy var calendarV: PCMCalendarView = {
        () -> PCMCalendarView in
        let temp = PCMCalendarView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 260))
        self.addSubview(temp)
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.calendarV.isHidden = false
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
