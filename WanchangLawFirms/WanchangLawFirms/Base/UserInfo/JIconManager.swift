//
//  JIconManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 图标类型
///
/// - spring: 春节图标
/// - none: 默认图标
/// TODO: 以后要添加的图标，如端午节、中秋节等。
enum JIconType {
    case spring
    case legal
    case boat
    case midAutumn
    case nation
    case none
}

/// 本地图片显示控制
class JIconManager: NSObject {
    static let share = JIconManager()
    
    /// 默认图标
    var icon_type: JIconType = JIconType.none
    
    /// 是否是春节假期 - 假期期间显示放假公告，不处理法律事务。
    var springRest: Bool = false
    
    override init() {
        super.init()
        self.dealCalendar()
        self.dealNation()
        self.legalJudge()
//        icon_type = .nation
    }
    
    private func dealCalendar() {
        let calendar = Calendar.init(identifier: Calendar.Identifier.chinese)
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "M-d"
        let result = formatter.string(from: Date.init())
        let month = result.components(separatedBy: CharacterSet.init(charactersIn: "-")).first
        let day = result.components(separatedBy: CharacterSet.init(charactersIn: "-")).last
        if day != nil {
            let count = Int(day!)
            if count != nil {
                if (month == "1" && count! > 0 && count! < 15) || (month == "12" && count! >= 15) {
                    icon_type = .spring
//                    if (month == "1" && count! < 5) || (month == "12" && count! > 23) { //27
//                        springRest = true
//                    }
                }
                if (month == "4" && count! > 20) || (month == "5") {
                    icon_type = .boat
                }
                if (month == "8" && count! >= 3 && count! <= 23) {
                    icon_type = .midAutumn
                }
            }
        }
    }
    
    private func dealNation() {
        let formatter = DateFormatter()
        formatter.dateFormat = "M-d"
        let result = formatter.string(from: Date.init())
        let month = result.components(separatedBy: CharacterSet.init(charactersIn: "-")).first
        if month == "10" {
            icon_type = .nation
        }
    }
    
    private func legalJudge() {
        let formatter = DateFormatter()
        formatter.dateFormat = "M-d"
        let result = formatter.string(from: Date.init())
        let month = result.components(separatedBy: CharacterSet.init(charactersIn: "-")).first
        let day = result.components(separatedBy: CharacterSet.init(charactersIn: "-")).last
        if day != nil {
            let count = Int(day!)
            if count != nil {
                if month == "4" {
                    if count! >= 8 {
                        icon_type = .legal
                    }
                }
            }
        }
    }
    
    /// 更换app Icon
    @objc func icon_spring() {
        self.changeAppIconWithName(iconName: "AppIcon_Spring_Festival")
    }
    
    /// 恢复app 默认Icon
    @objc func icon_recover() {
        self.changeAppIconWithName(iconName: nil)
    }
}

// MARK: - 更换App Icon
extension JIconManager {
    private func changeAppIconWithName(iconName: String?) {
        if #available(iOS 10.3, *) {
            if !UIApplication.shared.supportsAlternateIcons {
                return
            }
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.3, *) {
            UIApplication.shared.setAlternateIconName(iconName) { (err) in
                if (err != nil) {
                    DEBUG("更换app图标发生错误")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension JIconManager {
    /// 获取图片名字
    ///
    /// - Parameter bind: 健
    /// - Returns: 图片名称
    func getIcon(bind: String) -> String {
        var temp = bind
        switch icon_type {
        case .spring:
            temp += "_spring"
            break
        case .legal:
            temp += "_legal"
            break
        case .boat:
            temp += "_boat"
        case .midAutumn:
            temp += "_mid"
        case .nation:
            temp += "_nation"
        default:
            break
        }
        return temp
    }
}
