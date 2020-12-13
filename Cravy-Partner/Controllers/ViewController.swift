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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        theTableView.register(GalleryTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.galleryCell)
//        reload(1)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.galleryCell, for: indexPath) as! GalleryTableCell
        cell.setGalleryTableCell(layout: layout, images: images[indexPath.item])
        
        layout.change()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
