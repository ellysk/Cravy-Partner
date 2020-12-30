//
//  NewCollectionCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A cell that displays a floater view in which represents adding a new item to the collection view.
class NewCollectionCell: UICollectionViewCell {
    private var floaterView: FloaterView!
    /// Use this delegate to get the response from the button in the floater view.
    var delegate: FloaterViewDelegate? {
        set {
            floaterView.delegate = newValue
        }
        
        get {
            return floaterView.delegate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setNewCollectionCell() {
        setFloaterView()
    }
    
    private func setFloaterView() {
        if floaterView == nil {
            floaterView = FloaterView()
            floaterView.backgroundColor = K.Color.link
            floaterView.imageView.image = UIImage(systemName: "plus.circle.fill")
            floaterView.titleLabel.text = K.UIConstant.addMyOwn
            self.addSubview(floaterView)
            floaterView.translatesAutoresizingMaskIntoConstraints = false
            floaterView.VHConstraint(to: self)
        }
    }
}
