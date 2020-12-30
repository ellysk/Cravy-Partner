//
//  TagCollectionCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 03/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

enum TAG_COLLECTION_STYLE {
    case filled
    case none_filled
}

/// A cell that displays a label with a round separator.
class TagCollectionCell: UICollectionViewCell {
    override var isSelected: Bool {
        set {
            if allowsSelection {
                self.backgroundColor = newValue ? K.Color.primary : defaultBackgroundColor
            } else {
                self.backgroundColor = defaultBackgroundColor
            }
        }
        
        get {
            return self.backgroundColor == K.Color.primary
        }
    }
    /// The color of the cell when it is not selected.
    var defaultBackgroundColor: UIColor = K.Color.light
    /// Determines if the cell should change its appearance if selected.
    var allowsSelection: Bool = true
    private var tagStackView: UIStackView!
    var tagLabel: UILabel!
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
    private var style: TAG_COLLECTION_STYLE {
        set {
            if newValue == .filled {
                tagLabel.font = UIFont.medium.small
                tagLabel.textAlignment = .center
                isSeparatorHidden = true
            } else {
                tagLabel.font = UIFont.regular.xSmall
                tagLabel.textAlignment = .left
            }
        }
        
        get {
            if tagLabel.font == UIFont.medium.small && tagLabel.textAlignment == .center && isSeparatorHidden {
                return .filled
            } else {
                return .none_filled
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if style == .filled {
            self.makeRounded()
        }
    }
    
    /// Initiliazes the layout of the subviews with the provided tag. default style is none_filled.
    /// - Parameters:
    ///   - style: Determines the look of the cell. A filled style makes the cell have a background color and rounded, could optionally have a button aligned on the left. A none_filled style has no background color and shows the separator
    func setTagCollectionCell(tag: String? = nil, style: TAG_COLLECTION_STYLE = .none_filled) {
        setTagView(tag: tag, style: style)
        self.style = style
        self.isTransparent = style == .none_filled
    }
    
    private func setTagLabel(tag: String? = nil) {
        if tagLabel == nil {
            tagLabel = UILabel()
            tagLabel.text = tag
            tagLabel.textColor = K.Color.dark
        } else {
            tagLabel.text = tag
        }
    }
    
    private func setTagView(tag: String? = nil, style: TAG_COLLECTION_STYLE = .none_filled) {
        setTagLabel(tag: tag)
        
        if tagStackView == nil && separator == nil {
            separator = RoundView()
            separator.backgroundColor = K.Color.primary
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.sizeAnchorOf(width: 5, height: 5)
            
            tagStackView  = UIStackView(arrangedSubviews: [tagLabel, separator])
            tagStackView.set(axis: .horizontal, alignment: .center, spacing: 8)
            self.addSubview(tagStackView)
            tagStackView.translatesAutoresizingMaskIntoConstraints = false
            if style == .none_filled {
                tagStackView.VHConstraint(to: self)
            } else {
                tagStackView.VHConstraint(to: self, VConstant: 8, HConstant: 8)
            }
        }
    }
}
