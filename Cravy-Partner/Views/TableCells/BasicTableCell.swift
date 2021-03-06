//
//  SettingsCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 14/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A cell that displays an image view and label.
class BasicTableCell: UITableViewCell {
    private var stackView: UIStackView!
    private var basicImageView: UIImageView!
    private var basicLabel: UILabel!
    var makeImageViewRounded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if makeImageViewRounded {
            basicImageView.makeRounded()
        } else {
            basicImageView.removeRounded()
        }
    }
    
    func setBasicCell(image: UIImage, title: String) {
        setStackView(image: image, title: title)
        self.isTransparent = true
    }
    
    private func setStackView(image: UIImage, title: String) {
        setBasicImageView(image: image)
        setBasicLabel(title: title)
        setAcessoryView()
        
        if stackView == nil {
            stackView = UIStackView(arrangedSubviews: [basicImageView, basicLabel])
            stackView.set(axis: .horizontal, alignment: .center, distribution: .fillProportionally, spacing: 16)
            self.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.topAnchor(to: self, constant: 16)
            stackView.bottomAnchor(to: self, constant: 5)
            stackView.HConstraint(to: self, constant: 16)
        }
    }
    
    private func setBasicImageView(image: UIImage) {
        if basicImageView == nil {
            basicImageView = UIImageView(image: image)
            basicImageView.translatesAutoresizingMaskIntoConstraints = false
            basicImageView.sizeAnchorOf(width: 30, height: 30)
            basicImageView.contentMode = .scaleAspectFill
            basicImageView.tintColor = K.Color.dark
        } else {
            basicImageView.image = image
        }
    }
    
    private func setBasicLabel(title: String) {
        if basicLabel == nil {
            basicLabel = UILabel()
            basicLabel.text = title
            basicLabel.font = UIFont.medium.small
            basicLabel.textColor = K.Color.dark
        } else {
            basicLabel.text = title
        }
    }
    
    private func setAcessoryView() {
        if self.accessoryView == nil {
            let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            imageView.tintColor = K.Color.dark
            self.accessoryView = imageView
        }
    }
}
