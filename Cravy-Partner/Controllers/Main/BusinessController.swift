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

/// Handles the display of the business/restaurant/owner/cook properties.
class BusinessController: UIViewController {
    @IBOutlet weak var businessView: BusinessView!
    @IBOutlet weak var businessStatView: BusinessStatView!
    @IBOutlet weak var imageCollectionView: ImageCollectionView!
    @IBOutlet weak var PRCollectionViewContainer: UIView!
    @IBOutlet weak var galleryTableViewContainer: UIView!
    var PRCollectionVC: PRCollectionViewController!
    var business: Business! {
        guard let info = UserDefaults.standard.dictionary(forKey: Auth.auth().currentUser!.uid), let business = BusinessFireBase.toBusiness(businessInfo: info) else {return nil}
        return business
    }
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
        super.viewWillAppear(true)
        loadBusinessInfo()
    }
            
    private func loadBusinessInfo() {
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
    
    @objc func editImage(_ gesture: UITapGestureRecognizer) {
        //TODO
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toPRCollectionVC {
            let PRCollectionVC = segue.destination as! PRCollectionViewController
            PRCollectionVC.delegate = self
            self.PRCollectionVC = PRCollectionVC
        } else if segue.identifier == K.Identifier.Segue.toGalleryTableVC {
            let galleryTableVC = segue.destination as! GalleryTableViewController
            galleryTableVC.layoutDelegate = self
        } else if segue.identifier == K.Identifier.Segue.businessToProduct {
            let productVC = segue.destination as! ProductController
//            productVC.productTitle = "Chicken wings" TODO
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
                    try UserDefaults.standard.updateBusinessInfo(key: K.Key.url, value: URL.absoluteString, id: self.business.id)
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
        self.performSegue(withIdentifier: K.Identifier.Segue.businessToProduct, sender: self)
    }
    
    func didPostProduct(_ product: Product, at indexPath: IndexPath?) {
        guard let path = indexPath else {return}
        PRCollectionVC.craves.remove(at: path.item)
        PRCollectionVC.collectionView.deleteItems(at: [path])
    }
    
    func didPullProduct(_ product: Product) {}
    
    func didEditProduct(_ product: Product) {}
    
    func didDeleteProduct(_ product: Product) {}
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
        var imagePromise: Promise<(Data, URL?)>!
        
        func confirm() {
            do {
                if business.logo == nil {
                    imagePromise = try businessFB.saveImage(image, at: K.Key.businessImagesPath)
                } else if let url = business.logoURL {
                    imagePromise = when(fulfilled: try businessFB.saveImage(on: url, image: image), Promise { (seal) in
                        seal.fulfill(nil)
                    })
                }
            } catch {
                //TODO CRAVY ERROR
                print(error)
            }
            
            self.startLoader { (loaderVC) in
                firstly {
                    imagePromise
                }.done(on: .main) { (imageInfo) in
                    let (data, url) = imageInfo
                    self.businessView.image = UIImage(data: data)
                    try UserDefaults.standard.updateBusinessInfo(key: K.Key.logo, value: data, id: self.business.id)
                    if let imageURL = url {
                        try UserDefaults.standard.updateBusinessInfo(key: K.Key.logoURL, value: imageURL.absoluteString, id: self.business.id)
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
