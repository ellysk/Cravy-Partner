//
//  CustomTextView.swift
//  Cravy-Partner
//
//  Created by Cravy on 05/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A subclass of UITextField that gives rounded corners and is bordered.
class RoundTextView: UITextView {
    private var roundFactor: CGFloat?
    
    init(roundFactor: CGFloat? = nil, placeholder: String?) {
        self.roundFactor = roundFactor
        super.init(frame: .zero, textContainer: nil)
        self.text = placeholder
        self.font = UIFont.regular.small
        self.textColor = K.Color.dark.withAlphaComponent(0.5)
        self.textContainerInset.top = 16
        self.textContainerInset.bottom = 16
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
        self.backgroundColor = K.Color.light.withAlphaComponent(0.8)
    }
}
