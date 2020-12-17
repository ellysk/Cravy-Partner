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
    
    init(layout: UICollectionViewFlowLayout, scrollDirection: UICollectionView.ScrollDirection) {
        let layout = scrollDirection == .vertical ? UICollectionViewFlowLayout.verticalCraveCollectionViewFlowLayout : UICollectionViewFlowLayout.horizontalCraveCollectionViewFlowLayout
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCollectionViewLayout(UICollectionViewFlowLayout.verticalCraveCollectionViewFlowLayout, animated: true)
    }
    
    override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        super.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
    }
    
    /// Registers the CraveCollectionCell to this CollectionView
    func register() {
        self.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
    }
}
