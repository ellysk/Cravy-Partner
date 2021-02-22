//
//  ProductController.swift
//  Cravy-Partner
//
//  Created by Cravy on 19/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Lottie
import NotificationBannerSwift
import PromiseKit

/// Handles the display of the properties of a product.
class ProductController: UIViewController {
    @IBOutlet weak var imageView: RoundImageView!
    @IBOutlet weak var linkView: LinkView!
    @IBOutlet weak var widgetCollectionView: WidgetCollectionView!
    @IBOutlet weak var titleTagsStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var horizontalTagsCollectionView: HorizontalTagsCollectionView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var marketView: MarketView!
    private var banner: FloatingNotificationBanner?
    var product: Product!
    private var productState: PRODUCT_STATE {
        set {
            product.state = newValue
            marketView.state = newValue
        }
        
        get {
            return product.state
        }
    }
    /// Shows a notification banner notifying the user that the product can be put on the market.
    var isNewProduct: Bool = false
    var productFB: ProductFirebase!
    var delegate: ProductDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productFB = ProductFirebase(state: product.state)
        self.title = product.title
        imageView.image = UIImage(data: product.image)
        imageView.roundFactor = 15
        imageView.cornerMask = UIView.bottomCornerMask
        linkView.delegate = self
        titleLabel.text = product.title
        detailLabel.text = product.description
        widgetCollectionView.register()
        horizontalTagsCollectionView.register()
        self.setFloaterViewWith(image: K.Image.pencilCircleFill, title: K.UIConstant.edit)
        floaterView?.delegate = self
        marketSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if productState == .active {
            marketView.startLoader {
                self.loadProductStats()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if productState == .inActive {
            marketView.playAnimation()
        }
        if isNewProduct {
            self.showFloaterBarNotification(title: K.UIConstant.newProductTitle, subtitle: K.UIConstant.newProductMessage) { (banner) in
                self.banner = banner
            }
        }
    }
    
    private func reloadProduct() {
        self.title = product.title
        imageView.image = UIImage(data: product.image)
        titleLabel.text = product.title
        detailLabel.text = product.description
        horizontalTagsCollectionView.reloadData()
    }
    
    private func marketSetup() {
        //As soon as the view is loaded, set up the state of the market view according to the product state.
        marketView.startLoader {
            self.marketView.state = self.productState
            if self.productState == .inActive {
                self.marketView.stopLoader()
            }
        }
        marketView.addAction {
            if self.marketView.state == .active {
                let alertController = UIAlertController.takeProductOffMarket(actionHandler: {
                    self.updateProductState()
                })
                self.present(alertController, animated: true)
            } else if self.marketView.state == .inActive {
                let post = PostView(toPost: self.product.title)
                let popVC = PopViewController(popView: post, animationView: AnimationView.postAnimation, actionHandler: {
                    self.updateProductState()
                }) {
                    self.marketView.playAnimation()
                }
                self.present(popVC, animated: true) {
                    self.marketView.stopAnimation()
                }
            }
        }
    }
    
    /// Updates the state of the product from its current state to a new state
    private func updateProductState() {
        marketView.startLoader {
            firstly {
                self.productFB.updateMarketStatus(of: self.product) //Update product state
            }.done(on: .main) { (result) in
                guard let value = result.data as? Int, let newState = PRODUCT_STATE(rawValue: value) else {return}
                self.productState = newState
                if newState == .active {
                    self.showStatusBarNotification(title: "\(self.product.title) is \(self.marketView.statTitle!.lowercased())!", style: .success)
                    self.loadProductStats() //Load product market stats
                } else if newState == .inActive {
                    self.showStatusBarNotification(title: "\(self.product.title) is \(self.marketView.statTitle!.lowercased())!", style: .danger)
                }
                newState == .active ? self.delegate?.didPostProduct(self.product, at: nil) : self.delegate?.didPullProduct(self.product)
            }.ensure(on: .main, {
                self.marketView.stopLoader()
            }).catch(on: .main) { (error) in
                self.present(UIAlertController.internetConnectionAlert(actionHandler: self.updateProductState), animated: true)
            }
        }
    }
    
    /// Loads the market status of the product
    private func loadProductStats() {
        firstly {
            try productFB.loadMarketStatus(product: product)
        }.done(on: .main) { (statInfo) in
            self.marketView.numberOfSearches = statInfo[K.Key.searches] as? Int ?? 0
            self.marketView.nuberOfViews = statInfo[K.Key.views] as? Int ?? 0
            self.marketView.numberOfVisits = statInfo[K.Key.visits] as? Int ?? 0
        }.ensure(on: .main) {
            self.marketView.stopLoader()
        }.catch(on: .main) { (error) in
            if let e = error as? CravyError {
                print(e.localizedDescription)
                return
            } else {
                self.present(UIAlertController.internetConnectionAlert(actionHandler: self.loadProductStats), animated: true)
            }
        }
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            if self.isNewProduct {
                UserDefaults.standard.set(self.product.productInfo, forKey: K.Key.newProduct)
                self.isNewProduct = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.productToEditProduct {
            let editProductVC = segue.destination as! EditProductController
            //assign default values
            editProductVC.defaultProduct = product
            editProductVC.delegate = self
        }
    }
}

//MARK:- LinkView Delegate
extension ProductController: LinkViewDelegate {
    func didTapOnLinkView(_ linkView: LinkView) {
        self.openCravyWebKit(link: product?.productLink?.absoluteString) { (cravyWK) in
            cravyWK.delegate = self
            self.navigationController?.pushViewController(cravyWK, animated: true)
        }
    }
}

//MARK:- CravyWebViewController Delegate
extension ProductController: CravyWebViewControllerDelegate {
    func didCommitLink(URL: URL) {
        //TODO
        product.productLink = URL
    }
}


//MARK: UICollectionView DataSource
extension ProductController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == widgetCollectionView {
            return 2
        } else {
            return product.tags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == widgetCollectionView {
            let widgetCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.widgetCell, for: indexPath) as! WidgetCollectionCell
            
            let widget: UIImage = indexPath.item == 0 ? K.Image.thumbsUp : K.Image.cravings
            let widgetTitle: NSMutableAttributedString? = indexPath.item == 0 ? product.recommendations.represent(unit: K.UIConstant.recommendations, size: .small) : product.cravings.represent(unit: K.UIConstant.cravings, size: .small)
            
            widgetCell.setWidgetCell(image: widget, title: widgetTitle)
            
            return widgetCell
        } else {
            let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.tagCell, for: indexPath) as! TagCollectionCell
            tagCell.setTagCollectionCell(tag: product.tags[indexPath.item])
            
            tagCell.tagLabel.font = UIFont.medium.small
            tagCell.isSeparatorHidden = indexPath.item == product.tags.count - 1
            
            return tagCell
        }
    }
}

//MARK:- FloaterView Delegate
extension ProductController: FloaterViewDelegate {
    func didTapFloaterButton(_ floaterView: FloaterView) {
        self.performSegue(withIdentifier: K.Identifier.Segue.productToEditProduct, sender: self)
    }
}

//MARK:- UIScrollView Delegate
extension ProductController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let banner = banner {
            banner.dismiss()
            self.banner = nil
        }
    }
}

//MARK:- Product Delegate
extension ProductController: ProductDelegate {
    func didCreateProduct(_ product: Product) {}
    
    func didSelectProduct(_ product: Product, at indexPath: IndexPath?) {}
    
    func didPostProduct(_ product: Product, at indexPath: IndexPath?) {}
    
    func didPullProduct(_ product: Product) {}
    
    func didEditProduct(_ product: Product) {
        self.product = product
        reloadProduct()
        self.delegate?.didEditProduct(product)
    }
    func didDeleteProduct(_ product: Product) {
        self.delegate?.didDeleteProduct(product)
    }
}
