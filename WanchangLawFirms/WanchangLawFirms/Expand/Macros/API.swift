//
//  API.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import Foundation

//let appKey_um: String = "598d6f215312dd1853000e4d"
//let appKey_QQ: String = "101524355"
//let appSecret_QQ: String = "eb9be0b99cc60fff92dd3e2a76df104a"
//let appKey_sina: String = ""
//let appSecret_sina: String = ""
//
//let appKey_wechat: String = "wxc4c89680a32becf4"
//let appSecret_wechat: String = ""
//
//let appAlipayScheme: String = "alisdk2017112200104034"
//let appAlipayID: String = "2017112200104034"
//let appAlipayRedirectUrl: String = "http://attorney.whtkl.cn/PHPalipay/notify_url.php"


//let appKey_um: String = "598d6f215312dd1853000e4d"
//let appKey_QQ: String = "1108005552"
//let appSecret_QQ: String = "aZY59kWlshvSb3G3"

/// QQ
let appKey_QQ: String = "1106565816"
let appSecret_QQ: String = "Nm7GHwkqIGKEsAsO"

/// 新浪微博
let appKey_sina: String = "1739368274"
let appSecret_sina: String = "0ed8915169c12d2c960ebb437f4ffd4d"

/// 微信
let appKey_wechat: String = "wxc4c89680a32becf4"
let appSecret_wechat: String = "ac5183daea128d01c121ccc4fc5508bf"

/// 支付宝
let appAlipayScheme: String = "alisdk2017112200104034"
let appAlipayID: String = "2017112200104034"
let appAlipayRedirectUrl: String = "http://attorney.whtkl.cn/PHPalipay/notify_url.php"
let appAlipayKey: String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqYQybgZ3was+xMg3W39HdIbUKZOdc0QM5SEdduAdqVJTN1VFntYxUjjR9Lu5uN36imEJZcPQ30RB30RIBgKie6jF/o+/yXXtwXctnvjWR/a6oyrJJ8Jll0nYmlTUAmvL2dIWFlpdxyxyH0hlUAnQGW1A1oLVtc5hqBzkgkRk37lSCtL4QbyneWNLfUnNMvK7NtCdll+Eq98ejeojB0uW41sG2MtwH+H8PPdM4c5S3DKJnk7SWEMQ48+UxPSQnesvc7lwcRE1ywI3HAVvYmwe2nZZpsZCGO3Xore2RMy3/exvWEle0oCmiEEAl2XqBmp3dRCGu6Ej3HS6yrwefgKvNwIDAQAB"
let appAlipaySecret = "MIIEpAIBAAKCAQEAwCRv4zV7tK8sXPHL/C7PjyhyowcjCpwN7qwZZS1jct3dmPcHy8c27IeByMgd62+IBJm1HZzrTKaYzxeoJaJxtDnTuASHHbdfQpnCES39JLjehO1EFltBvqXT8vbKf120RR8zyZ7euGIJfgd/r+iXolcvWa18twIIm5SF1337l3oFDz6JxJcqkaAA8/xFZ7kU5E/OfaMsQAvlO9zABwC9mCgpcMcjQKKae56jCkIEZzDI8ICihNdppxxFZ3PMSpfaY4zCFxU8H6o0bizXNHrAaOSYkrijp1W+1A8L+QFf2/AmwGnf1gg6kb1o/PDNF/T4Tue1VWN8hymnizAGnekPdwIDAQABAoIBAH3H3I7qdh7kBbCagSSHKEzY96KNi3zoh55UfxNi0RVi9CusmyflM6lHU8iyaBO1oV8RmCTYkphM/v+ixupMGw8WQ+jU3fawEeYxbX99kZe2hcSS5d2Uw8cgG02UDR+vodEWCfrUy4v8caZVFlt7cbhORqr4DQpohGYEplFZIZgYnuw15h4GSaoM+8I4rMUTsQ9M+LOAnYGo1CovilVGR6tE73oOSOqAoU9RHSJVmMEvDNjkstiwc50UMgGKi385pcQGuvrZtyJ4ImKIPIop4+Rbf3tv/2FB1jUV2UTo2Bsv+ytVmgyb9KbfkAqgyoYAI8+viTEn+uXZqmMAVIxq0uECgYEA9K6hKsXk3Dj9N/0ePmd1LQABUNFlG0LeFzyd59pMfTodl7OMxttjQVylIsloFcd5OediIdQnA6nifky8AG5aRiQVIwRBuBiLGI9wbuHkV1hOyWJDk5vHNJPIPtOjhUKIQzoqY1LCoIWJwGAycAGwnP3qiAIl3kIJEPuRUbubSY8CgYEAyQeqF0hsZcJSMdWs/u9dHChX2Ogh2RNi7LvCbXRRQ4VKB+GwNIG8rpT6KqccYxW5K27urAz67/yhT+tZEY6pXNbotCC/z//q6mYgH4KDO1r8iigL+jXFzGidHn8onxVUbAgWVD7giR67+i5lL0FJJ8YRL3gcPO+XeZfBOQ/915kCgYEAs2ErCp6WD9U/3sIUYA+c2ea9EDDS/M9i3oo0AXwKw2vNsh+Rv1+rPonbDsu1IPJiL08wpDhSed8cCxfaZD6CtBVT4Z4HSB3GK7VM6h11N4uoBv+hJx/3RNZq4ZRqtxF1sEN+O966jNAZkw1zLKYwgoesXxWkCXNEDk0/1jnBuIUCgYBohDSZgEzjJwGG6VnU/WvCTPNHUYDvlFW1UPUH5Rau7SiNKnhrBByuA8SA0ns+xLeN7lHmX6VDimvv2iNnrm09WHqJ1BEFuj9PeKMw3rEN9gMgbSu0/aoF2Un+5gufkf5fYGEDkeE5SSJgMyjmRaIcLK0YqfC8ebCeRhjuavMF2QKBgQDm+phYhlC+rHunXEH2xENo4K9AaTUKTLP9/e2phLRhAWQALA/h4paqn2Jpb2SBBJL1ZPXq6+vyOMWEzKTNghJggNxit9/4oO9vNSyOsyOhlWr1C/Kv3r6Ld668Yc89gfbUOnlK4FyGWD49BdhkNZQGWnmz1DXImrZ/37w1ey1/iw=="

/// Bugly
let appKey_bugly: String = "1896871c2e"



/// 网络请求根路径
var BASE_URL: String =  {
    if UserInfo.share.isTestServer {
        return "http://47.106.38.135:8900"
    }
    return "https://api.wanchangorange.com"
}()

//var BASE_IMG_URL: String = {
//    if UserInfo.share.isTestServer {
//        return "http://47.106.38.135:8902/oss/img"
//    }
//    return "https://api.wanchangorange.com/oss/img"
//}()

/// 注册登陆
let api_pub_reg = "/pub/reg"
let api_pub_login = "/pub/login"
let api_pub_login_sms = "/pub/login/sms"
let api_pub_login_oauth = "/pub/login/oauth"
let api_pub_sms_code = "/pub/sms/code"
let api_sms_check = "/pub/sms/check"
let api_pub_version = "/pub/version"
let api_pub_reset = "/pub/reset"
let api_pub_email_send = "/pub/email/send"
let api_pub_sliders = "/pub/sliders"
let api_pub_email_code = "/pub/email/code"
let api_pub_reset_email = "/pub/reset/email"

/// 用户操作
let api_user_info = "/user/info"
let api_user_mobile = "/user/mobile"
let api_user_password = "/user/password"
let api_user_logout = "/user/logout"
let api_user_refresh = "/user/refresh"
let api_user_trades = "/user/trades"
let api_user_feedback = "/user/feedback"
let api_user_orders = "/user/orders"
let api_user_sms = "/user/sms"
let api_user_destroy = "/user/destroy"
let api_user_orders_all = "/user/orders/all"

/// 首页服务类型
let api_services_category = "/services/category"
let api_services_list = "/services/list"
let api_services_detail = "/services/detail"
let api_services_list_show = "/services/list/show"

/// 订单操作
let api_order_create = "/order/create"
let api_order_finish = "/order/finish"
let api_order_view = "/order/view"
let api_order_comment = "/order/comment"
let api_order_delete = "/order/delete"
let api_order_cancel = "/order/cancel"
let api_order_confirm = "/order/confirm"

/// Vip接口
let api_vip_list = "/vip/list"
let api_vip_order_create = "/vip/order/create"
let api_vip_order_cancel = "/vip/order/cancel"
let api_vip_order_confirm = "/vip/order/confirm"

/// 资讯
let api_posts_categories = "/posts/categories"
let api_posts_list = "/posts/list"
let api_posts_detail = "/posts/detail"
let api_posts_info = "/posts/info"
let api_posts_view = "/posts/view"

/// 聊天
let api_chat_list = "/chat/list"
let api_chat_msg = "/chat/msg"
let api_chat_offline = "/chat/offline"
let api_chat_cs = "/chat/cs"
let api_chat_system_offline = "/chat/system/offline"
let api_chat_system = "/chat/system"
let api_chat_lawyer = "/chat/lawyer"
let api_chat_cs_reply = "/chat/cs/reply"
let api_chat_msg_file = "/chat/msg/file"

/// 企业管理子账户
let api_counter_setting = "/counter/setting"
let api_counter_work = "/counter/work"
let api_counter_traffic = "/counter/traffic"
let api_counter_lawyer = "/counter/lawyer"
let api_counter_sue = "/counter/sue"
let api_counter_info = "/counter/info"

/// 支付接口
let api_pay_wxpay = "/pay/wxpay"
let api_pay_alipay = "/pay/alipay"
let api_pay_apple = "/pay/apple"
let api_pay_check = "/pay/check"

/// 企业操作
let api_company_info = "/company/info"
let api_company_vip = "/company/vip"
let api_company_account_add = "/company/account/add"
let api_company_account_del = "/company/account/del"
let api_company_account_list = "/company/account/list"
let api_company_change = "/company/change"
let api_pub_co_reg = "/pub/co/reg"
let api_pub_co_login_email = "/pub/co/login/email"
let api_pub_co_login_username = "/pub/co/login/username"
let api_company_orders_all = "/company/orders/all"
let api_company_account_edit = "/company/account/edit"
let api_pub_check_user = "/pub/check/user"
let api_company_info_update = "/company/info/update"
let api_company_transfer_info = "/company/transfer/info"
let api_company_vip_order_list = "/company/vip/order/list"
let api_company_vip_order_view = "/company/vip/order/view"
let api_company_info_exa = "/company/info/exa"

/// 发票
let api_invoice_list = "/invoice/list"
let api_invoice_create = "/invoice/create"
let api_invoice_view = "/invoice/view"
let api_invoice_head_info = "/invoice/head/info"
let api_invoice_head_create = "/invoice/head/create"
let api_invoice_head_update = "/invoice/head/update"
let api_user_trades_invoice = "/user/trades/invoice"

/// 线下咨询
let api_company_inline_lawyer_create = "/company/inline/lawyer/create"
let api_service_inline_lawyer_list = "/services/inline/lawyer/list"
let api_company_inline_train_create = "/company/inline/train/create"
let api_company_inline_cancel = "/company/inline/cancel"
