//
//  TagCollectionCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 03/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A cell that displays a label with a round separator.
class TagCollectionCell: UICollectionViewCell {
    private var tagStackView: UIStackView!
    private var tagLabel: UILabel!
    private var separator: UIView!
    /// Hides the separator in this particular cell.
    var isSeparatorHidden: Bool {
        set {
            separator.isHidden = newValue
        }
        
        get {
            return separator.isHidden
        }
    }
    /// The font of the tagLabel.
    var font: UIFont = UIFont.regular.xSmall
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    func setTagCollectionCell(tag: String? = nil) {
        setTagView(tag: tag)
    }
    
    private func setTagLabel(tag: String? = nil) {
        if tagLabel == nil {
            tagLabel = UILabel()
            tagLabel.text = tag
            tagLabel.font = font
            tagLabel.textAlignment = .left
            tagLabel.textColor = K.Color.dark
        } else {
            tagLabel.text = tag
        }
    }
    
    private func setTagView(tag: String? = nil) {
        setTagLabel(tag: tag)
        
        if tagStackView == nil && separator == nil {
            separator = RoundView()
            separator.backgroundColor = K.Color.primary
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.heightAnchor(of: 5)
            separator.widthAnchor(of: 5)
            
            tagStackView  = UIStackView(arrangedSubviews: [tagLabel, separator])
            tagStackView.set(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 8)
            self.addSubview(tagStackView)
            tagStackView.translatesAutoresizingMaskIntoConstraints = false
            tagStackView.VHConstraint(to: self)
        }
    }
}
