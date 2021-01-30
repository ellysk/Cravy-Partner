//
//  GalleryTableViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

protocol LayoutUpdateDelegate {
    func updateLayoutHeight(to height: CGFloat)
}

class GalleryTableViewController: UITableViewController {
    private var kitchen: [UIImage] = []
    var images: [[UIImage]] {
        return kitchen.chunked(into: 5)
    }
    private var savedLayouts: [GALLERY_LAYOUT] = [.uzumaki, .uchiha, .uzumaki, .uchiha, .uzumaki] //TODO
    private var isLoadingKitchen: Bool = true
    private let kitchenDummyCount: Int = 1
    var kitchenCount: Int {
        if isLoadingKitchen {
            return kitchen.chunked(into: 5).count + kitchenDummyCount
        } else {
            return kitchen.chunked(into: 5).count
        }
    }
    let ROW_HEIGHT: CGFloat = 300
    var layoutDelegate: LayoutUpdateDelegate?
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKitchen()
        self.tableView.backgroundColor = .clear
        self.tableView.allowsSelection = false
        self.tableView.register(GalleryTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.galleryCell)
    }
    
    private func loadKitchen() {
        //TODO
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoadingKitchen = false
            self.kitchen = Array(repeating: UIImage(named: "bgimage")!, count: 10)
            self.layoutDelegate?.updateLayoutHeight(to: self.ROW_HEIGHT * CGFloat(self.kitchenCount))
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kitchenCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let galleryCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.galleryCell, for: indexPath) as! GalleryTableCell
        if isLoadingKitchen && indexPath.row >= kitchen.count {
            galleryCell.setGalleryTableCell()
            galleryCell.startLoadingAnimation()
        } else {
            galleryCell.stopLoadingAnimation()
            if !kitchen.isEmpty {
                galleryCell.setGalleryTableCell(layout: savedLayouts[indexPath.row], images: images[indexPath.row])
                galleryCell.tag = indexPath.row
                galleryCell.delegate = self
            } else {
                //TODO
            }
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
        //TODO
    }
}
