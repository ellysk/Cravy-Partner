//
//  DetailCollectionCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A collection view cell that displays an undertlined title at the top with a description right below
class DetailCollectionCell: UICollectionViewCell {
    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    
    /// Initiates the subviews of the cell and populates them with data if provided.
    func setDetailCollectionCell(title: String?, detail: String?) {
        if titleLabel == nil && detailLabel == nil {
            setTitleLabel(title: title)
            setDetailLabel(detail: detail)
            arrangeLabels()
        } else {
            titleLabel.text = title
            detailLabel.text = detail
        }
    }
    
    
    private func setTitleLabel(title: String? = nil) {
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.heavy.large
        titleLabel.underline()
        titleLabel.textAlignment = .center
        titleLabel.textColor = K.Color.light
    }
    
    private func setDetailLabel(detail: String? = nil) {
        detailLabel = UILabel()
        detailLabel.text = detail
        detailLabel.font = UIFont.medium.medium
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.textColor = K.Color.light
    }
    
    private func arrangeLabels() {
        let vStackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        vStackView.set(axis: .vertical, distribution: .fill)
        
        self.addSubview(vStackView)
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.centerYAnchor(to: self)
        vStackView.HConstraint(to: self, constant: 8)
    }
}
