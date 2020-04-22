//
//  OLCarouselModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/16.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class OLCarouselModel: NSObject {
    
    @objc var id: String = ""
    @objc var image: String = ""
    @objc var sort: String = ""
    @objc var status: String = ""
    @objc var title: String = ""
    @objc var information: String = ""
    @objc var type: String = ""
    @objc var url: String = ""
    
    var full_url: String {
        get {
            let ns = image as NSString
            if ns.contains("http://") || ns.contains("https://") {
                return image
            }
            return BASE_URL + image
        }
    }

}
