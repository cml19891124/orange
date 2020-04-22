//
//  JAvatarImgView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JAvatarImgView: UIImageView {
    
    var isMe: Bool = false
    var avatar: String? {
        didSet {
            //avatar == "uploads/avatar/default.png" || 
            if avatar == nil || avatar == "" {
                if self.isMe == true {
                    self.image = UIImage.init(named: "avatar_mine")
                } else {
                    self.image = UIImage.init(named: "avatar_service")
                }
            } else {
                weak var weakSelf = self
                let model = JAvatarImgModel.init(remotePath: avatar!)
                model.success = { (remotePath, endPath, img) in
                    if remotePath == weakSelf?.avatar {
                        if endPath?.haveTextStr() == true {
                            weakSelf?.image = UIImage.init(contentsOfFile: endPath!)
                        } else if img != nil {
                            weakSelf?.image = img
                        } else {
                            if weakSelf?.isMe == true {
                                weakSelf?.image = UIImage.init(named: "avatar_mine")
                            } else {
                                weakSelf?.image = UIImage.init(named: "avatar_service")
                            }
                        }
                    }
                }
                JImageDownloadManager.share.addTask(model: model)
            }
        }
    }

    convenience init(cornerRadius: CGFloat) {
        self.init()
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
    }

}
