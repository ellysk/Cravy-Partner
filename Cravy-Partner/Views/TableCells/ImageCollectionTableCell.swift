//
//  ImageCollectionTableCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 13/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A Table cell that contains a Collection View registered to ImageCollectionCell.
class ImageCollectionTableCell: UITableViewCell, UICollectionViewDataSource {
    private var imageCollectionView: ImageCollectionView!
    var images: [UIImage] = []
    var delegate: UICollectionViewDelegate? {
        set{
            imageCollectionView.delegate = newValue
        }
        
        get {
            return imageCollectionView.delegate
        }
    }
    
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
            imageCollectionView = ImageCollectionView()
            imageCollectionView.register()
            imageCollectionView.dataSource = self
            imageCollectionView.showsHorizontalScrollIndicator = false
            imageCollectionView.backgroundColor = .clear
            self.addSubview(imageCollectionView)
            imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
            imageCollectionView.VHConstraint(to: self)
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
