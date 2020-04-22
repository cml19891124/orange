//
//  UserInfo.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import AdSupport
import Photos

/// 单例 用户信息
class UserInfo: NSObject {
    @objc static let share = UserInfo()
    
    
    /// 语言
    @objc var language: String = "zh-Hans"
    
    /// 聊天字体
    var chatFont: UIFont = kFontMS
    
    /// 是否是测试服务器
    @objc let isTestServer: Bool = false
    /// Appstore版本号
    @objc var version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    /// 登录信息
    @objc var token: String?
    @objc var uid: String?
    @objc var aes_key: String?
    @objc var aes_iv: String?
    var expired: String?
    
    /// 个人资料
    var model: UserModel?
    /// 是否是企业版
    var is_business: Bool = true
    /// 企业信息
    var businessModel: MineBusinessModel?
    /// 企业用户列表
    var businessAccountArr: [UserModel] = [UserModel]()
    var is_tourist: Bool = false
    
    /// 手机号
    var mobile: String?
    /// 要更换的手机号
    var change_mobile: String?
    
    /// 企业登陆用户名
    var business_username: String?
    /// 企业登陆邮箱
    var business_email: String?
    
    /// 下单编号
    var order_sn: String?
    /// 下单类型1是问题和vip，2是其它
    var order_type: String?
    
    
    /// 下单完成后要跳转到聊天界面时的订单编号
    var chat_sn: String?
    
    /// 微信下单产生的编号
    var wexin_sn: String?
    
    /// 会话信息
    var serviceModel: MessageModel?
    
    
    /// 是否需要刷新本地缓存
    var refreshCaches: Bool = false
    /// vip信息
    private var vipListArr: [JVipListModel] = [JVipListModel]()
    
    /// 会话已获取服务端聊天消息时的记录，String为订单编号
    private var conversationLoadedArr: [String] = [String]()
    /// 未读消息数
    var conversationMsgUnReadCount: Int = 0
    
    override init() {
        super.init()
        token = UserInfo.defaultUserToken()
        expired = UserInfo.defaultUserExpired()
        aes_key = UserInfo.defaultUserAESKey()
        aes_iv = UserInfo.defaultUserAESIv()
        mobile = UserInfo.defaultUserMobile()
        uid = UserInfo.defaultUserUid()
        business_username = UserInfo.defaultBusinessUsername()
        business_email = UserInfo.defaultBusinessEmail()
        if UserInfo.defaultIsBusiness() == "1" {
            self.is_business = true
        }
        if UserInfo.defaultChatFont() == "m_font_big" {
            self.chatFont = kFontM
        } else if UserInfo.defaultChatFont() == "m_font_max" {
            self.chatFont = kFontL
        } else {
            self.chatFont = kFontMS
        }
    }
    
    /// 清除所有信息，发生在退出登陆。
    func clearAll() {
        JSocketHelper.share.closeSocket()
        UserInfo.setUserToken(text: nil)
        UserInfo.setUserExpired(text: nil)
        UserInfo.setUserAESKey(text: nil)
        UserInfo.setUserAESIv(text: nil)
        UserInfo.setIsBusiness(text: nil)
        model = nil
        change_mobile = nil
        order_sn = nil
        businessModel = nil
        serviceModel = nil
        ArticleManager.share.clearAll()
        vipListArr.removeAll()
        self.conversationLoadedClear()
    }
    
    /// 加载所有本地缓存，发生在进入app及重新登陆
    func localDataSource() {
        change_mobile = nil
        conversationLoadedArr = self.conversationLoadedGet()
        if uid != nil {
            model = RealmManager.share().getMyModel(uid!)
            businessModel = RealmManager.share().getMyBusiness(uid!)
        }
    }
    
    
    /// VIP信息列表，此处暂时为本地获取
    ///
    /// - Parameter success: VIP数据信息
    func getVipList(success:@escaping([JVipListModel]) -> Void) {
        if vipListArr.count > 0 && !refreshCaches {
            success(vipListArr)
            return
        }
        //1:288 2:488 3:698 1-2:208 1-3:418 2-3:208
        var idArr: [String] = ["1","2","3"]
        var nameArr: [String] = ["钻石会员","星耀会员","荣耀会员"]
        var priceArr: [String] = ["288","488","698"]
        var discountArr: [String] = ["0.9","0.8","0.7"]
        var expireArr: [String] = ["12","12","12"]
        var descArr: [String] = ["享有1个法律事件咨询机会、文书模版任意下载、免费浏览资讯板块","享有2个法律事件咨询机会、文书模版任意下载、免费浏览资讯板块","享有3个法律事件咨询机会、文书模版任意下载、免费浏览资讯板块"]
        if UserInfo.share.is_business {
            priceArr = ["3888","6888","12888"]
            descArr = ["享有无限个法律事件咨询机会、文书模版任意下载、免费浏览咨询板块","享有无限个法律事件咨询机会、文书定制审查36次（包含其它文书但不包含律师函）、文书模版任意下载、免费浏览资讯办款","享有无限个法律事件咨询机会、文书审查+文书定制不限次数（包含其它文书但不包含律师函）、律师约见6次，每次约见时长为2小时内、在原有基础上赠送1个子账号、律师函购买9折、企业培训共2次（以开通时间为基准，每6个月1次）、问题处理绿色通道（优先推送服务）、文书模版下载次数不限、免费浏览资讯板块"]
        }
        for i in 0...2 {
            let m = JVipListModel()
            m.id = idArr[i]
            m.vip_name = nameArr[i]
            m.price = priceArr[i]
            m.vip_discount = discountArr[i]
            m.vip_expire = expireArr[i]
            m.vip_info = descArr[i]
            vipListArr.append(m)
        }
        success(vipListArr)
    }
    
//    func getVipList(success:@escaping([JVipListModel]) -> Void) {
//        HomeManager.share.vipList(prams: NSDictionary()) { (arr) in
//            if arr != nil {
//                let result = arr!.sorted(by: { (m1, m2) -> Bool in
//                    return m1.index < m2.index
//                })
//                for m in result {
//                    self.vipListArr.append(m)
//                }
//            }
//            success(self.vipListArr)
//        }
//    }
    
    func getBusinessVipList(success:@escaping([JVipListModel]) -> Void) {
        if self.vipListArr.count > 0 {
            success(self.vipListArr)
            return
        }
        HomeManager.share.businessVipList(prams: NSDictionary()) { (arr) in
            if arr != nil {
                let result = arr!.sorted(by: { (m1, m2) -> Bool in
                    return m1.index < m2.index
                })
                for m in result {
                    self.vipListArr.append(m)
                }
            }
            success(self.vipListArr)
        }
    }

}

extension UserInfo {
//    var version: String {
//        get {
//            return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//        }
//    }
    
    /// 剩余问题数量
    var quality_count: Int {
        get {
            guard let temp1 = self.model?.quantity else {
                return 0
            }
            guard let temp2 = Int(temp1) else {
                return 0
            }
            return temp2
        }
    }
    
    /// 可选择的vip起始编号
    var vip_from_index: Int {
        get {
            if self.is_business {
                guard let str = self.businessModel?.vip else {
                    return 0
                }
                guard let temp = Int(str) else {
                    return 0
                }
                if temp > 0 {
                    return temp - 1
                }
//                if self.businessModel?.vip == "1" {
//                    return 0
//                } else if self.businessModel?.vip == "2" {
//                    return 1
//                } else if self.businessModel?.vip == "3" {
//                    return 2
//                }
            } else {
                if self.model?.vip == "1" {
                    return 0
                } else if self.model?.vip == "2" {
                    return 1
                } else if self.model?.vip == "3" {
                    return 2
                }
            }
            return 0
        }
    }
    
    /// 是否是vip
    var is_vip: Bool {
        get {
            if self.is_business {
                if self.businessModel?.vip == "0" {
                    return false
                }
            } else {
                if self.model?.vip == "0" {
                    return false
                }
            }
            return true
        }
    }
    
    /// 是否是企业母账号
    var isMother: Bool {
        get {
            if UserInfo.share.businessModel?.uid == UserInfo.share.uid {
                return true
            }
            return false
        }
    }
    
    /// 企业文书订制剩余次数
    var make_count: Int {
        get {
//            guard let temp1 = self.businessModel?.make_number else {
//                return 0
//            }
            guard let temp1 = self.businessModel?.file_number else {
                return 0
            }
            guard let temp2 = Int(temp1) else {
                return 0
            }
            if temp2 < 0 {
                return 0
            }
            return temp2
        }
    }
    
    /// 企业文书审查剩余次数
    var check_count: Int {
        get {
//            guard let temp1 = self.businessModel?.check_number else {
//                return 0
//            }
            guard let temp1 = self.businessModel?.file_number else {
                return 0
            }
            guard let temp2 = Int(temp1) else {
                return 0
            }
            if temp2 < 0 {
                return 0
            }
            return temp2
        }
    }
    
    var other_count: Int {
        get {
            guard let temp1 = self.businessModel?.file_number else {
                return 0
            }
            guard let temp2 = Int(temp1) else {
                return 0
            }
            if temp2 < 0 {
                return 0
            }
            return temp2
        }
    }
    
    var make_count_show_str: String {
        get {
            if UserInfo.share.businessModel?.vip == "0" || UserInfo.share.businessModel?.vip == "1" {
                return ""
            }
            return "(剩余次数:\(make_count)次)"
        }
    }
    
    var check_count_show_str: String {
        get {
            if UserInfo.share.businessModel?.vip == "0" || UserInfo.share.businessModel?.vip == "1" {
                return ""
            }
            return "(剩余次数:\(check_count)次)"
        }
    }
    
    var book_lawyer_show_str: String {
        get {
//            if UserInfo.share.businessModel?.vip == "4" {
//                return "(8.5折)"
//            } else if UserInfo.share.businessModel?.vip == "3" {
//                return "(9折)"
//            }
            return ""
        }
    }
    
    var book_other_show_str: String {
        get {
//            if UserInfo.share.businessModel?.vip == "4" {
//                return "(8.5折)"
//            } else if UserInfo.share.businessModel?.vip == "3" {
//                return "(9折)"
//            } else if UserInfo.share.businessModel?.vip == "2" {
//                return "(9.5折)"
//            }
            if UserInfo.share.businessModel?.vip == "0" || UserInfo.share.businessModel?.vip == "1" {
                return ""
            }
            return "(剩余次数:\(other_count)次)"
        }
    }
    
    /// 律师约见次数
    var meet_number: Int {
        get {
            guard let temp1 = self.businessModel?.meet_number else {
                return 0
            }
            guard let temp2 = Int(temp1) else {
                return 0
            }
            return temp2
        }
    }
    
    var train_number: Int {
        get {
            guard let temp1 = self.businessModel?.train_number else {
                return 0
            }
            guard let temp2 = Int(temp1) else {
                return 0
            }
            return temp2
        }
    }

}

/// 第一次打开应用
let standard_first_open: String = "standard_first_open"
/// 接收消息标识：11-声音震动 10-声音 01震动 00不提醒
let standard_noti_flag: String = "standard_noti_flag"
/// 用户token
let standard_user_token: String = "standard_user_token"
/// token过期时间
let standard_user_expired: String = "standard_user_expired"
/// 登录手机号
let standard_user_mobile: String = "standard_user_mobile"
/// 登录密码
let standard_user_password: String = "standard_user_password"
/// 登录uid
let standard_user_uid: String = "standard_user_uid"
/// 推送token
let standard_push_token = "standard_push_token"
/// 首页轮播
let standard_home_slider: String = "standard_home_slider"
/// 系统有新消息
let standard_system_msg_noti: String = "standard_system_msg_noti"
/// aes key
let standard_user_aes_key: String = "standard_user_aes_key"
/// aes iv
let standard_user_aes_iv: String = "standard_user_aes_iv"
/// 苹果支付后未请求服务端
let standard_apple_paid_uncommit: String = "standard_apple_paid_uncommit"
/// 是否是企业登陆
let standard_is_business: String = "standard_is_business"
/// 企业登陆用户名
let standard_business_username: String = "standard_business_username"
/// 企业登陆邮箱
let standard_business_email: String = "standard_business_email"
/// 聊天字体
let standard_font: String = "standard_font"
let standard_chat_online_service_msg = "standard_chat_online_service_msg"

let standard_leaded: String = "standard_leaded"

extension UserInfo {
    
    /// 沙盒存储
    ///
    /// - Parameters:
    ///   - key: 健
    ///   - text: 值
    class func setStandard(key: String, text: String?) {
        UserDefaults.standard.setValue(text, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getStandard(key: String) -> String? {
        return UserDefaults.standard.object(forKey: key) as? String
    }
    
    /// 用户登陆token
    ///
    /// - Parameter text: token
    class func setUserToken(text: String?) {
        UserInfo.share.token = text
        UserDefaults.standard.setValue(text, forKey: standard_user_token)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultUserToken() -> String? {
        return UserDefaults.standard.object(forKey: standard_user_token) as? String
    }
    
    /// 用户token过期时间
    ///
    /// - Parameter text: 过期时间
    class func setUserExpired(text: String?) {
        UserInfo.share.expired = text
        UserDefaults.standard.setValue(text, forKey: standard_user_expired)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultUserExpired() -> String? {
        return UserDefaults.standard.object(forKey: standard_user_expired) as? String
    }
    
    /// aes加密信息
    ///
    /// - Parameter text: aes key
    class func setUserAESKey(text: String?) {
        UserInfo.share.aes_key = text
        UserDefaults.standard.setValue(text, forKey: standard_user_aes_key)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultUserAESKey() -> String? {
        return UserDefaults.standard.object(forKey: standard_user_aes_key) as? String
    }
    
    /// aes加密信息
    ///
    /// - Parameter text: aes iv
    class func setUserAESIv(text: String?) {
        UserInfo.share.aes_iv = text
        UserDefaults.standard.setValue(text, forKey: standard_user_aes_iv)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultUserAESIv() -> String? {
        return UserDefaults.standard.object(forKey: standard_user_aes_iv) as? String
    }
    
    /// 登陆手机号
    ///
    /// - Parameter text: 手机号
    class func setUserMobile(text: String?) {
        UserInfo.share.mobile = text
        UserInfo.share.change_mobile = nil
        UserDefaults.standard.setValue(text, forKey: standard_user_mobile)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultUserMobile() -> String? {
        return UserDefaults.standard.object(forKey: standard_user_mobile) as? String
    }
    
    /// 登陆id
    ///
    /// - Parameter text: id
    class func setUserUid(text: String?) {
        UserInfo.share.uid = text
        UserDefaults.standard.setValue(text, forKey: standard_user_uid)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultUserUid() -> String? {
        return UserDefaults.standard.object(forKey: standard_user_uid) as? String
    }
    
    /// 是否是企业登陆
    ///
    /// - Parameter text: 1-企业登陆 2-个人登陆
    class func setIsBusiness(text: String?) {
        if text == "1" {
            UserInfo.share.is_business = true
        } else {
            UserInfo.share.is_business = false
        }
        UserDefaults.standard.setValue(text, forKey: standard_is_business)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultIsBusiness() -> String? {
        return UserDefaults.standard.object(forKey: standard_is_business) as? String
    }
    
    /// 企业用户名登陆
    ///
    /// - Parameter text: 企业用户名
    class func setBusinessUsername(text: String?) {
        UserInfo.share.business_username = text
        UserDefaults.standard.setValue(text, forKey: standard_business_username)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultBusinessUsername() -> String? {
        return UserDefaults.standard.object(forKey: standard_business_username) as? String
    }
    
    /// 企业邮箱登陆
    ///
    /// - Parameter text: 企业邮箱
    class func setBusinessEmail(text: String?) {
        UserInfo.share.business_email = text
        UserDefaults.standard.setValue(text, forKey: standard_business_email)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultBusinessEmail() -> String? {
        return UserDefaults.standard.object(forKey: standard_business_email) as? String
    }
    
    /// 设置聊天字体
    class func setChatFont(text: String?) {
        if text == "m_font_default" {
            UserInfo.share.chatFont = kFontMS
        } else if text == "m_font_big" {
            UserInfo.share.chatFont = kFontM
        } else if text == "m_font_max" {
            UserInfo.share.chatFont = kFontL
        }
        UserDefaults.standard.setValue(text, forKey: standard_font)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultChatFont() -> String? {
        return UserDefaults.standard.object(forKey: standard_font) as? String
    }
    
    class func chatOnlineServiceNoti(text: String?) {
        if text != nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_online_service_new), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_online_service_clear), object: nil)
        }
        UserDefaults.standard.setValue(text, forKey: standard_chat_online_service_msg)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultChatOnlineServiceNoti() -> String? {
        return UserDefaults.standard.object(forKey: standard_chat_online_service_msg) as? String
    }
    
    class func setPHAsset(text: String, asset: [PHAsset]) {
        UserDefaults.standard.setValue(asset, forKey: text)
        UserDefaults.standard.synchronize()
    }
    
    class func getPHAsset(text: String) -> [PHAsset]? {
        return UserDefaults.standard.object(forKey: text) as? [PHAsset]
    }
    
    class func setLeaded(text: String) {
        UserDefaults.standard.setValue("1", forKey: standard_leaded)
        UserDefaults.standard.synchronize()
    }
    
    class func defaultLeaded() -> Bool {
        if let _ = UserDefaults.standard.object(forKey: standard_leaded) as? String {
            return true
        }
        return false
    }
}

/// 会话是否已加载
let standard_conversation_loaded = "standard_conversation_loaded"

extension UserInfo {
    
    /// 已获取服务端聊天消息的会话处理
    ///
    /// - Parameter sn: 会话订单编号
    func conversationLoadedAdd(sn: String) {
        conversationLoadedArr.append(sn)
        UserDefaults.standard.setValue(conversationLoadedArr, forKey: standard_conversation_loaded)
        UserDefaults.standard.synchronize()
    }
    
    /// 判断是否需要获取某个会话的服务端聊天消息
    ///
    /// - Parameter sn: 订单编号
    /// - Returns: true-需要 false-不需要
    func conversationLoadedJudge(sn: String) -> Bool {
        if conversationLoadedArr.contains(sn) {
            return true
        }
        return false
    }
    
    /// 设置本地会话为未加载状态，发生在重新登陆
    private func conversationLoadedClear() {
        conversationLoadedArr.removeAll()
        UserDefaults.standard.setValue(nil, forKey: standard_conversation_loaded)
        UserDefaults.standard.synchronize()
    }
    
    /// 私有方法
    ///
    /// - Returns: 已加载过服务端聊天消息的订单编号
    private func conversationLoadedGet() -> [String] {
        guard let arr = UserDefaults.standard.object(forKey: standard_conversation_loaded) as? [String] else {
            return [String]()
        }
        return arr
    }
}

extension UserInfo {
    /// 用户个人信息
    @objc func netUserInfo() {
        HTTPManager.share.ask(isGet: true, url: api_user_info, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                self.model = UserModel.mj_object(withKeyValues: dict[net_key_result])
                guard let uid = self.model?.id else {
                    return
                }
                UserInfo.setUserUid(text: uid)
                let result: NSDictionary = dict[net_key_result] as! NSDictionary
                let resultStr: String = result.mj_JSONString()
                RealmManager.share().updateMyData(resultStr, uid: uid)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_user_model_refresh), object: nil)
                if self.is_business {
                    self.companyInfo()
                }
            } else {
                JRootVCManager.share.rootLogin()
            }
        }) { (error) in
            
        }
    }
    
    /// 修改用户个人信息
    ///
    /// - Parameters:
    ///   - prams: 用户信息
    ///   - success: 修改结果 true-修改成功  false-修改失败
    func netEditUser(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_user_info, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                PromptTool.promptText(L$("p_edit_success"), 1)
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 退出登陆
    func netLogout() {
        HTTPManager.share.ask(isGet: false, url: api_user_logout, prams: NSDictionary(), needPrompt: true, successHandler: { (dict) in
            JRootVCManager.share.rootLogin()
        }) { (error) in
            
        }
    }
    
    /// 手机号修改
    func netMobile(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_user_mobile, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 密码修改
    func netPassword(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_user_password, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                success(false)
                PromptTool.promptText(dict[net_key_msg], 1)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 刷新token，发生在打开app
    func netRefreshToken(success:@escaping()->Void) {
        let pushToken = UserInfo.getStandard(key: standard_push_token) ?? ""
        let idfv = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let prams: NSDictionary = ["push_type":"1","push_token":pushToken,"os_imei":idfv,"brand":"iPhone","model":"iPhone","os_type":"1"]
        HTTPManager.share.ask(isGet: false, url: api_user_refresh, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let token = dict[net_key_result] as? String
                UserInfo.setUserToken(text: token)
            }
            success()
        }) { (error) in
            success()
        }
    }
    
    ///服务端聊天消息
    func netChatCS(success:@escaping(MessageModel?) -> Void) {
        if serviceModel != nil {
            success(serviceModel)
            return
        }
        HTTPManager.share.ask(isGet: true, url: api_chat_cs, prams: NSDictionary(), needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let model = MessageModel.mj_object(withKeyValues: dict[net_key_result])
                self.serviceModel = model
                success(self.serviceModel)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
}

extension UserInfo {
    /// 企业信息
    func companyInfo() {
        HTTPManager.share.ask(isGet: true, url: api_company_info, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                self.businessModel = MineBusinessModel.mj_object(withKeyValues: dict[net_key_result])
                if self.model?.id != nil {
                    let result = dict[net_key_result] as? NSDictionary
                    let resultStr: String = result?.mj_JSONString() ?? ""
                    RealmManager.share().updateMyBusiness(resultStr, uid: (self.model?.id)!)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_business_refresh), object: nil)
            }
        }) { (err) in
            
        }
    }
    
    /// 修改企业信息
    func companyInfoUpdate(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_company_info_update, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
                self.companyInfo()
            } else {
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    /// 企业子账号列表
    func companyAccountList(success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_company_account_list, prams: NSDictionary(), needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = UserModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [UserModel]
                if arr != nil && arr!.count > 0 {
                    self.businessAccountArr = arr!
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_business_account_refresh), object: nil)
                    UserInfo.share.netUserInfo()
                    success(true)
                } else {
                    success(false)
                }
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
            }
        }) { (err) in
            success(false)
        }
    }
    
    /// 企业添加子账号
    func companyAccountAdd(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_company_account_add, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    /// 企业删除子账号
    func companyAccountDel(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_company_account_del, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    /// 企业转让
    func companyChange(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_company_change, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    /// 企业用户信息修改
    func companyAccountEdit(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_company_account_edit, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    func pubCheckUser(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_pub_check_user, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    func userDestroy(success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_user_destroy, prams: NSDictionary(), needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
}
