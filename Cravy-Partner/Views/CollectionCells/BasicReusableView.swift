//
//  BasicReusableView.swift
//  Cravy-Partner
//
//  Created by Cravy on 26/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A reusable view with a label aligned to the left.
class BasicReusableView: UICollectionReusableView {
    var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setBasicReusableView(title: String) {
        setTitleLabel(title: title)
        self.isTransparent = true
    }
    
    private func setTitleLabel(title: String) {
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.demiBold.small
            titleLabel.textAlignment = .left
            titleLabel.textColor = K.Color.dark
            self.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.bottomAnchor(to: self, constant: 3)
            titleLabel.HConstraint(to: self, constant: 8)
        } else {
            titleLabel.text = title
        }
    }
}
