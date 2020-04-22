//
//  JPhotoDataView.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

class JPhotoDataView: UIView {
    
    var imgName: String! {
        didSet {
            self.imgView.image = UIImage.init(named: imgName)
        }
    }
    var length: Int? {
        didSet {
            lab.text = JPhotoManager.share.lengthStrFrom(length: length)
        }
    }
    
    private lazy var imgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init()
        temp.contentMode = .scaleAspectFit
        return temp
    }()
    private lazy var lab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init()
        temp.font = UIFont.systemFont(ofSize: 10)
        temp.textColor = UIColor.white
        temp.textAlignment = .right
        return temp
    }()
    
    
    convenience init(h: CGFloat) {
        self.init()
        self.addSubview(imgView)
        self.addSubview(lab)
        _ = imgView.sd_layout()?.leftSpaceToView(self, 10)?.centerYEqualToView(self)?.widthIs(20)?.heightIs(20)
        _ = lab.sd_layout()?.leftSpaceToView(self, 20)?.rightSpaceToView(self, 10)?.centerYEqualToView(self)?.heightIs(20)
    }

    

}
