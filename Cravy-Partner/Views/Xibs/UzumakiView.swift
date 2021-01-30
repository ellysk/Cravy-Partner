//
//  UzumakiView.swift
//  Cravy-Partner
//
//  Created by Cravy on 25/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// A view with a collection of image views in a styled layout.
class UzumakiView: GalleryView {
    @IBOutlet weak var imageViewOne: RoundImageView!
    @IBOutlet weak var imageViewTwo: RoundImageView!
    @IBOutlet weak var imageViewThree: RoundImageView!
    @IBOutlet weak var imageViewFour: RoundImageView!
    @IBOutlet weak var imageViewFive: RoundImageView!
    @IBOutlet weak var twoThreeHorizontalStackView: UIStackView!
    @IBOutlet weak var fourFiveVerticalStackView: UIStackView!
    override var gallery: [RoundImageView] {
        return [imageViewOne, imageViewTwo, imageViewThree, imageViewFour, imageViewFive]
    }
    
    internal override func reloadVisible() {
        twoThreeHorizontalStackView.isHidden = imageViewTwo.isHidden && imageViewThree.isHidden
        fourFiveVerticalStackView.isHidden = imageViewFour.isHidden && imageViewFive.isHidden
    }
}
