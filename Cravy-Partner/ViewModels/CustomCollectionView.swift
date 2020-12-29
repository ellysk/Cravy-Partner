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
class TagsCollectionView: UICollectionView {
    
    override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        super.register(TagCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.tagCell)
    }
    
    /// Registers the TagCollectionCell to this CollectionView
    func register() {
        self.register(TagCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.tagCell)
    }
}

class HorizontalTagsCollectionView: TagsCollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.horizontalTagCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCollectionViewLayout(UICollectionViewFlowLayout.horizontalTagCollectionViewFlowLayout, animated: true)
    }
}

class VerticalTagsCollectionView: TagsCollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.verticalTagCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCollectionViewLayout(UICollectionViewFlowLayout.verticalTagCollectionViewFlowLayout, animated: true)
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

/// A collection view responsible for handling AlbumCollectionCell
class AlbumCollectionView: UICollectionView {
    init(layout: UICollectionViewFlowLayout, scrollDirection: UICollectionView.ScrollDirection) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.albumCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCollectionViewLayout(UICollectionViewFlowLayout.albumCollectionViewFlowLayout, animated: true)
    }
    
    override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        super.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.albumCell)
    }
    
    override func register(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
        super.register(BasicReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Identifier.CollectionViewCell.ReusableView.basicView)
    }
    
    /// Registers the AlbumCollectionCell to this CollectionView
    func register() {
        self.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.albumCell)
        self.register(BasicReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Identifier.CollectionViewCell.ReusableView.basicView)
    }
}
