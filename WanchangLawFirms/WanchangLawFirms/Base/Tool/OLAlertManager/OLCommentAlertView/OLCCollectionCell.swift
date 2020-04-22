//
//  OLCCollectionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/20.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol OLCCollectionCellDelegate: NSObjectProtocol {
    func olcCollectionCellClick(score: Float, item: Int)
}

class OLCCollectionCell: UICollectionViewCell {
    
    weak var delegate: OLCCollectionCellDelegate?
    
    var item: Int = 0
    
    var isBig: Bool = false {
        didSet {
            if isBig {
                imgView1.image = UIImage.init(named: "comment_star_virtual_big")
                imgView2.image = UIImage.init(named: "comment_star_real_big")
            } else {
                imgView1.image = UIImage.init(named: "comment_star_virtual_small")
                imgView2.image = UIImage.init(named: "comment_star_real_small")
            }
        }
    }
    
    var score: Float = 0 {
        didSet {
            if score == 0 {
                imgView2.isHidden = true
            } else if score == 0.5 {
                imgView2.isHidden = false
                imgView2.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width / 2, height: self.frame.size.height)
            } else if score == 1 {
                imgView2.isHidden = false
                imgView2.frame = self.bounds
            }
        }
    }
    
    private let imgView1: UIImageView = UIImageView()
    private let imgView2: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imgView1.contentMode = .left
        imgView1.clipsToBounds = true
        imgView1.frame = self.bounds
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(tap:)))
        imgView1.isUserInteractionEnabled = true
        imgView1.addGestureRecognizer(tap)
        
        imgView2.contentMode = .left
        imgView2.clipsToBounds = true
        imgView2.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width / 2, height: self.frame.size.height)
        
        self.addSubview(imgView1)
        self.addSubview(imgView2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapClick(tap: UITapGestureRecognizer) {
        let x = tap.location(in: imgView1).x
        var temp: Float = 0
        if x < self.frame.size.width / 2 {
            if score == 0 {
                temp = 0.5
            } else if score == 0.5 {
                temp = 0
            } else {
                temp = 0.5
            }
        } else {
            if score == 1 {
                temp = 0.5
            } else if score == 0.5 {
                temp = 1
            } else {
                temp = 1
            }
        }
        self.delegate?.olcCollectionCellClick(score: temp, item: item)
    }
}
