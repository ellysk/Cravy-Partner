//
//  RoundTextField.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A subclass of UITextField that gives rounded corners and is bordered.
class RoundTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeRounded()
        self.makeBordered()
        self.backgroundColor = K.Color.light.withAlphaComponent(0.8)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 8);
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 8);
    }
    
    /// Sets the placeholder of the textfield with custom style of a dark color with an alpha value of 0.5
    /// - Parameter placeholder: The text to be set as placeholder
    func setPlaceholder(_ placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : K.Color.dark.withAlphaComponent(0.5)])
    }
}
