//
//  HTTPManager.swift
//  zhirong
//
//  Created by lh on 2017/10/19.
//  Copyright © 2017年 gaming17. All rights reserved.
//

import UIKit

class HTTPManager: NSObject {
    @objc static let share = HTTPManager()
    @objc var net_unavaliable: Bool = false
    
    override init() {
        super.init()
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            if status == AFNetworkReachabilityStatus.notReachable {
                PromptTool.promptText(L$("net_unavailable"), 1)
                self.netNo()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_net_not_avaliable), object: nil)
            } else if status == AFNetworkReachabilityStatus.reachableViaWWAN {
                PromptTool.promptText(L$("net_mobile_traffic"), 1)
                self.netChange()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_net_status_change), object: nil)
            } else {
                self.netChange()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_net_status_change), object: nil)
            }
        }
    }
    
    private func netChange() {
        self.net_unavaliable = false
        JSocketHelper.share.connectionSocket()
    }
    
    private func netNo() {
        self.net_unavaliable = true
        JSocketHelper.share.closeSocket()
    }
    
}

extension HTTPManager {
    @objc func ask(isGet: Bool, url: String, prams: NSDictionary, needPrompt: Bool, successHandler: @escaping (NSDictionary)->Void, fail: @escaping (Error?)->Void) {
        var netPrompt: MBProgressHUD?
        if needPrompt {
            netPrompt = PromptTool.promptText(L$("loading"))
        }
        let urlStr = String.init(format: "%@%@", BASE_URL, url)
        DEBUG("urlStr = ", urlStr)
        
        let sessionManager = AFURLSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
        sessionManager.responseSerializer = AFHTTPResponseSerializer()
        
        let seria = AFHTTPRequestSerializer()
        if UserInfo.share.token != nil {
            seria.setValue(UserInfo.share.token!, forHTTPHeaderField: "Authorization")
        }
        seria.timeoutInterval = 10
        seria.stringEncoding = String.Encoding.utf8.rawValue
        var method = "POST"
        if isGet {
            method = "GET"
        }
        let timestamp = "\(Int64(Date().timeIntervalSince1970))"
        var count = 0
        for (_, value) in prams {
            let temp1 = "\(value)"
            count += temp1.lengthOfBytes(using: String.Encoding.utf8)
        }
        count += timestamp.count
        let mulPrams = NSMutableDictionary.init(dictionary: prams)
        let str = "szcy" + "\(timestamp)" + method + "\(count)"
        mulPrams["timestamp"] = "\(timestamp)"
        mulPrams["sign"] = str.md5
        let request = seria.request(withMethod: method, urlString: urlStr, parameters: mulPrams, error: nil)
        let dataTask = sessionManager.dataTask(with: request as URLRequest, uploadProgress: nil, downloadProgress: nil) { (response, data, error) in
            if (error != nil) {
                if HTTPManager.share.net_unavaliable {
                    PromptTool.promptText(L$("net_unavailable"), 1)
                }
                fail(error!)
                DEBUG(error!)
            } else {
                let result = String.init(data: (data as! NSData) as Data, encoding: .utf8)!
                DEBUG(result)
                let dict = try? JSONSerialization.jsonObject(with: (data as! NSData) as Data, options: .allowFragments) as? NSDictionary
                if dict != nil {
                    let code = dict?[net_key_code] as? Int
                    if code == 400 {
                        JRootVCManager.share.rootLogin()
                    }
                    successHandler(dict!)
                } else {
                    fail(nil)
                }
            }
            netPrompt?.removeFromSuperview()
        }
        dataTask.resume()
    }
    
    @objc func html(isGet: Bool, url: String, prams: NSDictionary, needPrompt: Bool, successHandler: @escaping (String)->Void, fail: @escaping (Error?)->Void) {
        var netPrompt: MBProgressHUD?
        if needPrompt {
            netPrompt = PromptTool.promptText(L$("loading"))
        }
        let urlStr = String.init(format: "%@%@", BASE_URL, url)
        DEBUG("urlStr = ", urlStr)
        
        let sessionManager = AFURLSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
        sessionManager.responseSerializer = AFHTTPResponseSerializer()
        
        let seria = AFHTTPRequestSerializer()
        if UserInfo.share.token != nil {
            seria.setValue(UserInfo.share.token!, forHTTPHeaderField: "Authorization")
        }
        seria.timeoutInterval = 10
        seria.stringEncoding = String.Encoding.utf8.rawValue
        var method = "POST"
        if isGet {
            method = "GET"
        }
        let request = seria.request(withMethod: method, urlString: urlStr, parameters: prams, error: nil)
        let dataTask = sessionManager.dataTask(with: request as URLRequest, uploadProgress: nil, downloadProgress: nil) { (response, data, error) in
            if (error != nil) {
                fail(error!)
                DEBUG(error!)
            } else {
                let result = String.init(data: (data as! NSData) as Data, encoding: .utf8)!
                successHandler(result)
            }
            netPrompt?.removeFromSuperview()
        }
        dataTask.resume()
    }
    
    
    
    @objc func other_ask(isGet: Bool, url: String, prams: NSDictionary, needPrompt: Bool, successHandler: @escaping (NSDictionary)->Void, fail: @escaping (Error?)->Void) {
        var netPrompt: MBProgressHUD?
        if needPrompt {
            netPrompt = PromptTool.promptText(L$("loading"))
        }
        let urlStr = url
        DEBUG("urlStr = ", urlStr)
        
        let sessionManager = AFURLSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
        sessionManager.responseSerializer = AFHTTPResponseSerializer()
        
        let seria = AFHTTPRequestSerializer()
        seria.timeoutInterval = 10
        seria.stringEncoding = String.Encoding.utf8.rawValue
        var method = "POST"
        if isGet {
            method = "GET"
        }
        let request = seria.request(withMethod: method, urlString: urlStr, parameters: prams, error: nil)
        let dataTask = sessionManager.dataTask(with: request as URLRequest, uploadProgress: nil, downloadProgress: nil) { (response, data, error) in
            if (error != nil) {
                fail(error!)
                DEBUG(error!)
            } else {
                let result = String.init(data: (data as! NSData) as Data, encoding: .utf8)!
                DEBUG(result)
                let dict = try? JSONSerialization.jsonObject(with: (data as! NSData) as Data, options: .allowFragments) as? NSDictionary
                if dict != nil {
                    successHandler(dict!)
                } else {
                    fail(nil)
                }
            }
            netPrompt?.removeFromSuperview()
        }
        dataTask.resume()
    }
    
    @objc func other_html(url: String, needPrompt: Bool, successHandler: @escaping (String)->Void, fail: @escaping (Error?)->Void) {
        var netPrompt: MBProgressHUD?
        if needPrompt {
            netPrompt = PromptTool.promptText(L$("loading"))
        }
        let urlStr = url
        DEBUG("urlStr = ", urlStr)
        
        let sessionManager = AFURLSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
        sessionManager.responseSerializer = AFHTTPResponseSerializer()
        
        let seria = AFHTTPRequestSerializer()
        seria.timeoutInterval = 10
        seria.stringEncoding = String.Encoding.utf8.rawValue
        let request = seria.request(withMethod: "GET", urlString: urlStr, parameters: NSDictionary(), error: nil)
        let dataTask = sessionManager.dataTask(with: request as URLRequest, uploadProgress: nil, downloadProgress: nil) { (response, data, error) in
            if (error != nil) {
                fail(error!)
                DEBUG(error!)
            } else {
                let result = String.init(data: (data as! NSData) as Data, encoding: .utf8)!
                successHandler(result)
            }
            netPrompt?.removeFromSuperview()
        }
        dataTask.resume()
    }
}
