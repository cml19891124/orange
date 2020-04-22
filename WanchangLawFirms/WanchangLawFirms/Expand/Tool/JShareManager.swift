//
//  JShareManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/11/29.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

//1 男； 2 女

/// 三方授权管理：QQ、微信、微博
class JShareManager: NSObject {
    static let share = JShareManager()
    
    private var tencentOAuth: TencentOAuth?
    
    private var prompt: MBProgressHUD?
    
//    private var shareLink: String = "https://itunes.apple.com/cn/app/id1318568813?mt=8"
    private let shareLink: String = "https://app.wanchangorange.com/web-im/share.html"
    private let shareTitle: String = "欧伶猪法律法务咨询"
    private let shareDesc: String = "欧伶猪法务法律咨询，是一款由专业律师团队在线，能及时、高效的协助处理法律事务问题的在线交流平台。"
    
    override init() {
        super.init()
        tencentOAuth = TencentOAuth.init(appId: appKey_QQ, andDelegate: self)
        tencentOAuth?.redirectURI = "www.qq.com"
        WeiboSDK.registerApp(appKey_sina)
    }
    
}

extension JShareManager {
    private func removePrompt() {
        prompt?.removeFromSuperview()
        prompt = nil
    }
}

extension JShareManager: TencentSessionDelegate {
    func authQQLogin() {
        let permissions = ["get_user_info","add_share"]
        tencentOAuth?.authorize(permissions, inSafari: false)
    }
    
    func tencentDidLogin() {
        prompt = PromptTool.promptText("正在获取信息")
        tencentOAuth?.getUserInfo()
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        self.removePrompt()
        if tencentOAuth != nil && tencentOAuth!.accessToken.count > 0 {
            guard let result = response.jsonResponse else {
                return
            }
            let avatar: String = result["figureurl_qq_2"] as? String ?? ""
            let nickname: String = result["nickname"] as? String ?? ""
            var sex = "2"
            if result["gender"] as? String == "男" {
                sex = "1"
            }
            let prams: NSDictionary = ["auth_type":"1","auth_token":tencentOAuth!.openId,"avatar":avatar,"nickname":nickname,"sex":sex]
            LRManager.share.pubLoginOauth(prams: prams)
        }
    }
}

extension JShareManager: WXApiDelegate {
    func authWechatLogin() {
        let req = SendAuthReq()
        req.state = "wx_oauth_authorization_state"
        req.scope = "snsapi_userinfo"
        WXApi.send(req)
    }
    
    func onResp(_ resp: BaseResp!) {
        if resp is SendAuthResp {
            prompt = PromptTool.promptText("正在获取信息")
            let req = resp as! SendAuthResp
            if req.state == "wx_oauth_authorization_state" {
                let tokenUrl = String.init(format: "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", appKey_wechat, appSecret_wechat, req.code)
                HTTPManager.share.other_ask(isGet: true, url: tokenUrl, prams: NSDictionary(), needPrompt: false, successHandler: { (dict1) in
                    guard let access_token = dict1["access_token"] as? String else {
                        self.removePrompt()
                        return
                    }
                    guard let openid = dict1["openid"] as? String else {
                        self.removePrompt()
                        return
                    }
                    let infoUrl = String.init(format: "https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", access_token, openid)
                    HTTPManager.share.other_ask(isGet: true, url: infoUrl, prams: NSDictionary(), needPrompt: false, successHandler: { (dict2) in
                        self.removePrompt()
                        let avatar = dict2["headimgurl"] as? String ?? ""
                        let nickname = dict2["nickname"] as? String ?? ""
                        let temp = dict2["sex"] as? Int
                        var sex = ""
                        if temp != nil {
                            sex = "\(temp!)"
                        }
                        let prams: NSDictionary = ["auth_type":"2","auth_token":openid,"avatar":avatar,"nickname":nickname,"sex":sex]
                        LRManager.share.pubLoginOauth(prams: prams)
                    }, fail: { (err) in
                        
                    })
                }) { (error) in
                    
                }
            }
        } else if resp is PayResp {
            UserInfo.share.wexin_sn = nil
            let result = resp as! PayResp
            var success: Bool = false
            if result.errCode == 0 {
                success = true
            }
            JPayApiManager.share.delegate?.jPayApiManagerPayResult(success: success)
        }
    }
    
    func onReq(_ req: BaseReq!) {
        
    }
    
    func wechatPayCheck() {
        self.perform(#selector(delayCheck), with: nil, afterDelay: 1)
    }
    
    @objc private func delayCheck() {
        UserInfo.share.wexin_sn = nil
        JPayApiManager.share.pay_check()
    }
}

extension JShareManager: WeiboSDKDelegate {
    func authWeiboLogin() {
        let request = WBAuthorizeRequest.request() as? WBAuthorizeRequest
        request?.redirectURI = "http://www.baidu.com"
        request?.scope = "all"
        WeiboSDK.send(request)
    }
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        if response is WBAuthorizeResponse {
            let temp = response as! WBAuthorizeResponse
            let dict = temp.userInfo
            guard let auth_token = temp.userID else {
                return
            }
            let appDict = dict?["app"] as? NSDictionary
            let avatar = appDict?["logo"] as? String ?? ""
            let nickname = appDict?["name"] as? String ?? ""
            let prams: NSDictionary = ["auth_type":"3","auth_token":auth_token,"avatar":avatar,"nickname":nickname,"sex":""]
            LRManager.share.pubLoginOauth(prams: prams)
        }
    }
}

extension JShareManager {
    func bindShare(bind: String) {
        if bind == "qq" || bind == "qq_space" {
            self.qqBindShare(bind: bind)
        } else if bind == "wechat" || bind == "wechat_coil" {
            self.wechatBindShare(bind: bind)
        } else if bind == "weibo" {
            self.weiboBindShare(bind: bind)
        }
    }
    
    private func qqBindShare(bind: String) {
        let obj = QQApiNewsObject.init(url: URL.init(string: shareLink), title: shareTitle, description: shareDesc, previewImageData: UIImage.init(named: "orange_icon")?.jpegData(compressionQuality: 0.9), targetContentType: QQApiURLTargetTypeNews)
        let req = SendMessageToQQReq.init(content: obj)
        JQueueManager.share.mainAsyncQueue {
            if bind == "qq" {
                QQApiInterface.send(req)
            } else if bind == "qq_space" {
                QQApiInterface.sendReq(toQZone: req)
            }
        }
    }
    
    private func wechatBindShare(bind: String) {
        let message = WXMediaMessage()
        message.title = shareTitle
        message.description = shareDesc
        message.setThumbImage(UIImage.init(named: "orange_icon"))
        let webObj = WXWebpageObject()
        webObj.webpageUrl = shareLink
        message.mediaObject = webObj
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        if bind == "wechat" {
            req.scene = Int32(WXSceneSession.rawValue)
        } else {
            req.scene = Int32(WXSceneTimeline.rawValue)
        }
        WXApi.send(req)
    }
    
    private func weiboBindShare(bind: String) {
        let webpage = WBWebpageObject.init()
        webpage.objectID = shareLink
        webpage.title = shareTitle
        webpage.description = shareDesc
        webpage.thumbnailData = UIImage.init(named: "orange_icon")?.jpegData(compressionQuality: 0.9)
        webpage.webpageUrl = shareLink
        let obj = WBMessageObject.init()
        obj.mediaObject = webpage
        let request = WBSendMessageToWeiboRequest.request(withMessage: obj) as? WBSendMessageToWeiboRequest
        WeiboSDK.send(request)
    }
}

extension JShareManager {
    func shareArticle(bind: String, link: String, title: String, subTitle: String) {
        if bind == "qq" || bind == "qq_space" {
            self.qqShareArticle(bind: bind, link: link, title: title, subTitle: subTitle)
        } else if bind == "wechat" || bind == "wechat_coil" {
            self.wechatShareArticle(bind: bind, link: link, title: title, subTitle: subTitle)
        } else if bind == "weibo" {
            self.weiboShareArticle(bind: bind, link: link, title: title, subTitle: subTitle)
        }
    }
    
    private func qqShareArticle(bind: String, link: String, title: String, subTitle: String) {
        let obj = QQApiNewsObject.init(url: URL.init(string: link), title: title, description: subTitle, previewImageData: UIImage.init(named: "orange_icon")?.jpegData(compressionQuality: 0.9), targetContentType: QQApiURLTargetTypeNews)
        let req = SendMessageToQQReq.init(content: obj)
        JQueueManager.share.mainAsyncQueue {
            if bind == "qq" {
                QQApiInterface.send(req)
            } else if bind == "qq_space" {
                QQApiInterface.sendReq(toQZone: req)
            }
        }
    }
    
    private func wechatShareArticle(bind: String, link: String, title: String, subTitle: String) {
        let message = WXMediaMessage()
        message.title = title
        message.description = subTitle
        message.setThumbImage(UIImage.init(named: "orange_icon"))
        let webObj = WXWebpageObject()
        webObj.webpageUrl = link
        message.mediaObject = webObj
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        if bind == "wechat" {
            req.scene = Int32(WXSceneSession.rawValue)
        } else {
            req.scene = Int32(WXSceneTimeline.rawValue)
        }
        WXApi.send(req)
    }
    
    private func weiboShareArticle(bind: String, link: String, title: String, subTitle: String) {
        let webpage = WBWebpageObject.init()
        webpage.objectID = link
        webpage.title = title
        webpage.description = subTitle
        webpage.thumbnailData = UIImage.init(named: "orange_icon")?.jpegData(compressionQuality: 0.9)
        webpage.webpageUrl = link
        let obj = WBMessageObject.init()
        obj.mediaObject = webpage
        let request = WBSendMessageToWeiboRequest.request(withMessage: obj) as? WBSendMessageToWeiboRequest
        WeiboSDK.send(request)
    }
}
