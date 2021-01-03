//
//  BusinessController.swift
//  Cravy-Partner
//
//  Created by Cravy on 20/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Handles the display of the business/restaurant/owner/cook properties.
class BusinessController: UIViewController {
    @IBOutlet weak var businessView: BusinessView!
    @IBOutlet weak var businessStatView: BusinessStatView!
    @IBOutlet weak var businessTableView: UITableView!
    private var galleryLayout: GALLERY_LAYOUT = .uzumaki
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessView.image = UIImage(named: "bgimage")
        businessView.name = "EAT Restaurant & Cafe"
        businessView.email = "eat@restcafe.co.uk"
        businessStatView.recommendations = 608
        businessStatView.subscribers = 130
        // Do any additional setup after loading the view.
        self.view.setCravyGradientBackground()
        self.setFloaterViewWith(image: K.Image.ellipsisCricleFill, title: K.UIConstant.settings)
        businessTableView.register(ImageCollectionTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.imageCell)
        businessTableView.register(CraveCollectionTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.craveCell)
        businessTableView.register(GalleryTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.galleryCell)
    }
}

//MARK: - UITableView DataSource
extension BusinessController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return K.Collections.businessSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let imageCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.imageCell, for: indexPath) as! ImageCollectionTableCell
            imageCell.setImageCollectionTableCell(images: K.Collections.businessStandoutImages)
            
            return imageCell
        } else if indexPath.section == 1 {
            let craveCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.craveCell, for: indexPath) as! CraveCollectionTableCell
            craveCell.setCraveCollectionTableCell(craves: ["one", "two"])
            
            return craveCell
        } else {
            let galleryCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.galleryCell, for: indexPath) as! GalleryTableCell
            galleryCell.setGalleryTableCell(layout: galleryLayout, images: Array(repeating: UIImage(named: "bgimage")!, count: 5))
            galleryLayout.change()
            
            return galleryCell
        }
    }
}

//MARK: - UITableView Delegate
extension BusinessController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.sectionWithTitle(K.Collections.businessSectionTitles[section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let layout = UICollectionViewFlowLayout.imageCollectionViewFlowLayout
            return layout.itemSize.height
        } else {
            return UITableView.automaticDimension
        }
    }
}
