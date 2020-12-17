//
//  RoundTextField.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A subclass of UITextField that overrides the textRect and editingRect to have a larger inset value.
class CravyTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let dx: CGFloat = self.leftView == nil ? 8 : 24
        return bounds.insetBy(dx: dx, dy: 8);
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let dx: CGFloat = self.leftView == nil ? 8 : 24
        return bounds.insetBy(dx: dx, dy: 8);
    }
    
    /// Sets the placeholder of the textfield with custom style of a dark color with an alpha value of 0.5
    /// - Parameter placeholder: The text to be set as placeholder
    func setPlaceholder(_ placeholder: String, placeholderTextColor: UIColor = K.Color.dark.withAlphaComponent(0.5)) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : placeholderTextColor])
    }
}

/// A subclass of CravyTextField that gives rounded corners and is bordered.
class RoundTextField: CravyTextField {
    private var roundFactor: CGFloat?
    
    init(roundFactor: CGFloat? = nil, placeholder: String = "Write something here...") {
        super.init(frame: .zero)
        setPlaceholder(placeholder)
        self.font = UIFont.regular.small
        self.textColor = K.Color.dark
        self.tintColor = K.Color.primary
        self.roundFactor = roundFactor
        self.backgroundColor = K.Color.light.withAlphaComponent(0.8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let factor = roundFactor {
            self.makeRounded(roundFactor: factor)
        } else {
            self.makeRounded()
        }
        self.makeBordered()
    }
}
