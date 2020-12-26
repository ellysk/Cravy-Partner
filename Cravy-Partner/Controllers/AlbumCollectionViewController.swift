//
//  AlbumCollectionViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 26/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Photos

/// Handles the diplsay of images from the user's photo library.
class AlbumCollectionViewController: UICollectionViewController {
    /// The assets fetched from a particular album.
    var result: PHFetchResult<PHAsset>!
    private var albumCollectionView: AlbumCollectionView {
        guard let collectionView = self.collectionView as? AlbumCollectionView else {fatalError("Collection View type mismatch!")}
        return collectionView
    }
    private var album: [String : [PHAsset]] = [:]
    private var creationDates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //test
        result = PHFetchOptions().cravyPartnerAssets
        
        //Assign the result to the class fields so as the loaded and displayed in the collection view.
        result.splitByCreationDate { (album, creationDates) in
            self.album = album
            self.creationDates = creationDates
        }
        
        self.albumCollectionView.register()
    }
    
    

    // MARK:- DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return creationDates.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album[creationDates[section]]?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.albumCell, for: indexPath) as! AlbumCollectionCell
        
        guard let asset = album[creationDates[indexPath.section]]?[indexPath.item] else {return cell}
        cell.setAlbumCollectionCell(asset: asset)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.Identifier.CollectionViewCell.ReusableView.basicView, for: indexPath) as! BasicReusableView
        reusableView.setBasicReusableView(title: creationDates[indexPath.section])
        
        return reusableView
    }
}
