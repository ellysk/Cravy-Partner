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
    
    init(scrollDirection: UICollectionView.ScrollDirection) {
        let layout = scrollDirection == .vertical ? UICollectionViewFlowLayout.verticalCraveCollectionViewFlowLayout : UICollectionViewFlowLayout.horizontalCraveCollectionViewFlowLayout
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Registers the CraveCollectionCell to this CollectionView
    func register() {
        self.tag = K.ViewTag.CRAVE_COLLECTION_VIEW
        self.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
    }
}

class HorizontalCraveCollectionView: CraveCollectionView {
    init() {
        super.init(scrollDirection: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCollectionViewLayout(UICollectionViewFlowLayout.horizontalCraveCollectionViewFlowLayout, animated: true)
    }
}

class VerticalCraveCollectionView: CraveCollectionView {
    init() {
        super.init(scrollDirection: .vertical)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCollectionViewLayout(UICollectionViewFlowLayout.verticalCraveCollectionViewFlowLayout, animated: true)
    }
}

/// A collection view responsible for handling TagCollectionCell.
class TagsCollectionView: UICollectionView {
    
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
    
    /// Registers the WidgetCollectionCell to this CollectionView
    func register() {
        self.register(WidgetCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.widgetCell)
    }
}

/// A collection view responsible for handling AlbumCollectionCell
class AlbumCollectionView: UICollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.albumCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCollectionViewLayout(UICollectionViewFlowLayout.albumCollectionViewFlowLayout, animated: true)
    }
    
    /// Registers the AlbumCollectionCell to this CollectionView
    func register() {
        self.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.albumCell)
        self.register(BasicReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Identifier.CollectionViewCell.ReusableView.basicView)
    }
}

/// A collectionView responsible for handling ImageCollectionCell
class ImageCollectionView: UICollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout:  UICollectionViewFlowLayout.imageCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCollectionViewLayout(UICollectionViewFlowLayout.imageCollectionViewFlowLayout, animated: true)
    }
    
    func register() {
        self.tag = K.ViewTag.IMAGE_COLLECTION_VIEW
        self.register(ImageCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.imageCell)
    }
}
