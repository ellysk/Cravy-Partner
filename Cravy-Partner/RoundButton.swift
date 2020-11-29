//
//  RoundButton.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeRounded()
    }
}

class BorderedButton: RoundButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 1
        self.layer.borderColor = K.Color.primary.cgColor
    }
}
