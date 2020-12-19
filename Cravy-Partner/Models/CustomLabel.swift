//
//  CustomLabel.swift
//  Cravy-Partner
//
//  Created by Cravy on 19/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A custom label with horizontal insets value of 8.
class PaddingLabel: UILabel {
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
