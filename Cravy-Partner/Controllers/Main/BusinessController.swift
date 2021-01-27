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
    var businessInfo: [String:Any] = [:] //TODO
    var savedLayouts: [GALLERY_LAYOUT] = [.uzumaki, .uchiha, .uzumaki, .uchiha, .uzumaki] //TODO
    var isLoadingKitchen: Bool = true
    var kitchen: [UIImage]?
    private let kitchenDummyCount: Int = 1
    var kitchenCount: Int {
        if isLoadingKitchen {
            return kitchen?.chunked(into: 5).count ?? 0 + kitchenDummyCount
        } else {
            return kitchen?.chunked(into: 5).count ?? 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBusinessInfo()
        loadKitchen()
        // Do any additional setup after loading the view.
        businessView.delegate = self
        self.view.setCravyGradientBackground()
        self.setFloaterViewWith(image: K.Image.ellipsisCricleFill, title: K.UIConstant.settings)
        self.floaterView?.delegate = self
        businessTableView.register(ImageCollectionTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.imageCell)
        businessTableView.register(CraveCollectionTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.craveCell)
        businessTableView.register(GalleryTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.galleryCell)
    }
    
    private func loadBusinessInfo() {
        //TODO
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            //load business info
            self.businessView.stopLoadingAnimation()
            self.businessView.image = UIImage(named: "bgimage")
            self.businessView.name = "EAT Restaurant & Cafe"
            self.businessView.email = "eat@restcafe.co.uk"
            
            //load business stat
            self.businessStatView.stopLoadingAnimation()
            self.businessStatView.recommendations = 608
            self.businessStatView.subscribers = 130
        }
    }
    
    private func loadKitchen() {
        //TODO
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoadingKitchen = false
            self.kitchen = Array(repeating: UIImage(named: "bgimage")!, count: 5)
            self.businessTableView.reloadSections(IndexSet(integer: 2), with: .none)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.businessToProduct {
            let productVC = segue.destination as! ProductController
            productVC.productTitle = "Chicken wings"
        }
    }
}

//MARK: - LinkView Delegate
extension BusinessController: LinkViewDelegate {
    func didTapOnLinkView(_ linkView: LinkView) {
        self.openCravyWebKit(link: businessInfo[K.Key.url] as? String, alertTitle: K.UIConstant.noBusinessLinkMessage) { (cravyWK) in
            cravyWK.delegate = self
            self.navigationController?.pushViewController(cravyWK, animated: true)
        }
    }
}

//MARK: - CravyWebKitController Delegate
extension BusinessController: CravyWebViewControllerDelegate {
    func didCommitLink(URL: URL) {
        //TODO
        businessInfo.updateValue(URL.absoluteString, forKey: K.Key.url)
    }
}

//MARK: - UITableView DataSource
extension BusinessController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return K.Collections.businessSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return kitchenCount
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
            craveCell.setCraveCollectionTableCell()
            craveCell.delegate = self
            craveCell.collectionViewDelegate = self
            
            return craveCell
        } else {
            //GALLERY CELL
            let galleryCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.galleryCell, for: indexPath) as! GalleryTableCell
            if isLoadingKitchen && indexPath.row >= kitchen?.count ?? 0 {
                galleryCell.setGalleryTableCell()
                galleryCell.startLoadingAnimation()
            } else {
                galleryCell.stopLoadingAnimation()
                if let myKitchen = kitchen {
                    galleryCell.setGalleryTableCell(layout: savedLayouts[indexPath.row], images: myKitchen)
                    galleryCell.tag = indexPath.row
                    galleryCell.delegate = self
                } else {
                    //TODO
                }
            }
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
        } else if indexPath.section == 2 {
            return 300
        } else {
            return UITableView.automaticDimension
        }
    }
}

//MARK: - CraveCollectionTableCell Delegate
extension BusinessController: CraveCollectionTableCellDelegate {
    func willPresent(popViewController: PopViewController) {
        popViewController.action = {
            //TODO
            let loaderVC = LoaderViewController()
            self.present(loaderVC, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    loaderVC.stopLoader {
                        print("posted!")
                    }
                }
            }
        }
        self.present(popViewController, animated: true)
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

//MARK: - FloaterView Delegate
extension BusinessController: FloaterViewDelegate {
    func didTapFloaterButton(_ floaterView: FloaterView) {
        //Go to settings
        self.performSegue(withIdentifier: K.Identifier.Segue.businessToSettings, sender: self)
    }
}
