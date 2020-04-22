//
//  FastDoorManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class FastDoorManager: NSObject {
    static let share = FastDoorManager()
    
    func title(bind: String) -> String {
        let head = "欧伶猪法律\n"
        let tail = "\n操作流程"
        let temp = L$(bind)
        return head + temp + tail
    }
    
    func logo(bind: String, step: Int) -> String {
        var temp = ""
        switch step {
        case 1:
            if bind == "h_business_business_contract" || bind == "h_business_equity_affairs" || bind == "h_business_manage_system" {
                temp = "h_business_book_custom"
            } else if bind == "h_business_litigant_document" || bind == "h_business_lawyer_letter" {
                temp = "h_business_book_other"
            } else {
                temp = bind
            }
            break
        case 2:
            temp = "door_pay"
            break
        case 3:
            temp = "door_chat"
            break
        case 4:
            if bind == "h_me_consult" {
                temp = "door_hour"
            } else {
                temp = "door_message"
            }
            break
        default:
            break
        }
        return temp
    }
    
    func stepDesc(bind: String, step: Int) -> String {
        var temp = ""
        if bind == "h_me_consult" {
            switch step {
            case 1:
                temp = "1.点击“我要咨询”板块进入页面开通会员或购买问题。"
                break
            case 2:
                temp = "2.支付完成后，简要描述您的法律需求，点击提交，专业人员在线为您解答。"
                break
            case 3:
                temp = "3.根据您描述案件的关键字，将为您进行相关法律分析和解答。"
                break
            case 4:
                temp = "4.咨询完毕后，您可选择自动结束咨询或72小时未进行回复，系统将自动为您结束。"
                break
            default:
                break
            }
        } else if bind == "h_agreement_custom" {
            switch step {
            case 1:
                temp = "1.对您所需要定制的合同内容进行简要描述。"
                break
            case 2:
                temp = "2.点击“提交”，进入支付页面，请您对订单信息进行确认并支付。"
                break
            case 3:
                temp = "3.支付完成后，将进入会话页面，您可与线上专业人员就相关内容进行具体描述。"
                break
            case 4:
                temp = "4.相关文档通过邮箱进行传输。(定制一份合同拥有两次修改机会)"
                break
            default:
                break
            }
        } else if bind == "h_agreement_check" {
            switch step {
            case 1:
                temp = "1.对您所需要审查的合同内容进行简要描述。"
                break
            case 2:
                temp = "2.点击“提交”，进入支付页面，请您对订单信息进行确认并支付。"
                break
            case 3:
                temp = "3.支付完成后，将进入会话页面，我们将在对话框中提供企业邮箱。"
                break
            case 4:
                temp = "4.相关文档通过邮箱进行传输。(定制一份合同拥有两次修改机会)"
                break
            default:
                break
            }
        } else if bind == "h_lawyer_letter" {
            switch step {
            case 1:
                temp = "1.对您所需要委托的内容进行简要描述。"
                break
            case 2:
                temp = "2.点击“提交”，进入支付页面，请您对订单信息进行确认并支付。"
                break
            case 3:
                temp = "3.支付完成后，将进入会话页面，您可与线上专业人员就相关内容进行具体描述。"
                break
            case 4:
                temp = "4.相关文档通过邮箱进行传输。(一份律师拥有两次修改机会)"
                break
            default:
                break
            }
        } else if bind == "h_notification_letter" {
            switch step {
            case 1:
                temp = "1.对您所需要委托的内容进行简要描述。"
                break
            case 2:
                temp = "2.点击“提交”，进入支付页面，请您对订单信息进行确认并支付。"
                break
            case 3:
                temp = "3.支付完成后，将进入会话页面，您可与线上专业人员就相关内容进行具体描述。"
                break
            case 4:
                temp = "4.相关文档通过邮箱进行传输。(一份告知函拥有两次修改机会)"
                break
            default:
                break
            }
        } else if bind == "h_litigant_document" {
            switch step {
            case 1:
                temp = "1.对您所需要委托的内容进行简要描述。"
                break
            case 2:
                temp = "2.点击“提交”，进入支付页面，请您对订单信息进行确认并支付。"
                break
            case 3:
                temp = "3.支付完成后，将进入会话页面，您可与线上专业人员就相关内容进行具体描述。"
                break
            case 4:
                temp = "4.相关文档通过邮箱进行传输。(代写一份文书拥有两次修改机会)"
                break
            default:
                break
            }
        } else if bind == "h_meeting_consult" {
            switch step {
            case 1:
                temp = "1.填写会面律师预约的时间，地点。"
                break
            case 2:
                temp = "2.完整填写个人基本信息，带*的为必填项目。"
                break
            case 3:
                temp = "3.订单预约成功后，律师将在一个工作日内与您电话联系，并对填写的个人信息进行核实。"
                break
            case 4:
                temp = "4.根据您会面需求的具体时长，律师将进行相应收费。"
                break
            default:
                break
            }
        }
        return temp
    }

}
