//
//  ChatContentSearchBar.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol ChatContentSearchBarDelegate: NSObjectProtocol {
    func chatContentSearchBarTextChange(text: String)
}

class ChatContentSearchBar: UISearchBar {
    
    weak var search_delegate: ChatContentSearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.returnKeyType = .done
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundImage = UIImage.imageWithColor(UIColor.clear)
        guard let tf = self.subviews.first?.subviews.last else {
            return
        }
        tf.backgroundColor = kBaseColor
        tf.frame = CGRect.init(x: 10, y: 7, width: kDeviceWidth - 60, height: 36)
        for v1 in self.subviews {
            for v2 in v1.subviews {
                if (v2 is UITextField) {
                    let temp = v2 as? UITextField
                    temp?.textColor = kTextBlackColor
                    break
                }
            }
        }
    }

}

extension ChatContentSearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = searchBar.text else {
            return true
        }
        if str.count + text.count > 100 {
            return false
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let result = (searchText as NSString).replacingOccurrences(of: "\\", with: "")
        self.search_delegate?.chatContentSearchBarTextChange(text: result)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
    }
}
