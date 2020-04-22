//
//  UIControlExtension.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import Foundation
import WebKit

/// 便利构造器即扩展方法功能
extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let context = UIGraphicsGetCurrentContext()
        context?.addRect(CGRect(x: 0, y: 0, width: 1, height: 1))
        color.set()
        context?.fillPath()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    class func navImage() -> UIImage {
        let bView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kNavHeight), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 0, y: 1), colors: [kNavGradeStartColor, kNavGradeEndColor])
        UIGraphicsBeginImageContextWithOptions(bView.bounds.size, false, UIScreen.main.scale)
        bView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    class func reminderImage() -> UIImage {
        let bView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 4, height: 18), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 0, y: 1), colors: [kNavGradeStartColor, kNavGradeEndColor])
        bView.layer.cornerRadius = 2
        bView.clipsToBounds = true
        UIGraphicsBeginImageContextWithOptions(bView.bounds.size, false, UIScreen.main.scale)
        bView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func changeImgBackgroundColor(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context?.fill(rect)
        let targetImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return targetImg
    }
}

extension UIButton {
    @objc convenience init(_ font: UIFont, _ color: UIColor, _ textAlignment: UIControl.ContentHorizontalAlignment, _ target: Any?, _ action: Selector?) {
        self.init(type: .custom)
        self.titleLabel?.font = font
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = .byTruncatingTail
        self.titleLabel?.numberOfLines = 0
        self.setTitleColor(color, for: .normal)
        self.contentHorizontalAlignment = textAlignment
        if action != nil {
            self.addTarget(target, action: action!, for: .touchUpInside)
        } else {
            self.isUserInteractionEnabled = false
        }
    }
}

extension UILabel {
    convenience init(_ font: UIFont, _ color: UIColor, _ textAlignment: NSTextAlignment) {
        self.init()
        self.font = font
        self.textColor = color
        self.textAlignment = textAlignment
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = 0
    }
    
}

extension UIImageView {
    convenience init(_ fillMode: UIView.ContentMode) {
        self.init()
        self.contentMode = fillMode
        if fillMode == UIView.ContentMode.scaleAspectFill {
            self.backgroundColor = kPlaceholderColor
            self.clipsToBounds = true
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
}

extension UIImagePickerController {
    convenience init(sourceType:UIImagePickerController.SourceType, mediaType:Int, allowsEditing: Bool) {
        self.init()
        self.sourceType = sourceType
        if mediaType == 1 {
            self.mediaTypes = [kUTTypeImage as String]
        } else if mediaType == 2 {
            self.mediaTypes = [kUTTypeMovie as String]
        } else if mediaType == 3 {
            self.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        }
        self.allowsEditing = allowsEditing
        self.navigationBar.setBackgroundImage(UIImage.navImage(), for: .default)
    }
    
    func resultImage(info: [UIImagePickerController.InfoKey : Any], isOriginal:Bool) -> UIImage? {
        let info = self.convertFromUIImagePickerControllerInfoKeyDictionary(info)
        var img: UIImage?
        if isOriginal {
            img = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        } else {
            img = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        }
        let result = img
        return result
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

extension UIView {
    convenience init(lineColor: UIColor) {
        self.init()
        self.backgroundColor = lineColor
    }
    
    convenience init(baseColor: UIColor) {
        self.init()
        self.backgroundColor = baseColor
        self.layer.cornerRadius = kBtnCornerR
        self.clipsToBounds = true
    }
    
    convenience init(frame: CGRect, startPoint: CGPoint, endPoint: CGPoint, colors:[Any]) {
        self.init(frame: frame)
        let gradientLayer = CAGradientLayer.init(frame: self.layer.bounds, startPoint: startPoint, endPoint: endPoint, colors: colors)
        self.layer.addSublayer(gradientLayer)
    }
}

extension UITableView {
    convenience init(frame: CGRect, style:UITableView.Style, space: CGFloat) {
        self.init(frame: frame, style: style)
        self.backgroundColor = UIColor.clear
        self.separatorStyle = .singleLine
        self.separatorColor = kLineGrayColor
        self.separatorInset = UIEdgeInsets.init(top: 0, left: space, bottom: 0, right: space)
        self.showsVerticalScrollIndicator = false
        self.estimatedRowHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
    }
    
}

extension UIScrollView {
    convenience init(frame: CGRect, contentSize: CGSize) {
        self.init(frame: frame)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.clear
        self.bounces = false
        self.contentSize = contentSize
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
    }
}

extension UICollectionView {
    convenience init(frame: CGRect, scrollDirection:UICollectionView.ScrollDirection) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        self.init(frame: frame, collectionViewLayout: layout)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
    }
}

extension WKWebView {
    convenience init(isOpaque: Bool) {
//        let jsString = String.init(format: "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=%d'); document.getElementsByTagName('head')[0].appendChild(meta);", kDeviceWidth - 30)
//        let wkUser = WKUserScript.init(source: jsString, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
//        let config = WKWebViewConfiguration()
//        config.userContentController.addUserScript(wkUser)
//        self.init(frame: CGRect(), configuration: config)
        self.init()
        self.isOpaque = isOpaque
        self.isUserInteractionEnabled = isOpaque
        self.backgroundColor = UIColor.clear
        self.scrollView.bounces = false
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
}

extension CAGradientLayer {
    convenience init(frame: CGRect, startPoint: CGPoint, endPoint: CGPoint, colors: [Any]) {
        self.init()
        self.frame = frame
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.colors = colors
    }
}
