//
//  GalleryTableCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 11/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

enum GALLERY_LAYOUT: Int {
    case uzumaki
    case uchiha
    
    /// Changes to another layout.
    mutating func change() {
        if self == .uzumaki {
            self = .uchiha
        } else {
            self = .uzumaki
        }
    }
}

protocol GalleryTableCellDelegate {
    /// Called when an image in the gallery view has been tapped by the user.
    /// - Parameters:
    ///   - indexPath: The index path in which the image is at. the row represents the position in which the image is arranged in the view and the section represents the row of this cell.
    ///   - tappedImage: The image tapped by the user.
    func didTapOnImageAt(indexPath: IndexPath, tappedImage: UIImage)
}

/// Displays a collection of RoundImageViews arranged in mutiple stackviews with a layout that is dynamic.
class GalleryTableCell: UITableViewCell {
    private var containerView: UIView!
    private var galleryView: GalleryView?
    var layout: GALLERY_LAYOUT!
    var gesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
    }
    var delegate: GalleryTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// - Parameters:
    ///   - layout: Determines how the image views are layout and presented. adjusts the size and position.
    ///   - images: The images that will be displayed. The maximum number of images displayed is 5.
    func setGalleryTableCell(layout: GALLERY_LAYOUT = .uzumaki, images: [UIImage] = []) {
        self.layout = layout
        setContainerView()
        setGalleryView(images: images)
        self.isTransparent = true
    }
    
    private func setContainerView() {
        if containerView == nil {
            containerView = UIView()
            containerView.backgroundColor = .clear
            self.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.VHConstraint(to: self)
        }
    }
    
    private func setGalleryView(images: [UIImage]) {
        if galleryView == nil {
            galleryView = GalleryView(layout: layout, images: images)
            containerView.addSubview(galleryView!)
            galleryView!.translatesAutoresizingMaskIntoConstraints = false
            galleryView!.VConstraint(to: containerView, constant: 1.5)
            galleryView!.HConstraint(to: containerView, constant: 8)
        } else {
            galleryView?.images = images
            galleryView?.setGalleryStackView(layout: layout)
        }
        
        setGestureRecognizers()
    }
    
    private func setGestureRecognizers() {
        guard let imageGallery = galleryView?.gallery else {return}
        for imageView in imageGallery {
            imageView.addGestureRecognizer(gesture)
        }
    }
    
    @objc func imageTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view as? UIImageView, let image = view.image else {fatalError("NO VIEW IS ASSIGNED TO THE GESTURE")}
        self.delegate?.didTapOnImageAt(indexPath: IndexPath(row: view.tag, section: self.tag), tappedImage: image)
    }
}
