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
    @IBOutlet weak var imageCollectionView: ImageCollectionView!
    @IBOutlet weak var PRCollectionViewContainer: UIView!
    @IBOutlet weak var galleryTableViewContainer: UIView!
    var PRCollectionVC: PRCollectionViewController!
    var businessInfo: [String:Any] = [:] //TODO
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBusinessInfo()
        // Do any additional setup after loading the view.
        businessView.delegate = self
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
    func didSelectProduct(_ product: String, at indexPath: IndexPath?) {
        //User selected a product in the CraveCollectionCell
        self.performSegue(withIdentifier: K.Identifier.Segue.businessToProduct, sender: self)
    }
    
    func didPostProduct(_ product: String, at indexPath: IndexPath?) {
        guard let path = indexPath else {return}
        PRCollectionVC.craves.remove(at: path.item)
        PRCollectionVC.collectionView.deleteItems(at: [path])
    }
}

//MARK: - LayoutUpdate Delegate
extension BusinessController: LayoutUpdateDelegate {
    func updateLayoutHeight(to height: CGFloat) {
        galleryTableViewContainer.heightAnchor(of: height)
        galleryTableViewContainer.setNeedsLayout()
    }
}
