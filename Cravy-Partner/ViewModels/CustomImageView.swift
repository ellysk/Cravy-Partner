//
//  CustomImageView.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    var roundFactor: CGFloat?
    var cornerMask: CACornerMask?
    
    init(frame: CGRect = .zero, roundfactor: CGFloat? = nil) {
        self.roundFactor = roundfactor
        super.init(frame: frame)
    }
    
    init(image: UIImage? = nil, roundfactor: CGFloat? = nil) {
        self.roundFactor = roundfactor
        super.init(image: image)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let factor = roundFactor {
            self.makeRounded(roundFactor: factor, cornerMask: cornerMask)
        } else {
            self.makeRounded(cornerMask: cornerMask)
        }
    }
}

class RoundBorderedImageView: RoundImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeBordered()
    }
}
