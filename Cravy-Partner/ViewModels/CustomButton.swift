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
    private var roundFactor: CGFloat?
    /// A boolean that determines if the button should have a shadow layer.
    var castShadow: Bool = false
    
    init(frame: CGRect = .zero, roundFactor: CGFloat? = nil) {
        self.roundFactor = roundFactor
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let factor = roundFactor {
            self.makeRounded(roundFactor: factor)
        } else {
            self.makeRounded()
        }
        if castShadow {
            self.setShadow()
        }
    }
}


/// A subclass of RoundButton that gives the button a border width of 1 with a default color of primary.
class RoundBorderedButton: RoundButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeBordered()
    }
}
