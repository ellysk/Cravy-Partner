//
//  ImageCollectionTableCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 13/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A Table cell that contains a Collection View registered to ImageCollectionCell.
class ImageCollectionTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var imageCollectionView: UICollectionView!
    var images: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImageCollectionTableCell(images: [UIImage]) {
        self.images = images
        setImageCollectionView()
        self.isTransparent = true
    }
    
    private func setImageCollectionView() {
        if imageCollectionView == nil {
            let layout = UICollectionViewFlowLayout.imageCollectionViewFlowLayout
            imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            imageCollectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.imageCell)
            imageCollectionView.dataSource = self
            imageCollectionView.delegate = self
            imageCollectionView.showsHorizontalScrollIndicator = false
            imageCollectionView.backgroundColor = .clear
            self.addSubview(imageCollectionView)
            imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
            imageCollectionView.VHConstraint(to: self)
            imageCollectionView.heightAnchor(of: layout.itemSize.height)
        } else {
            imageCollectionView.reloadData()
        }
    }
    
    //MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.imageCell, for: indexPath) as! ImageCollectionCell
        cell.setImageCollectionCell(image: images[indexPath.item])
        
        return cell
    }
}
