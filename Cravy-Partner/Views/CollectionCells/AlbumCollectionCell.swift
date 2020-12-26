//
//  AlbumCollectionCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 26/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Photos

/// A cell that displays a single image by fetching it from the PHAsset.
class AlbumCollectionCell: UICollectionViewCell {
    private var albumImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setAlbumCollectionCell(asset: PHAsset? = nil) {
        guard let asset = asset else {return}
        setAlbumImageView(asset: asset)
        self.isTransparent = true
    }
    
    private func setAlbumImageView(asset: PHAsset) {
        if albumImageView == nil {
            albumImageView = UIImageView(frame: .zero)
            setAssetToImageView(asset)
            self.addSubview(albumImageView)
            albumImageView.translatesAutoresizingMaskIntoConstraints = false
            albumImageView.VHConstraint(to: self)
        } else {
            setAssetToImageView(asset)
        }
    }
    
    private func setAssetToImageView(_ asset: PHAsset) {
        albumImageView.fetchImageAsset(asset, targetSize: self.frame.size) { (completed) in
            //TODO
        }
    }
}
