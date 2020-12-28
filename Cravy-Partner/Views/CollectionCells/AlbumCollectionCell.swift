//
//  AlbumCollectionCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 26/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Photos

enum IMAGE_QUALITY {
    case high
    case low
}

/// A cell that displays a single image by fetching it from the PHAsset.
class AlbumCollectionCell: UICollectionViewCell {
    private var albumImageView: UIImageView!
    var imageView: UIImageView? {
        return albumImageView
    }
    var quality: IMAGE_QUALITY!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setAlbumCollectionCell(asset: PHAsset, with quality: IMAGE_QUALITY = .low) {
        self.quality = quality
        setAlbumImageView(asset)
        self.isTransparent = true
    }
    
    private func setAlbumImageView(_ asset: PHAsset) {
        if albumImageView == nil {
            albumImageView = UIImageView(frame: .zero)
            setAssetToImageView(asset,with: quality)
            self.addSubview(albumImageView)
            albumImageView.translatesAutoresizingMaskIntoConstraints = false
            albumImageView.VHConstraint(to: self)
        } else {
            setAssetToImageView(asset, with: quality)
        }
    }
    
    private func setAssetToImageView(_ asset: PHAsset, with quality: IMAGE_QUALITY) {
        if quality == .low {
            let sizetToFit = UIScreen.main.bounds.width / 1.5
            let targetSize = CGSize(width:sizetToFit, height: sizetToFit)
            asset.fetchImage(targetSize: targetSize) { (LQImage, info) in
                self.albumImageView.image = LQImage
            }
        } else {
            asset.fetchImage() { (LQImage, info) in
                self.albumImageView.image = LQImage
            }
        }
    }
}
