//
//  JFMManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/4/5.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JFMManager: NSObject {
    static let share: JFMManager = JFMManager()
    
    private var h_me_consult: [JFileModel] = [JFileModel]()
    private var h_agreement_custom: [JFileModel] = [JFileModel]()
    private var h_agreement_check: [JFileModel] = [JFileModel]()
    private var h_lawyer_letter: [JFileModel] = [JFileModel]()
    private var h_notification_letter: [JFileModel] = [JFileModel]()
    private var h_litigant_document: [JFileModel] = [JFileModel]()
    private var h_business_business_contract: [JFileModel] = [JFileModel]()
    private var h_business_equity_affairs: [JFileModel] = [JFileModel]()
    private var h_business_manage_system: [JFileModel] = [JFileModel]()
    private var h_business_litigant_document: [JFileModel] = [JFileModel]()
    private var h_business_lawyer_letter: [JFileModel] = [JFileModel]()
    private var h_business_book_check: [JFileModel] = [JFileModel]()
    private var h_business_consult: [JFileModel] = [JFileModel]()
    
    func save(id: String, assets: [JFileModel]) {
        if id == "h_me_consult" {
            h_me_consult = assets
        } else if id == "h_agreement_custom" {
            h_agreement_custom = assets
        } else if id == "h_agreement_check" {
            h_agreement_check = assets
        } else if id == "h_lawyer_letter" {
            h_lawyer_letter = assets
        } else if id == "h_notification_letter" {
            h_notification_letter = assets
        } else if id == "h_litigant_document" {
            h_litigant_document = assets
        } else if id == "8" {
            h_business_business_contract = assets
        } else if id == "9" {
            h_business_equity_affairs = assets
        } else if id == "10" {
            h_business_manage_system = assets
        } else if id == "11" {
            h_business_litigant_document = assets
        } else if id == "12" {
            h_business_lawyer_letter = assets
        } else if id == "13" {
            h_business_book_check = assets
        } else if id == "14" {
            h_business_consult = assets
        }
    }
    
    func get(id: String) -> [JFileModel] {
        if id == "h_me_consult" {
            return h_me_consult
        } else if id == "h_agreement_custom" {
            return h_agreement_custom
        } else if id == "h_agreement_check" {
            return h_agreement_check
        } else if id == "h_lawyer_letter" {
            return h_lawyer_letter
        } else if id == "h_notification_letter" {
            return h_notification_letter
        } else if id == "h_litigant_document" {
            return h_litigant_document
        } else if id == "8" {
            return h_business_business_contract
        } else if id == "9" {
            return h_business_equity_affairs
        } else if id == "10" {
            return h_business_manage_system
        } else if id == "11" {
            return h_business_litigant_document
        } else if id == "12" {
            return h_business_lawyer_letter
        } else if id == "13" {
            return h_business_book_check
        } else if id == "14" {
            return h_business_consult
        }
        return h_me_consult
    }
    
    func clear(id: String) {
        if id == "h_me_consult" {
            h_me_consult.removeAll()
        } else if id == "h_agreement_custom" {
            h_agreement_custom.removeAll()
        } else if id == "h_agreement_check" {
            h_agreement_check.removeAll()
        } else if id == "h_lawyer_letter" {
            h_lawyer_letter.removeAll()
        } else if id == "h_notification_letter" {
            h_notification_letter.removeAll()
        } else if id == "h_litigant_document" {
            h_litigant_document.removeAll()
        } else if id == "8" {
            h_business_business_contract.removeAll()
        } else if id == "9" {
            h_business_equity_affairs.removeAll()
        } else if id == "10" {
            h_business_manage_system.removeAll()
        } else if id == "11" {
            h_business_litigant_document.removeAll()
        } else if id == "12" {
            h_business_lawyer_letter.removeAll()
        } else if id == "13" {
            h_business_book_check.removeAll()
        } else if id == "14" {
            h_business_consult.removeAll()
        }
    }

}
