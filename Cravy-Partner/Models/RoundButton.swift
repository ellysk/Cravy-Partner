//
//  RoundButton.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A subclass of UIButton that gives the button rounded corners.
class RoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeRounded()
    }
}


/// A subclass of RoundButton that gives the button a border width of 1 with a default color of primary.
class BorderedButton: RoundButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 1
        self.layer.borderColor = K.Color.primary.cgColor
    }
}
