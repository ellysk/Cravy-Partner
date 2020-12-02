//
//  CustomImageView.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    private var roundFactor: CGFloat?
    
    init(frame: CGRect = .zero, roundfactor: CGFloat? = nil, image: UIImage? = nil) {
        self.roundFactor = roundfactor
        super.init(frame: frame)
        self.image = image
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
    }
}