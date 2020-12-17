//
//  CustomCollectionView.swift
//  Cravy-Partner
//
//  Created by Cravy on 17/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A collection view that takes in a craveCollectionViewFlowLayout depending on the direction provided.
class CraveCollectionView: UICollectionView {
    private var layout: UICollectionViewFlowLayout!
    /// The scroll direction of the layout that determines other properties of the layout. Default value is vertical.
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if layout == nil {
            layout = scrollDirection == .vertical ? UICollectionViewFlowLayout.verticalCraveCollectionViewFlowLayout : UICollectionViewFlowLayout.horizontalCraveCollectionViewFlowLayout
            self.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        super.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
    }
    
    /// Registers the CraveCollectionCell to this CollectionView
    func register() {
        self.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
    }
}
