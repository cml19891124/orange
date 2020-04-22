//
//  JObjectExtension.swift
//  zhirong
//
//  Created by lh on 2018/1/11.
//  Copyright © 2018年 gaming17. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    
    /// md5加密
    var md5: String {
        get {
            let str = self.cString(using: String.Encoding.utf8)
            let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
            let digestLen = Int(CC_MD5_DIGEST_LENGTH)
            let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
            CC_MD5(str!, strLen, result)
            let hash = NSMutableString()
            for i in 0 ..< digestLen {
                hash.appendFormat("%02x", result[i])
            }
            free(result)
            return String(format: hash as String)
        }
    }
    
    /// 是否包含emoji表情
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F:// Emoticons
                return true
            case 0x1F300...0x1F5FF: // Misc Symbols and Pictographs
                return true
            case 0x1F680...0x1F6FF: // Transport and Map
                return true
            case 0x2600...0x26FF:   // Misc symbols
                return true
            case 0xFE00...0xFE0F:   // Variation Selectors
                return true
            case 0x1F900...0x1F9FF:  // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// 过滤掉空字符串后，是否有文本
    func haveTextStr() -> Bool {
        let set = NSCharacterSet.whitespacesAndNewlines
        let trimedString = self.trimmingCharacters(in: set)
        if trimedString.count > 0 {
            return true
        }
        return false
    }
    
    /// 服务端返回的数据是否有内容，包括空字符串，只要长度>0，即视为有内容
    func haveContentNet() -> Bool {
        if self.count > 0 {
            return true
        }
        return false
    }
    
    /// 日期 - 年月日
    func theDateYMDStr() -> String {
        var timeString = "---"
        if self.count >= 10 {
            let x: TimeInterval = TimeInterval(self[..<self.index(self.startIndex, offsetBy: 10)])!
            let date = Date.init(timeIntervalSince1970: x)
            let calendar = Calendar.init(identifier: .gregorian)
            let componentsSet = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
            let comps = calendar.dateComponents(componentsSet, from: date)
            let year = comps.year!
            let month = comps.month!
            let day = comps.day!
            timeString = String.init(format: "%d-%02d-%02d", year, month, day)
        }
        return timeString
    }
    
    /// 日期 - 年月日
    func theDateYMDPointSeparateStr() -> String {
        var timeString = "---"
        if self.count >= 10 {
            let x: TimeInterval = TimeInterval(self[..<self.index(self.startIndex, offsetBy: 10)])!
            let date = Date.init(timeIntervalSince1970: x)
            let calendar = Calendar.init(identifier: .gregorian)
            let componentsSet = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
            let comps = calendar.dateComponents(componentsSet, from: date)
            let year = comps.year!
            let month = comps.month!
            let day = comps.day!
            timeString = String.init(format: "%d.%02d.%02d", year, month, day)
        }
        return timeString
    }
    
    /// 日期 - 年月日时分秒
    func theDateYMDHMSStrFromNumStr() -> String {
        var timeString: String = "---"
        if self.count >= 10 {
            let x: TimeInterval = TimeInterval(self[..<self.index(self.startIndex, offsetBy: 10)])!
            let date = Date.init(timeIntervalSince1970: x)
            let calendar = Calendar.init(identifier: .gregorian)
            let componentsSet = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
            let comps = calendar.dateComponents(componentsSet, from: date)
            let year = comps.year!
            let month = comps.month!
            let day = comps.day!
            let hour = comps.hour!
            let minute = comps.minute!
            let second = comps.second!
            timeString = String.init(format: "%d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second)
        }
        return timeString
    }
    
    /// 聊天页的时间显示
    func theChatTimeFromNumStr() -> String {
        var timeString = "---"
        if self.count >= 10 {
            let x: TimeInterval = TimeInterval(self[..<self.index(self.startIndex, offsetBy: 10)])!
            let date = Date.init(timeIntervalSince1970: x)
            let calendar = Calendar.init(identifier: .gregorian)
            let componentsSet = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
            let comps = calendar.dateComponents(componentsSet, from: date)
            let year = comps.year!
            let month = comps.month!
            let day = comps.day!
            let hour = comps.hour!
            let minute = comps.minute!
            if date.isThisYear() {
                if date.isToday() {
                    let t1 = date.timeIntervalSince1970
                    let t2 = Date().timeIntervalSince1970
                    let interval = Int(t2 - t1)
                    if interval / 3600 < 1 {
                        if interval / 60 < 1 {
                            timeString = "刚刚"
                        } else {
                            timeString = String.init(format: "%d分钟前", interval / 60)
                        }
                    } else {
                        timeString = String.init(format: "今天 %02d:%02d", hour, minute)
                    }
                } else if date.isYesterday() {
                    timeString = String.init(format: "昨天 %02d:%02d", hour, minute)
                } else {
                    timeString = String.init(format: "%02d月%02d日 %02d:%02d", month, day, hour, minute)
                }
            } else {
                timeString = String.init(format: "%d年%02d月%02d日 %02d:%02d", year, month, day, hour, minute)
            }
        }
        return timeString
    }
    
    /// 文字高度
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let ns = self as NSString
        let h = ns.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).height
        return h
    }
    
}

extension Double {
    /// 只舍不入
    public func floorTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return floor(self * divisor) / divisor
    }
}

extension Date {
    /// 日期 - 是否是今年
    func isThisYear() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .month, .year]
        let nowCmps = calendar.dateComponents(unit, from: Date())
        let selCmps = calendar.dateComponents(unit, from: self)
        return nowCmps.year == selCmps.year
    }
    
    /// 日期 - 是否是今天
    func isToday() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .month, .year]
        let nowCmps = calendar.dateComponents(unit, from: Date())
        let selCmps = calendar.dateComponents(unit, from: self)
        return (nowCmps.year == selCmps.year) && (nowCmps.month == selCmps.month) && (nowCmps.day == selCmps.day)
    }
    
    /// 日期 - 是否是明天
    func isTomorrow() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let t1 = Int(Date().timeIntervalSince1970)
        let t2 = t1 + 3600 * 24
        let tomorrowStr: String = formatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(t2)))
        let tempStr: String = formatter.string(from: self)
        return tomorrowStr == tempStr
    }
    
    /// 日期 - 是否是后天
    func isAfterTomorrow() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let t1 = Int(Date().timeIntervalSince1970)
        let t2 = t1 + 3600 * 24 * 2
        let tomorrowStr: String = formatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(t2)))
        let tempStr: String = formatter.string(from: self)
        return tomorrowStr == tempStr
    }
    
//    func miniDays() -> Int {
//        let calendar = Calendar.current
//        let unit: Set<Calendar.Component> = [.day, .month, .year]
//        let nowCmps = calendar.dateComponents(unit, from: Date())
//        let selCmps = calendar.dateComponents(unit, from: self)
//        if selCmps.day == nil || nowCmps.day == nil {
//            return 0
//        }
//        let count = nowCmps.day! - selCmps.day!
//        return (nowCmps.year == selCmps.year) && (nowCmps.month == selCmps.month) && count == -2
//    }
    
    /// 日期 - 是否是昨天
    func isYesterday() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .month, .year]
        let nowCmps = calendar.dateComponents(unit, from: Date())
        let selCmps = calendar.dateComponents(unit, from: self)
        if selCmps.day == nil || nowCmps.day == nil {
            return false
        }
        let count = nowCmps.day! - selCmps.day!
        return (nowCmps.year == selCmps.year) && (nowCmps.month == selCmps.month) && (count == 1)
    }
    
    /// 日期 - 是否是周末
    func isWeekends() -> Bool {
        let calendar = Calendar.init(identifier: .gregorian)
        let comps = calendar.component(Calendar.Component.weekday, from: self)
        if comps == 1 || comps == 7 {
            return true
        }
        return false
    }
    
    func weekdayStr() -> String {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.weekday]
        let selCmps = calendar.dateComponents(unit, from: self)
        let week = selCmps.weekday
        if week == 1 {
            return "星期日"
        } else if week == 2 {
            return "星期一"
        } else if week == 3 {
            return "星期二"
        } else if week == 4 {
            return "星期三"
        } else if week == 5 {
            return "星期四"
        } else if week == 6 {
            return "星期五"
        } else if week == 7 {
            return "星期六"
        }
        return ""
    }
}
