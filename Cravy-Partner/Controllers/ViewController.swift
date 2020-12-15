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
    var sectionTitles = ["Email notifications", "Push notifications"]
    var settingsTitles = ["Account", "Notifications", "Privacy & Security", "Help & Support", "About"]
    var titles = ["Product updates", "News Letters"]
    var details = ["Receive updates on the product’s cravings and recommendations as well as information regarding the product’s engagement with the customers.", "Receive updates from the Cravy team regarding the application and any changes made to it. Also receive relevant news on food businesses."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.showsFloaterView = true
//        self.floaterView?.imageView.image = K.Image.ellipsisCricleFill
//        self.floaterView?.titleLabel.text = K.UIConstant.settings
//        theTableView.register(ImageCollectionTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.imageCell)
//        theTableView.register(CraveCollectionTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.craveCell)
//        theTableView.register(GalleryTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.galleryCell)
        
//        theTableView.register(BasicTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.basicCell)
//
        
        theTableView.register(ToggleTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.toggleCell)
        
//        let label = UILabel()
//        label.text = K.UIConstant.termsAndAgreement
//        label.font = UIFont.medium.small
//        label.underline()
//        label.textColor = K.Color.primary
//        
//        self.view.addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.centerXYAnchor(to: self.view)
        
//        let textfield = RoundTextField(roundFactor: 5)
//        textfield.text = "EAT Restaurant & Cafe"
//        textfield.font = UIFont.medium.small
//
//        let stackView = textfield.withSectionTitle("Change business name")
//        self.view.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.centerYAnchor(to: self.view)
//        stackView.HConstraint(to: self.view, constant: 16)
        
        
//        let roundImageView = RoundImageView(image: UIImage(named: "promote"), roundfactor: 5)
//        roundImageView.contentMode = .scaleAspectFill
//
//        let placeholderView = roundImageView.withPlaceholderView()
//        placeholderView.translatesAutoresizingMaskIntoConstraints = false
//        placeholderView.heightAnchor(of: 100)
//        placeholderView.widthAnchor(of: 100)
//
//        let stackView = placeholderView.withSectionTitle("Change business logo")
//
//        self.view.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.centerXYAnchor(to: self.view)
        
        
//        let button = UIButton.logOutButton
//        self.view.addSubview(button)
//        button.centerXYAnchor(to: self.view)
        
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
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section <= 2 {
//            return 1
//        } else {
//            return images.count
//        }
        
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell: UITableViewCell!
        
//        if indexPath.section == 0 {
//            print("fucking hell____________")
//            let imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCollectionTableCell
//            imageCell.setImageCollectionTableCell(images: [UIImage(named: "promote")!, UIImage(named: "comingsoon")!])
//
//            cell = imageCell
//        } else if indexPath.section == 1 {
//            print("oi oi oi oi oi oi oi oi oi oi")
//            let craveCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.craveCell, for: indexPath) as! CraveCollectionTableCell
//            craveCell.setCraveCollectionTableCell(craves: ["one", "two"])
//
//            cell = craveCell
//        } else {
//            let galleryCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.galleryCell, for: indexPath) as! GalleryTableCell
//            galleryCell.setGalleryTableCell(layout: layout, images: images[indexPath.item])
//
//            layout.change()
//
//            cell = galleryCell
//        }
        
//        let settingsCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.basicCell, for: indexPath) as! BasicTableCell
//        settingsCell.setBasicCell(image: K.Collections.settingsImages[indexPath.row], title: settingsTitles[indexPath.row])
//
//        return settingsCell
        
        
        var toggleCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.toggleCell, for: indexPath) as! ToggleTableCell
        
        if toggleCell.detailTextLabel == nil {
            toggleCell = ToggleTableCell(style: .subtitle, reuseIdentifier: K.Identifier.TableViewCell.toggleCell)
        }
        
        if indexPath.section == 0 {
            toggleCell.setToggleCell(title: titles[indexPath.row], detail: details[indexPath.row])
        } else {
            toggleCell.setToggleCell(title: titles[indexPath.row], detail: nil)
        }
        
        return toggleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.sectionWithToggle(title: sectionTitles[section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
