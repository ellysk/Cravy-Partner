//
//  ImageCollectionCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 09/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A cell that displays a single round image view.
class ImageCollectionCell: UICollectionViewCell {
    private var roundImageView: RoundImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Sets the round image view with a default round factor of 5.
    func setImageCollectionCell(image: UIImage? = nil, roundfactor: CGFloat = 5) {
        setRoundImageView(image: image, roundfactor: roundfactor)
        self.isTransparent = true
    }
    
    private func setRoundImageView(image: UIImage? = nil, roundfactor: CGFloat) {
        if roundImageView == nil {
            roundImageView = RoundImageView(image: image, roundfactor: roundfactor)
            self.addSubview(roundImageView)
            roundImageView.translatesAutoresizingMaskIntoConstraints = false
            roundImageView.VHConstraint(to: self)
        } else {
            roundImageView.image = image
        }
    }
}
