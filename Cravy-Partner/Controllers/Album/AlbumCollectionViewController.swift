//
//  AlbumCollectionViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 26/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Photos
import CropViewController

/// Handles the diplsay of images from the user's photo library.
class AlbumCollectionViewController: UICollectionViewController {
    private var result: PHFetchResult<PHAsset>!
    private var album: [String : [PHAsset]] = [:]
    private var creationDates: [String] = []
    private var selectedCell: AlbumCollectionCell?
    var presentationDelegate: PresentationDelegate?
    
    /// - Parameter result: The assets fetched from a particular album.
    init(result: PHFetchResult<PHAsset>) {
        self.result = result
        super.init(collectionViewLayout: UICollectionViewFlowLayout.albumCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .clear
        //Assign the result to the class fields so as the loaded and displayed in the collection view.
        result.splitByCreationDate { (album, creationDates) in
            self.album = album
            self.creationDates = creationDates
        }
        
        self.collectionView.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.albumCell)
        self.collectionView.register(BasicReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Identifier.CollectionViewCell.ReusableView.basicView)
    }

    //MARK: - DataSource
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
    
    //MARK:- Delegates
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionCell, let asset = album[creationDates[indexPath.section]]?[indexPath.item] else {return}
        selectedCell = cell
        asset.fetchImage { (HQImage, info) in
            guard let image = HQImage else {return}
            let cropVC = CropViewController(croppingStyle: .default, image: image)
            cropVC.aspectRatioPickerButtonHidden = true
            cropVC.doneButtonTitle = K.UIConstant.confirm
            cropVC.delegate = self
            cropVC.presentAnimatedFrom(self, fromView: cell, fromFrame: cell.frame, setup: nil, completion: nil)
        }
    }
}

extension AlbumCollectionViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        guard let view = selectedCell else {return}
        cropViewController.dismissAnimatedFrom(self, withCroppedImage: view.imageView?.image, toView: view, toFrame: view.frame, setup: nil) { () -> (Void) in
            self.presentationDelegate?.presentation(NewProductViewsController.self, data: image)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        guard let view = selectedCell else {return}        
        cropViewController.dismissAnimatedFrom(self, withCroppedImage: view.imageView?.image, toView: view, toFrame: view.frame, setup: nil, completion: nil)
    }
}
