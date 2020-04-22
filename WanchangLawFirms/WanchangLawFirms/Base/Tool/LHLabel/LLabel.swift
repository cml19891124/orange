//
//  LLabel.swift
//  LHLabel
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol LLabelDelegate: NSObjectProtocol {
    func llabelClick(text: String)
}

/// 自定义UILabel，可点击指定文字实现文字变色，根据KMP模式匹配算法和链表实现，若难以理解，可抹掉。
class LLabel: UILabel {
    
    weak var delegate: LLabelDelegate?
    
    private var dataArr: [LLabModel] = [LLabModel]()
    private var model: LLabModel?
    private var original_attri: NSAttributedString?
    
    override var text: String? {
        didSet {
            dataArr.removeAll()
            if text != nil {
                if detector_original_color != nil && detector_original_color != nil {
                    self.detectorDeal(original_color: detector_original_color!, click_color: detector_click_color!)
                }
            }
        }
    }
    private var detector_original_color: UIColor?
    private var detector_click_color: UIColor?
    
    convenience init(font: UIFont, textAlignment: NSTextAlignment) {
        self.init()
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = 0
    }
    
    func enableDetector(original_color: UIColor, click_color: UIColor) {
        self.detector_original_color = original_color
        self.detector_click_color = click_color
    }
    
    func addClickText(str: String, original_color: UIColor, click_color: UIColor) {
        self.isUserInteractionEnabled = true
        for model in dataArr {
            if model.text == str {
                return
            }
        }
        let m = LLabModel.init(text: str, original_color: original_color, click_color: click_color)
        dataArr.append(m)
        var mulStr: NSMutableAttributedString
        if self.attributedText != nil {
            mulStr = NSMutableAttributedString.init(attributedString: self.attributedText!)
        } else {
            mulStr = NSMutableAttributedString.init(string: self.text!)
        }
        let from = KMPTool.share.kmp(str: self.text!, ptn: str)
        if from >= 0 {
            mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: original_color, range: NSRange.init(location: from, length: str.count))
        }
        self.attributedText = mulStr
        self.original_attri = self.attributedText
    }
    
    func clearAll() {
        self.dataArr.removeAll()
        self.model = nil
        self.original_attri = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let point = touches.first?.location(in: self) else {
            return
        }
        self.model = nil
        self.pointDeal(point: point)
        self.modelClickBegin()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.attributedText = original_attri
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isUserInteractionEnabled = false
        self.perform(#selector(modelClickEnd), with: nil, afterDelay: 0.25)
    }
}

extension LLabel {
    private func detectorDeal(original_color: UIColor, click_color: UIColor) {
        self.linkDetector(original_color: original_color, click_color: click_color)
//        self.phoneNumberDetector(original_color: original_color, click_color: click_color)
    }
    
    private func addDetectorClick(str: String, detectorType: LLabelDetectorType, original_color: UIColor, click_color: UIColor) {
        self.isUserInteractionEnabled = true
        for model in dataArr {
            if model.text == str {
                return
            }
        }
        let m = LLabModel.init(text: str, original_color: original_color, click_color: click_color)
        m.detectorType = detectorType
        dataArr.append(m)
        var mulStr: NSMutableAttributedString
        if self.attributedText != nil {
            mulStr = NSMutableAttributedString.init(attributedString: self.attributedText!)
        } else {
            mulStr = NSMutableAttributedString.init(string: self.text!)
        }
        let from = KMPTool.share.kmp(str: self.text!, ptn: str)
        if from >= 0 {
            mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: original_color, range: NSRange.init(location: from, length: str.count))
            mulStr.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber.init(value: NSUnderlineStyle.single.rawValue), range: NSRange.init(location: from, length: str.count))
        }
        self.attributedText = mulStr
        self.original_attri = self.attributedText
    }
}

extension LLabel {
    private func linkDetector(original_color: UIColor, click_color: UIColor) {
        let detector = try? NSDataDetector.init(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let res = detector?.matches(in: text!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: text!.count))
        var urlArr = [String]()
        if res != nil {
            for r in res! {
                urlArr.append((text! as NSString).substring(with: r.range))
            }
        }
        for str in urlArr {
            self.addDetectorClick(str: str, detectorType:.link, original_color: original_color, click_color: click_color)
        }
    }
    
    private func phoneNumberDetector(original_color: UIColor, click_color: UIColor) {
        let detector = try? NSDataDetector.init(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
        let res = detector?.matches(in: text!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: text!.count))
        var urlArr = [String]()
        if res != nil {
            for r in res! {
                urlArr.append((text! as NSString).substring(with: r.range))
            }
        }
        for str in urlArr {
            self.addDetectorClick(str: str, detectorType:.phoneNumber, original_color: original_color, click_color: click_color)
        }
    }
}

extension LLabel {
    
    private func modelClickBegin() {
        guard let str = self.text else {
            return
        }
        guard let m = model else {
            return
        }
        var start = 0
        if m.start != nil {
            start = m.start! + 1
        }
        var temp: NSAttributedString
        if self.original_attri != nil {
            temp = self.original_attri!
        } else {
            temp = NSAttributedString.init(string: str)
        }
        let mulStr = NSMutableAttributedString.init(attributedString: temp)
        mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: (model?.click_color)!, range: NSRange.init(location: start, length: (model?.text.count)!))
        self.attributedText = mulStr
    }
    
    @objc private func modelClickEnd() {
        self.attributedText = original_attri
        self.isUserInteractionEnabled = true
        guard let m = self.model else {
            return
        }
        DEBUG(m.text)
        if m.detectorType == .none {
            self.delegate?.llabelClick(text: m.text)
        } else {
            let alertCon = UIAlertController.init(title: "选择方式", message: nil, preferredStyle: .actionSheet)
            let actionCopy = UIAlertAction.init(title: L$("copy"), style: .default) { (action) in
                let past = UIPasteboard.general
                past.string = m.text
            }
            let actionOpen = UIAlertAction.init(title: L$("open_in_browser"), style: .default) { (action) in
                let url = URL.init(string: m.text)
                if url != nil {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url!)
                    }
                }
            }
            let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
            if m.detectorType == .link {
                alertCon.addAction(actionCopy)
                alertCon.addAction(actionOpen)
            } else if m.detectorType == .phoneNumber {
                alertCon.addAction(actionCopy)
            }
            alertCon.addAction(actionCancel)
            JAuthorizeManager.init(view: self).responseChainViewController().present(alertCon, animated: true, completion: nil)
            return
        }
    }
    
}

extension LLabel {
    
    private func pointDeal(point: CGPoint) {
        guard let tempStr = self.text else {
            return
        }
        let tempSize = self.sizeThatFits(CGSize.init(width: self.frame.size.width, height: self.frame.size.height))
        var ori_x: CGFloat = 0
        if self.textAlignment == .center {
            ori_x = (self.frame.size.width - tempSize.width) / 2
        } else if textAlignment == .right {
            ori_x = self.frame.size.width - tempSize.width
        }
        let l_rect = CGRect.init(x: ori_x, y: (self.frame.size.height - tempSize.height) / 2, width: tempSize.width, height: tempSize.height)
        
        let lineH = font.lineHeight
        let row_total: Int = Int(l_rect.size.height / lineH)
        
        var deviation: CGFloat = 0
        if row_total == 1 {
            deviation = lineH
        }
        
        let condition1 = point.x > l_rect.origin.x
        let condition2 = point.x < l_rect.origin.x + l_rect.size.width
        let condition3 = point.y - l_rect.origin.y > -deviation
        let condition4 = point.y - (l_rect.origin.y + l_rect.size.height) < deviation
        
        if condition1 && condition2 && condition3 && condition4 {
            let l_x = point.x - l_rect.origin.x
            let l_y = point.y - l_rect.origin.y
            if l_x > 0 && l_y > -deviation {
                var current_row = 0
                if row_total > 1 {
                    current_row = Int(l_y / lineH)
                }
                
                let list = LHelper.share.addList(text: tempStr, font: font)
                
                var from_x: CGFloat = 0
                
                if current_row == row_total - 1 {
                    let pre_total_w: CGFloat = l_rect.size.width * CGFloat(current_row)
                    var node = list.tail
                    var last_row_w: CGFloat = 0
                    while node != nil {
                        last_row_w += node!.width
                        if pre_total_w >= node!.start && pre_total_w <= node!.end {
                            break
                        }
                        node = node?.previous
                    }
                    if textAlignment == .center {
                        from_x = (l_rect.size.width - last_row_w) / 2
                    } else if textAlignment == .right {
                        from_x = l_rect.size.width - last_row_w
                    }
                }
                let result_x = l_x - from_x
                if result_x > 0 {
                    let cal_x = result_x + CGFloat(current_row) * l_rect.size.width
                    var current = list.head
                    while current != nil {
                        if cal_x >= current!.start && cal_x <= current!.end {
                            self.clickNodeDeal(node: current!)
                            break
                        }
                        current = current?.next
                    }
                }
                
            }
        }
        
    }
    
    private func clickNodeDeal(node: LNode) {
        for m in dataArr {
            m.start = nil
            let str = m.text
            var indexArr: [Int] = [Int]()
            var index = 0
            var find = false
            for c in str {
                if c == Character.init(node.showStr) {
                    find = true
                    indexArr.append(index)
                }
                index += 1
            }
            if find {
                for i in indexArr {
                    var current: LNode? = node
                    var tempStr: String = ""
                    for _ in 0...i {
                        if current != nil {
                            let str = current!.showStr
                            tempStr = str + tempStr
                            current = current?.previous
                        } else {
                            break
                        }
                    }
                    m.start = current?.tag
                    current = node.next
                    for _ in 0..<str.count - i - 1 {
                        if current != nil {
                            let str = current!.showStr
                            tempStr += str
                            current = current?.next
                        } else {
                            break
                        }
                    }
                    if tempStr == str {
                        self.model = m
                        return
                    }
                }
            }
        }
    }
    
}
