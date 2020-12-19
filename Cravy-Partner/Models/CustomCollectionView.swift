//
//  CustomCollectionView.swift
//  Cravy-Partner
//
//  Created by Cravy on 17/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A collection view responisible for handling CraveCollectionCell.
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


/// A collection view responsible for handling TagCollectionCell.
class HorizontalTagsCollectionView: UICollectionView {
    init(layout: UICollectionViewFlowLayout, scrollDirection: UICollectionView.ScrollDirection) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.horizontalTagCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCollectionViewLayout(UICollectionViewFlowLayout.horizontalTagCollectionViewFlowLayout, animated: true)
    }
    
    override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        super.register(TagCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.tagCell)
    }
    
    /// Registers the TagCollectionCell to this CollectionView
    func register() {
        self.register(TagCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.tagCell)
    }
}

/// A collection view responsible for handling WidgetCollectionCell.
class WidgetCollectionView: UICollectionView {
    init(layout: UICollectionViewFlowLayout, scrollDirection: UICollectionView.ScrollDirection) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.widgetCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCollectionViewLayout(UICollectionViewFlowLayout.widgetCollectionViewFlowLayout, animated: true)
    }
    
    override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        super.register(WidgetCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.widgetCell)
    }
    
    /// Registers the WidgetCollectionCell to this CollectionView
    func register() {
        self.register(TagCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.widgetCell)
    }
}
