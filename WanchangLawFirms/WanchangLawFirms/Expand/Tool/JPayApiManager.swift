//
//  JPayApiManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/11/29.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import StoreKit
import PassKit

protocol JPayApiManagerDelegate: NSObjectProtocol {
    func jPayApiManagerPayResult(success: Bool)
}

/// 苹果支付管理
class JPayApiManager: NSObject {
    static let share = JPayApiManager()

    weak var delegate: JPayApiManagerDelegate?
    private var bind: String = ""
    private var productId: String = ""
    
    var prompt: MBProgressHUD?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func pay(pay_type: String) {
        guard let order_sn = UserInfo.share.order_sn else {
            return
        }
        guard let order_type = UserInfo.share.order_type else {
            return
        }
        
        let prams: NSDictionary = ["order_sn": order_sn,"order_type":order_type]
        if pay_type == "1" {
            UserInfo.share.wexin_sn = order_sn
            self.payWxPay(prams: prams) { (model) in
                if model != nil {
                    self.wechatPay(model: model!)
                }
            }
        } else {
            self.payAliPay(prams: prams) { (result) in
                if result != nil {
                    self.alipayPay(orderString: result!)
                }
            }
        }
        
    }
    
    func applePay(productId: String) {
        prompt = PromptTool.promptText(L$("loading"))
        self.productId = productId
        if SKPaymentQueue.canMakePayments() {
            self.requestProduct()
        }
    }
    
    func pay_check() {
        guard let order_sn = UserInfo.share.order_sn else {
            return
        }
        guard let order_type = UserInfo.share.order_type else {
            return
        }
        let prams: NSDictionary = ["order_sn": order_sn, "order_type": order_type]
        JPayApiManager.share.payCheck(prams: prams) { (flag) in
            if flag {
                self.delegate?.jPayApiManagerPayResult(success: true)
            } else {
                UserInfo.share.netUserInfo()
                UserInfo.share.order_sn = nil
            }
        }
    }
    
}

extension JPayApiManager {
    private func wechatPay(model: JPayApiWechatModel) {
        let req = PayReq.init()
        req.openID = model.appid
        req.partnerId = model.mch_id
        req.prepayId = model.prepay_id
        req.nonceStr = model.nonce_str
        var timestamp = UInt32(model.timestamp)
        if timestamp == nil {
            timestamp = UInt32(Date().timeIntervalSince1970)
        }
        req.timeStamp = timestamp!
        req.package = "Sign=WXPay"
        req.sign = model.sign
        WXApi.send(req)
    }
    
    private func alipayPay(orderString: String) {
        AlipaySDK.defaultService()?.payOrder(orderString, fromScheme: appAlipayScheme, callback: { (dict) in
            print(dict!)
        })
    }
}

extension JPayApiManager {
    func payWxPay(prams: NSDictionary, success:@escaping(JPayApiWechatModel?) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pay_wxpay, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let m = JPayApiWechatModel.mj_object(withKeyValues: dict[net_key_result])
                success(m)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
    func payAliPay(prams: NSDictionary, success:@escaping(String?) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pay_alipay, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let result = dict[net_key_result] as? String
                success(result)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
    func payCheck(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_pay_check, prams: prams, needPrompt: false, successHandler: { (dict) in
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
}

extension JPayApiManager: SKPaymentTransactionObserver, SKProductsRequestDelegate {
    private func requestProduct() {
        let product = [self.productId]
        let nsset: Set<String> = NSSet.init(array: product) as! Set<String>
        let request = SKProductsRequest.init(productIdentifiers: nsset)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let product = response.products
        if product.count == 0 {
            return
        }
        var storeProduct: SKProduct?
        for pro in product {
            if pro.productIdentifier == self.productId {
                storeProduct = pro
                break
            }
        }
        guard let temp = storeProduct else {
            return
        }
        let g_payment = SKMutablePayment.init(product: temp)
        g_payment.quantity = 1
        SKPaymentQueue.default().add(g_payment)
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DEBUG("请求商品失败")
        DispatchQueue.main.async {
            self.prompt?.removeFromSuperview()
            self.prompt = nil
        }
    }
    
    func requestDidFinish(_ request: SKRequest) {
        DEBUG("反馈信息结束调用")
        DispatchQueue.main.async {
            self.prompt?.removeFromSuperview()
            self.prompt = nil
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for tran in transactions {
            if tran.transactionState == .purchased {
                SKPaymentQueue.default().finishTransaction(tran)
                UserInfo.setStandard(key: standard_apple_paid_uncommit, text: "1")
                self.verifyPurchase()
            } else if tran.transactionState == .restored {
                SKPaymentQueue.default().finishTransaction(tran)
            } else if tran.transactionState == .failed {
                SKPaymentQueue.default().finishTransaction(tran)
            } 
        }
    }
    
}

extension JPayApiManager {
    func verifyPurchase() {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            return
        }
        let data = try? Data.init(contentsOf: receiptURL, options: Data.ReadingOptions.mappedIfSafe)
        guard let receiptData = data else {
            return
        }
        let encodeStr = receiptData.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed)
        var urlStr = "https://buy.itunes.apple.com/verifyReceipt"
        var sandox = "0"
        if self.environmentForReceipt(str: receiptURL.relativeString) {
            urlStr = "https://sandbox.itunes.apple.com/verifyReceipt"
            sandox = "1"
        }
        guard let url = URL.init(string: urlStr) else {
            return
        }
        let urlRequest = NSMutableURLRequest.init(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.httpMethod = "POST"
        let payload = String.init(format: "{\"receipt-data\":\"%@\"}", encodeStr)
        guard let payloadData = payload.data(using: String.Encoding.utf8) else {
            return
        }
        urlRequest.httpBody = payloadData
        
//        let sessionTask: URLSessionTask = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, err) in
//            let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
//            if dict != nil {
//                let receipt = dict?["receipt"] as? NSDictionary
//                let in_app = receipt?["in_app"] as? NSArray
//                print(in_app!)
//            }
//        }
//        sessionTask.resume()
        
        guard let order_sn = UserInfo.share.order_sn else {
            return
        }
        self.applePaidCommit(order_sn: order_sn, order_type: "2", code: encodeStr, sandbox: sandox)
    }
    
    private func applePaidCommit(order_sn: String, order_type: String, code: String, sandbox: String) {
        let prams: NSDictionary = ["order_sn":order_sn,"order_type":"2","code":code,"sandbox":sandbox]
        HTTPManager.share.ask(isGet: false, url: api_pay_apple, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                self.delegate?.jPayApiManagerPayResult(success: true)
            }
            UserInfo.setStandard(key: standard_apple_paid_uncommit, text: nil)
        }) { (err) in

        }
    }
    
    private func environmentForReceipt(str: String) -> Bool {
        var isSandbox: Bool = false
        let result = str.components(separatedBy: CharacterSet.init(charactersIn: "/")).last
        if result == "sandboxReceipt" {
            isSandbox = true
        }
        return isSandbox
    }
}
