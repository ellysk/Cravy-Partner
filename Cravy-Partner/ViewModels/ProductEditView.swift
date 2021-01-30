//
//  ProductEditView.swift
//  Cravy-Partner
//
//  Created by Cravy on 21/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// An interactable view for editing different product information.
class ProductEditView: UIScrollView {
    @IBOutlet weak var imageView: RoundImageView!
    @IBOutlet weak var titleTextField: RoundTextField!
    @IBOutlet weak var descriptionTextView: RoundTextView!
    @IBOutlet weak var tagsStackView: UIStackView!
    @IBOutlet weak var horizontalTagsCollectionView: HorizontalTagsCollectionView!
    @IBOutlet weak var linkStackView: UIStackView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.roundFactor = 15
        imageView.cornerMask = UIView.bottomCornerMask
        titleTextField.isBordered = true
        titleTextField.roundFactor = 5
        descriptionTextView.roundFactor = 20
    }

}
