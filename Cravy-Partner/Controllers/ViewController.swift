//
//  ViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var theTableView: UITableView!
    var bgimages: [UIImage] = Array(repeating: UIImage(named: "bgimage")!, count:2)
    var pmimages: [UIImage] = Array(repeating: UIImage(named: "pmimage")!, count: 6)
    var images: [[UIImage]] {
        var array: [UIImage] = []
        array.append(contentsOf: bgimages)
        array.append(contentsOf: pmimages)
        
        return array.chunked(into: GalleryView.MAX_SUBVIEWS)
    }
    var layout: GALLERY_LAYOUT = .uzumaki
    var sectionTitles = ["Make your business stand out", "Let your customers see them", "The Kitchen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theTableView.register(ImageCollectionTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.imageCell)
        theTableView.register(CraveCollectionTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.craveCell)
        theTableView.register(GalleryTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.galleryCell)
    }
    
    func reload(_ count: Int) {
        if count <= 5 {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.bgimages = Array(repeating: UIImage(named: "bgimage")!, count: count)
                self.theTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                let num = count + 1
                self.reload(num)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= 2 {
            return 1
        } else {
            return images.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.section == 0 {
            print("fucking hell____________")
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCollectionTableCell
            imageCell.setImageCollectionTableCell(images: [UIImage(named: "promote")!, UIImage(named: "comingsoon")!])
            
            cell = imageCell
        } else if indexPath.section == 1 {
            print("oi oi oi oi oi oi oi oi oi oi")
            let craveCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.craveCell, for: indexPath) as! CraveCollectionTableCell
            craveCell.setCraveCollectionTableCell(craves: ["one", "two"])
            
            cell = craveCell
        } else {
            let galleryCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.galleryCell, for: indexPath) as! GalleryTableCell
            galleryCell.setGalleryTableCell(layout: layout, images: images[indexPath.item])
            
            layout.change()
            
            cell = galleryCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.sectionWithTitle(sectionTitles[section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
