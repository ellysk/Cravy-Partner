//
//  EmptyView.swift
//  Cravy-Partner
//
//  Created by Cravy on 28/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    @IBOutlet weak var titlelLabel: UILabel!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var createButton: RoundButton!
    var title: String? {
        set {
            titlelLabel.text = newValue
        }
        
        get {
            return titlelLabel.text
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emptyImageView.heightAnchor(of: stackView.frame.width)
    }
}
