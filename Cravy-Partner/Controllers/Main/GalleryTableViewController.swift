//
//  GalleryTableViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import PromiseKit

protocol GalleryTableViewControllerDelegate {
    func didTapOnImage(_ image: UIImage, id: String)
    func didFinishLoadingGallery(_ gallery: [UIImage])
}

/// Handles the display of collection of images in a GalleryTableCell.
class GalleryTableViewController: UITableViewController {
    var ids: [String] = []
    var images: [UIImage] = []
    var gIds: [[String]] {
        return ids.chunked(into: 5)
    }
    var gallery: [[UIImage]] {
        return images.chunked(into: 5)
    }
    private var isLoadingGallery: Bool = true
    private let dummyCount: Int = 1
    var count: Int {
        if isLoadingGallery {
            return gallery.count + dummyCount
        } else {
            return gallery.count
        }
    }
    let ROW_HEIGHT: CGFloat = 300
    var productFB = ProductFirebase()
    var layoutDelegate: LayoutUpdateDelegate?
    var delegate: GalleryTableViewControllerDelegate?
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .clear
        self.tableView.allowsSelection = false
        self.tableView.register(GalleryTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.galleryCell)
        loadGallery()
    }
    
    func loadGallery() {
        func finishLoading() {
            self.isLoadingGallery = false
            self.layoutDelegate?.updateLayoutHeight(to: self.ROW_HEIGHT * CGFloat(self.count))
            self.delegate?.didFinishLoadingGallery(self.images)
            self.tableView.reloadData()
        }
        
        if ids.isEmpty || images.isEmpty {
            firstly {
                productFB.loadProductImages()
            }.done { (imageInfo) in
                imageInfo.forEach { (info) in
                    self.ids.append(info.0)
                    self.images.append(UIImage(data: info.1)!)
                }
            }.ensure {
                finishLoading()
            }.catch { (error) in
                self.present(UIAlertController.internetConnectionAlert(actionHandler: self.loadGallery), animated: true)
            }
        } else {
            finishLoading()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let galleryCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.galleryCell, for: indexPath) as! GalleryTableCell
        if isLoadingGallery && indexPath.row >= images.count {
            galleryCell.setGalleryTableCell()
            galleryCell.startLoadingAnimation()
        } else {
            galleryCell.stopLoadingAnimation()
            let layout: GALLERY_LAYOUT = indexPath.row % 2 == 0 ? .uzumaki : .uchiha
            galleryCell.setGalleryTableCell(layout: layout, images: gallery[indexPath.row])
            galleryCell.tag = indexPath.row
            galleryCell.delegate = self
        }
        return galleryCell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ROW_HEIGHT
    }
}

//MARK: - GalleryTableCell Delegate
extension GalleryTableViewController: GalleryTableCellDelegate {
    func didTapOnImageAt(indexPath: IndexPath, tappedImage: UIImage) {
        print("did tap on image at position \(indexPath.row) in row \(indexPath.section)")
        self.delegate?.didTapOnImage(tappedImage, id: gIds[indexPath.section][indexPath.row])
    }
}
