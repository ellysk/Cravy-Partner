//
//  BusinessController.swift
//  Cravy-Partner
//
//  Created by Cravy on 20/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Lottie

/// Handles the display of the business/restaurant/owner/cook properties.
class BusinessController: UIViewController {
    @IBOutlet weak var businessView: BusinessView!
    @IBOutlet weak var businessStatView: BusinessStatView!
    @IBOutlet weak var businessTableView: UITableView!
    /// The first layout of the gallery
    private var galleryLayout: GALLERY_LAYOUT = .uzumaki
    var link: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessView.image = UIImage(named: "bgimage")
        businessView.name = "EAT Restaurant & Cafe"
        businessView.email = "eat@restcafe.co.uk"
        businessView.linkButton.addTarget(self, action: #selector(openWebKit(_:)), for: .touchUpInside)
        businessStatView.recommendations = 608
        businessStatView.subscribers = 130
        // Do any additional setup after loading the view.
        self.view.setCravyGradientBackground()
        self.setFloaterViewWith(image: K.Image.ellipsisCricleFill, title: K.UIConstant.settings)
        businessTableView.register(ImageCollectionTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.imageCell)
        businessTableView.register(CraveCollectionTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.craveCell)
        businessTableView.register(GalleryTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.galleryCell)
    }
    
    @objc func openWebKit(_ sender: UIButton) {
        self.openCravyWebKit(link: link, alertTitle: K.UIConstant.noBusinessLinkMessage) { (cravyWK) in
            cravyWK.delegate = self
            self.navigationController?.pushViewController(cravyWK, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.businessToProduct {
            let productVC = segue.destination as! ProductController
            productVC.productTitle = "Chicken wings"
        }
    }
}

//MARK: - CravyWebKitController Delegate
extension BusinessController: CravyWebViewControllerDelegate {
    func didCommitLink(URL: URL) {
        //TODO
        link = URL.absoluteString
    }
}

//MARK: - UITableView DataSource, CraveCollectionTableCell Delegate
extension BusinessController: UITableViewDataSource, CraveCollectionTableCellDelegate {
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
            //IMAGE CELL
            let imageCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.imageCell, for: indexPath) as! ImageCollectionTableCell
            imageCell.setImageCollectionTableCell(images: K.Collections.businessStandoutImages)
            imageCell.delegate = self
            
            return imageCell
        } else if indexPath.section == 1 {
            //CRAVE CELL
            let craveCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.craveCell, for: indexPath) as! CraveCollectionTableCell
            craveCell.setCraveCollectionTableCell(craves: ["one", "two"])
            craveCell.delegate = self
            craveCell.collectionViewDelegate = self
            
            return craveCell
        } else {
            //GALLERY CELL
            let galleryCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.galleryCell, for: indexPath) as! GalleryTableCell
            galleryCell.tag = indexPath.row
            galleryCell.setGalleryTableCell(layout: galleryLayout, images: Array(repeating: UIImage(named: "bgimage")!, count: 5))
            galleryLayout.change()
            galleryCell.delegate = self
            
            return galleryCell
        }
    }
    
    func willPresent(popViewController: PopViewController) {
        self.present(popViewController, animated: true)
    }
}

//MARK: - UITableView Delegate
extension BusinessController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
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

//MARK: - UICollectionView Delegate
extension BusinessController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == K.ViewTag.IMAGE_COLLECTION_VIEW {
            //User selected an item in the ImageCollectionTableCell
            if indexPath.item == 0 {
                //TODO
                //PROMOTE
            } else if indexPath.item == 1 {
                //COMING SOON
                let popV = PopView(title: K.UIConstant.comingSoonTitle, detail: K.UIConstant.comingSoonMessage, actionTitle: K.UIConstant.doIt)
                let popVC = PopViewController(popView: popV, animationView: AnimationView.comingSoonAnimation, actionHandler: {
                    //TODO
                })
                present(popVC, animated: true)
            }
        } else if collectionView.tag == K.ViewTag.CRAVE_COLLECTION_VIEW {
            //User selected an item in the CraveCollectionTableCell
            self.performSegue(withIdentifier: K.Identifier.Segue.businessToProduct, sender: self)
        }
    }
}

//MARK: - GalleryTableCell Delegate
extension BusinessController: GalleryTableCellDelegate {
    func didTapOnImageAt(indexPath: IndexPath, tappedImage: UIImage) {
        print("did tap on image at position \(indexPath.row) in row \(indexPath.section)")
        //TODO
    }
}
