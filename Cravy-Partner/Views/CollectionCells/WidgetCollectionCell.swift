//
//  WidgetCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 19/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class WidgetCollectionCell: UICollectionViewCell {
    private var widgetStackView: UIStackView!
    private var widgetImageView: UIImageView!
    private var widgetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeRounded(roundFactor: 5)
    }
    
    func setWidgetCell(image: UIImage, title: NSMutableAttributedString? = nil) {
        setWidgetStackView(image: image, title: title)
        self.backgroundColor = K.Color.dark
    }
    
    private func setWidgetStackView(image: UIImage, title: NSMutableAttributedString?) {
        setWidgetImageView(image: image)
        setWidgetLabel(title: title)
        
        if widgetStackView == nil {
            widgetStackView = UIStackView(arrangedSubviews: [widgetImageView, widgetLabel])
            widgetStackView.set(axis: .vertical, alignment: .center, distribution: .fill)
            self.addSubview(widgetStackView)
            widgetStackView.translatesAutoresizingMaskIntoConstraints = false
            widgetStackView.centerYAnchor(to: self)
            widgetStackView.HConstraint(to: self, constant: 3)
        }
    }
    
    private func setWidgetImageView(image: UIImage) {
        if widgetImageView == nil {
            widgetImageView = UIImageView(image: image)
            widgetImageView.contentMode = .scaleAspectFit
            widgetImageView.tintColor = K.Color.primary
            widgetImageView.translatesAutoresizingMaskIntoConstraints = false
            widgetImageView.sizeAnchorOf(width: 40, height: 45)
        } else {
            widgetImageView.image = image
        }
    }
    
    private func setWidgetLabel(title: NSMutableAttributedString?) {
        if widgetLabel == nil {
            widgetLabel = UILabel()
            widgetLabel.attributedText = title
            widgetLabel.adjustsFontSizeToFitWidth = true
            widgetLabel.textColor = K.Color.light
        } else {
            widgetLabel.attributedText = title
        }
    }
}
