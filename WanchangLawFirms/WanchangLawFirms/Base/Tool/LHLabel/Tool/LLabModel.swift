//
//  LLabModel.swift
//  LHLabel
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

enum LLabelDetectorType {
    case link
    case phoneNumber
    case none
}

class LLabModel: NSObject {
    
    var text: String
    var original_color: UIColor
    var click_color: UIColor
    
    var detectorType: LLabelDetectorType = .none
    var start: Int?
    
    init(text: String, original_color: UIColor, click_color: UIColor) {
        self.text = text
        self.original_color = original_color
        self.click_color = click_color
        super.init()
    }

}
