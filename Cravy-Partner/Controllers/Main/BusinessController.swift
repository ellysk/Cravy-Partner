//
//  BusinessController.swift
//  Cravy-Partner
//
//  Created by Cravy on 20/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Lottie
import FirebaseAuth
import FirebaseFirestore
import PromiseKit
import CoreData

/// Handles the display of the business/restaurant/owner/cook properties.
class BusinessController: UIViewController {
    @IBOutlet weak var businessView: BusinessView!
    @IBOutlet weak var businessStatView: BusinessStatView!
    @IBOutlet weak var imageCollectionView: ImageCollectionView!
    @IBOutlet weak var PRStackView: UIStackView!
    @IBOutlet weak var PRCollectionViewContainer: UIView!
    @IBOutlet weak var galleryTableViewContainer: UIView!
    var PRCollectionVC: PRCollectionViewController!
    var business: Business!
    var selectedProduct: Product?
    var businessFB: BusinessFireBase!
    var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
        listener = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessFB = BusinessFireBase()
        businessView.delegate = self
        businessView.businessImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editImage(_:))))
        self.view.setCravyGradientBackground()
        self.setFloaterViewWith(image: K.Image.ellipsisCricleFill, title: K.UIConstant.settings)
        self.floaterView?.delegate = self
        imageCollectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.imageCell)
        imageCollectionView.register(BasicReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Identifier.CollectionViewCell.ReusableView.basicView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageCollectionView.heightAnchor(of: UICollectionViewFlowLayout.imageCollectionViewFlowLayout.itemSize.height)
        PRCollectionViewContainer.heightAnchor(of: UICollectionViewFlowLayout.horizontalCraveCollectionViewFlowLayout.itemSize.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPR()
        loadBusinessInfo()
    }
            
    private func loadBusinessInfo() {
        business = NSManagedObject.business
        self.businessView.image = business.logo == nil ? nil : UIImage(data: business.logo!)
        self.businessView.name = business.name
        self.businessView.email = business.email
        
        
        attachListener()
    }
    
    private func attachListener() {
        if listener == nil {
            listener = businessFB.loadBusiness(completion: { (business) in
                if let business = business {
                    self.businessStatView.recommendations = business.totalRecommendations
                    self.businessStatView.subscribers = business.totalSubscribers
                } else {
                    self.present(UIAlertController.internetConnectionAlert(actionHandler: self.loadBusinessInfo), animated: true)
                }
            })
        }
    }
    
    private func reloadPR() {
        guard let cravyTabBar = self.tabBarController as? CravyTabBarController, let PRVC = PRCollectionVC else {return}
        PRVC.products = cravyTabBar.PRProducts ?? []
    }
    
    @objc func editImage(_ gesture: UITapGestureRecognizer) {
        self.presentEditPhotoAlert(in: self, message: K.UIConstant.addPhoto)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toPRCollectionVC {
            let PRCollectionVC = segue.destination as! PRCollectionViewController
            PRCollectionVC.delegate = self
            PRCollectionVC.PRDelegate = self
            self.PRCollectionVC = PRCollectionVC
            reloadPR()
        } else if segue.identifier == K.Identifier.Segue.toGalleryTableVC {
            let galleryTableVC = segue.destination as! GalleryTableViewController
            galleryTableVC.layoutDelegate = self
        } else if segue.identifier == K.Identifier.Segue.businessToProduct {
            let productVC = segue.destination as! ProductController
            productVC.product = selectedProduct
        }
    }
}

//MARK: - LinkView Delegate
extension BusinessController: LinkViewDelegate {
    func didTapOnLinkView(_ linkView: LinkView) {
        self.openCravyWebKit(link: business.websiteLink?.absoluteString, alertTitle: K.UIConstant.noBusinessLinkMessage) { (cravyWK) in
            cravyWK.delegate = self
            self.navigationController?.pushViewController(cravyWK, animated: true)
        }
    }
}

//MARK: - CravyWebKitController Delegate
extension BusinessController: CravyWebViewControllerDelegate {
    func didCommitLink(URL: URL) {
        func commit() {
            self.startLoader { (loaderVC) in
                firstly {
                    self.businessFB.updateBusiness(update: [K.Key.url : URL.absoluteString])
                }.done { (result) in
                    //Update the cached business info
                    self.business.websiteLink = URL
                    try self.business.cache()
                }.ensure(on: .main, {
                    loaderVC.stopLoader()
                }).catch(on: .main) { (error) in
                    //TODO Cravy Error
                    self.present(UIAlertController.internetConnectionAlert(actionHandler: commit), animated: true)
                }
            }
        }
        commit()
    }
}

//MARK: - UICollectionView DataSource
extension BusinessController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.Collections.businessStandoutImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.imageCell, for: indexPath) as! ImageCollectionCell
        cell.setImageCollectionCell(image: K.Collections.businessStandoutImages[indexPath.item])

        return cell
    }
}

//MARK: - UICollectionView Delegate
extension BusinessController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //User selected an item in the ImageCollectionTableCell [PROMOTE, COMING SOON]
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
    }
}


//MARK: - FloaterView Delegate
extension BusinessController: FloaterViewDelegate {
    func didTapFloaterButton(_ floaterView: FloaterView) {
        //Go to settings
        self.performSegue(withIdentifier: K.Identifier.Segue.businessToSettings, sender: self)
    }
}

//MARK: - Product Delegate
extension BusinessController: ProductDelegate {
    func didCreateProduct(_ product: Product) {}
    
    func didSelectProduct(_ product: Product, at indexPath: IndexPath?) {
        //User selected a product in the CraveCollectionCell
        selectedProduct = product
        self.performSegue(withIdentifier: K.Identifier.Segue.businessToProduct, sender: self)
    }
    
    func didPostProduct(_ product: Product, at indexPath: IndexPath?) {
        guard let path = indexPath else {return}
        PRCollectionVC.products.remove(at: path.item)
        PRCollectionVC.collectionView.deleteItems(at: [path])
    }
    
    func didPullProduct(_ product: Product) {}
    
    func didEditProduct(_ product: Product) {}
    
    func didDeleteProduct(_ product: Product) {}
}

//MARK: - PRCollectionViewController Delegare
extension BusinessController: PRCollectionViewControllerDelegate {
    func PRProductsDidFinishLoading(products: [Product]) {
        PRStackView.isHidden = products.isEmpty
    }
}

//MARK: - LayoutUpdate Delegate
extension BusinessController: LayoutUpdateDelegate {
    func updateLayoutHeight(to height: CGFloat) {
        galleryTableViewContainer.heightAnchor(of: height)
        galleryTableViewContainer.setNeedsLayout()
    }
}

//MARK: - ImageViewController Delegate
extension BusinessController: ImageViewControllerDelegate {
    func didConfirmImage(_ image: UIImage) {
        func confirm() {
            self.startLoader { (loaderVC) in
                firstly {
                    self.businessFB.updateBusiness(update: [K.Key.logo : image], logoURL: self.business.logoURL)
                }.done { (updateInfo) in
                    let (_, info) = updateInfo
                    self.businessView.image = image
                    self.business.logo = image.jpegData(compressionQuality: 1)
                    try self.business.cache()
                    if let imageURL = info as? URL {
                        self.business.logoURL = imageURL.absoluteString
                        try self.business.cache()
                    }
                }.ensure(on: .main, {
                    loaderVC.stopLoader()
                }).catch(on: .main) { (error) in
                    self.present(UIAlertController.internetConnectionAlert(actionHandler: confirm), animated: true)
                }
            }
        }
        confirm()
    }
}
