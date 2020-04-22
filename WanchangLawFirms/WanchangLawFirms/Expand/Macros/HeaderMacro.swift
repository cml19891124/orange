//
//  HeaderMacro.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import Foundation
import UIKit

/// 自定义颜色
func customColor(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
    return UIColor(red: (r) / 255.0, green: (g) / 255.0, blue: (b) / 255.0, alpha: 1.0)
}

func customColor(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor(red: (r) / 255.0, green: (g) / 255.0, blue: (b) / 255.0, alpha: a)
}

/// 语言选择
func L$(_ string: String) -> String {
    let path = Bundle.main.path(forResource: UserInfo.share.language, ofType: "lproj")
    return Bundle.init(path: path!)!.localizedString(forKey: string, value: nil, table: "Localizable")
}

/// 黄金比例高度，在不确定高度时探寻合适高度，仅做参考
func goldBigHeight(_ h: CGFloat) -> CGFloat {
    return (sqrt(5) - 1) / 2 * h
}

/// 只在debug环境下打印
func DEBUG(_ items: Any...) {
    #if DEBUG
    for str in items {
        print(str, separator: "", terminator: "")
    }
    print("")
    #else
    #endif
}

/// 导航栏高度，状态栏高度+44
var kNavHeight: CGFloat = {
    if kDeviceWidth == 375 && kDeviceHeight == 812 {
        return 88
    }
    if kDeviceWidth == 414 && kDeviceHeight == 896 {
        return 88
    }
    return 64
}()

/// UItabBar高度 底部空白高度 + 49
var kTabBarHeight: CGFloat {
    if kDeviceWidth == 375 && kDeviceHeight == 812 {
        return 83
    }
    if kDeviceWidth == 414 && kDeviceHeight == 896 {
        return 83
    }
    return 49
}

/// 状态栏高度
var kBarStatusHeight: CGFloat = {
    if kDeviceWidth == 375 && kDeviceHeight == 812 {
        return 44
    }
    if kDeviceWidth == 414 && kDeviceHeight == 896 {
        return 44
    }
    return 20
}()

/// 底部空白高度
var kXBottomHeight: CGFloat = {
    if kDeviceWidth == 375 && kDeviceHeight == 812 {
        return 34
    }
    if kDeviceWidth == 414 && kDeviceHeight == 896 {
        return 34
    }
    return 0
}()

/// 屏幕宽高
let kDeviceWidth: CGFloat = UIScreen.main.bounds.size.width
let kDeviceHeight: CGFloat = UIScreen.main.bounds.size.height

//字体大小，差值为2
let kFontXXL = UIFont.systemFont(ofSize: 30)
let kFontXL = UIFont.systemFont(ofSize: 25)
let kFontLL = UIFont.systemFont(ofSize: 20)
let kFontL = UIFont.systemFont(ofSize: 18)
let kFontM = UIFont.systemFont(ofSize: 16)
let kFontMS = UIFont.systemFont(ofSize: 14)
let kFontS = UIFont.systemFont(ofSize: 12)
let kFontSS = UIFont.systemFont(ofSize: 10)

//颜色
let kBaseColor = customColor(248, 248, 248)
let kCellColor = UIColor.white

let kNavColor = customColor(249, 123, 10)

let kPlaceholderColor = customColor(220, 220, 220)
let kLineGrayColor = customColor(242,242,242)
let kGrayColor = customColor(206, 206, 206)

let kSpringColor = customColor(65, 59, 57)

let kTextBlackColor = customColor(24, 24, 24)
let kTextLightBlackColor = customColor(72, 72, 72)
let kTextGrayColor = customColor(112, 112, 112)
let kOrangeLightColor = customColor(247, 193, 115)
let kOrangeDarkColor = customColor(250, 135, 7)
let kRedColor = customColor(250, 80, 1)

let kTextBlackClickColor = customColor(24, 24, 24, 0.5)
let kTextGrayClickColor = customColor(112, 112, 112, 0.5)
let kOrangeDarkClickColor = customColor(250, 135, 7, 0.5)

/// UIButton按钮渐变色
let kBtnGradeStartColor: CGColor = customColor(246, 178, 112).cgColor
let kBtnGradeEndColor: CGColor = customColor(235, 98, 3).cgColor
/// 导航栏渐变色
let kNavGradeStartColor: CGColor = customColor(235, 95, 1).cgColor
let kNavGradeEndColor: CGColor = customColor(240, 134, 52).cgColor
/// 视图渐变色
let kViewGradeStartColor: CGColor = customColor(232, 85, 1).cgColor
let kViewGradeEndColor: CGColor = customColor(245, 164, 96).cgColor



//间距
let kLeftSpaceL: CGFloat = 20
let kLeftSpaceM: CGFloat = 15
let kLeftSpaceS: CGFloat = 10
let kLeftSpaceSS: CGFloat = 5

let kCellHeight: CGFloat = 55
let kCellSpaceL: CGFloat = 10
let kCellSpaceS: CGFloat = 6
let kLineHeight: CGFloat = 0.5


let kBtnCornerR: CGFloat = 5

//固定尺寸
/// 向右箭头
let kArrowWH: CGFloat = 12
/// 头像
let kAvatarWH: CGFloat = 40
let kBubbleSpaceL: CGFloat = 12
let kBubbleSpaceS: CGFloat = 7
let kBubbleWidthMin: CGFloat = 50
let kBubbleHeightMin: CGFloat = 40

//固定字符串
let kBtnSpaceString: String = "  "


let noti_net_not_avaliable = "noti_net_not_avaliable"
let noti_net_status_change = "noti_net_status_change"
let noti_user_model_refresh = "noti_user_model_refresh"
let noti_user_order_change = "noti_user_order_change"
let noti_jump_to_chat = "noti_jump_to_chat"
let noti_dealing_msg_need_refresh = "noti_dealing_msg_need_refresh"
let noti_home_slider_refresh = "noti_home_slider_refresh"
let noti_system_msg_refresh = "noti_system_msg_refresh"
let noti_system_msg_read = "noti_system_msg_read"
let noti_chat_hangeup_keyboard = "noti_chat_hangeup_keyboard"
let noti_order_transform = "noti_order_transform"
let noti_chat_tabview_begin_scroll = "noti_chat_tabview_begin_scroll"
let noti_chat_tabview_end_scroll = "noti_chat_tabview_end_scroll"
let noti_business_refresh = "noti_business_refresh"
let noti_business_account_refresh = "noti_business_account_refresh"
let noti_online_service_new = "noti_online_service_new"
let noti_online_service_clear = "noti_online_service_clear"
let noti_tourist_back = "noti_tourist_back"
let noti_tab_back = "noti_tab_back"

/// 服务端固定参数
let net_key_code = "code"
let net_key_msg = "msg"
let net_key_result = "result"

/// 聊天消息
/// 文本消息
let socket_value_text = 1
/// 大表情消息
let socket_value_emo = 2
/// 图片消息
let socket_value_img = 3
/// 文件消息
let socket_value_file = 4
/// 已读消息
let socket_value_read = 5
/// 撤回消息
let socket_value_withdrew = 6

/// 图片、文件消息时附加的参数
let socket_key_msg_image_width = "msg_image_width"
let socket_key_msg_image_height = "msg_image_height"
let socket_key_msg_image_size = "msg_image_size"
let socket_key_msg_file_name = "msg_file_name"
let socket_key_msg_file_length = "msg_file_length"
