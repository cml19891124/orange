//
//  JPhotoPreviewCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos
import AVKit

class JPhotoPreviewCollectionCell: UICollectionViewCell {
    
    var asset: PHAsset! {
        didSet {
            if JPhotoCenter.share.configure.showGif && asset.is_gif {
                JPhotoManager.share.fetchGifDataInAsset(asset: asset, mode: .fast) { (asset, endPath, dict) in
                    JQueueManager.share.globalAsyncQueue {
                        let url = URL.init(fileURLWithPath: endPath)
                        let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                        let animatedImage = FLAnimatedImage.init(animatedGIFData: data)
                        JQueueManager.share.mainAsyncQueue {
                            self.imgView.animatedImage = animatedImage
                        }
                    }
                }
            } else {
                JPhotoManager.share.fetchImageInAsset(asset: asset, size: CGSize.init(width: kDeviceWidth * 2, height: kDeviceHeight * 2), mode: .fast) { (asset, img, dict) in
                    self.imgView.image = img
                }
            }
            
            if asset.mediaType == .video {
                playBtn.isHidden = false
            } else {
                playBtn.isHidden = true
            }
        }
    }
    
    private lazy var imgView: FLAnimatedImageView = {
        () -> FLAnimatedImageView in
        let temp = FLAnimatedImageView.init()
        temp.contentMode = .scaleAspectFit
        temp.clipsToBounds = true
        temp.backgroundColor = UIColor.black
        return temp
    }()
    private lazy var playBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton()
        temp.addTarget(self, action: #selector(playClick), for: .touchUpInside)
        temp.setImage(UIImage.init(named: "JPhoto_play"), for: .normal)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(imgView)
        self.addSubview(playBtn)
        
        _ = imgView.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
        _ = playBtn.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(50)?.heightIs(50)
    }
    
    @objc private func playClick() {
        let path = JPhotoManager.share.cachePath(path: "temp.mov")
        let url = URL.init(fileURLWithPath: path)
        try? FileManager.default.removeItem(at: url)
        let resource = PHAssetResource.assetResources(for: asset).first!
        PHAssetResourceManager.default().writeData(for: resource, toFile: url, options: nil, completionHandler: { (error) in
            let vc = AVPlayerViewController()
            vc.player = AVPlayer.init(url: url)
            JAuthorizeManager.init(view: self).responseChainViewController().present(vc, animated: true, completion: {
                vc.player?.play()
            })
        })
    }
    
}
