//
//  UchihaView.swift
//  Cravy-Partner
//
//  Created by Cravy on 25/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// A view with a collection of image views in a styled layout.
class UchihaView: GalleryView {
    @IBOutlet weak var imageViewOne: RoundImageView!
    @IBOutlet weak var imageViewTwo: RoundImageView!
    @IBOutlet weak var imageViewThree: RoundImageView!
    @IBOutlet weak var imageViewFour: RoundImageView!
    @IBOutlet weak var imageViewFive: RoundImageView!
    /// Contains image view two and three in a fill equal distribution
    @IBOutlet weak var twoThreeVerticalStackView: UIStackView!
    @IBOutlet weak var fourFiveHorizontalStackView: UIStackView!
    override var gallery: [RoundImageView] {
        return [imageViewOne, imageViewTwo, imageViewThree, imageViewFour, imageViewFive]
    }
    
    internal override func reloadVisible() {
        twoThreeVerticalStackView.isHidden = imageViewTwo.isHidden && imageViewThree.isHidden
        fourFiveHorizontalStackView.isHidden = imageViewFour.isHidden && imageViewFive.isHidden
    }
}
