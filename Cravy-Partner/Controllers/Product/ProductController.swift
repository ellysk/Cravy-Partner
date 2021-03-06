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
    var link: String?
    var tags: [String] = []
    var productTitle: String!
    var recomm: Int = 0
    var cravings: Int = 0
    var isLoadingStats: Bool = true
    /// Shows a notification banner notifying the user that the product can be put on the market.
    var showFloaterBanner: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chicken wings"
        imageView.roundFactor = 15
        imageView.cornerMask = UIView.bottomCornerMask
        linkView.delegate = self
        loadProductInfo()
        // Do any additional setup after loading the view.
        additionalSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        marketView.playAnimation()
        if showFloaterBanner {
            self.showFloaterBarNotification(title: K.UIConstant.newProductTitle, subtitle: K.UIConstant.newProductMessage) { (banner) in
                self.banner = banner
                self.showFloaterBanner = false
            }
        }
    }
    
    private func startLoadingAnimation() {
        imageView.startLoadingAnimation()
        linkView.isHidden = true
        titleTagsStackView.startLoadingAnimation()
        detailLabel.startLoadingAnimation()
        marketView.startLoadingAnimation()
    }
    
    private func loadProductInfo() {
        //TODO CACHE
        if showFloaterBanner {
            isLoadingStats = false
            assignLoadedData()
        } else {
            startLoadingAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.assignLoadedData()
            }
        }
    }
    
    //TEMP
    private func assignLoadedData() {
        //load image
        self.imageView.stopLoadingAnimation()
        self.imageView.image = UIImage(named: "bgimage")
        
        //Load link
        self.linkView.isHidden = false
        
        //load product stats
        self.recomm = 120
        self.cravings = 344
        self.isLoadingStats = false
        self.widgetCollectionView.reloadData()
        
        //load basic info
        self.detailLabel.stopLoadingAnimation()
        self.titleLabel.text = self.productTitle
        self.titleLabel.underline()
        self.detailLabel.numberOfLines = 0
        self.detailLabel.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"
        
        //load tags
        self.titleTagsStackView.stopLoadingAnimation()
        self.tags = ["Chicken", "Wings", "Street", "Spicy"]
        self.horizontalTagsCollectionView.reloadData()
        
        //load market stats
        self.marketView.stopLoadingAnimation()
        self.marketView.state = .inActive
    }
    
    private func additionalSetup() {
        self.setFloaterViewWith(image: K.Image.pencilCircleFill, title: K.UIConstant.edit)
        floaterView?.delegate = self
        widgetCollectionView.register()
        horizontalTagsCollectionView.register()
        marketView.addAction {
            if self.marketView.state == .active {
                UIAlertController.takeProductOffMarket(actionHandler: {
                    self.updateProductState(to: .inActive)
                }) { (alertController) in
                    self.present(alertController, animated: true)
                }
            } else {
                let post = PostView(toPost: "Chicken Wings")
                let popVC = PopViewController(popView: post, animationView: AnimationView.postAnimation, actionHandler: {
                    self.updateProductState(to: .active)
                }) {
                    self.marketView.playAnimation()
                }
                self.present(popVC, animated: true) {
                    self.marketView.stopAnimation()
                }
            }
        }
    }
    
    private func updateProductState(to state: PRODUCT_STATE) {
        //TODO
        marketView.startLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.marketView.stopAnimation()
            if state == .active {
                self.loadProductStats()
            } else {
                self.marketView.state = state
            }
            let style: BannerStyle = state == .active ? .success : .danger
            self.showStatusBarNotification(title: "\(self.productTitle!) is \(self.marketView.statTitle!.lowercased())!", style: style)
        }
    }
    
    private func loadProductStats() {
        //TODO
        self.marketView.numberOfSearches = 254
        self.marketView.nuberOfViews = 122
        self.marketView.numberOfVisits = 120
        
        self.marketView.state = .active
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.productToEditProduct {
            let editProductVC = segue.destination as! EditProductController
            //assign default image
            editProductVC.defaultValues.updateValue(imageView.image!, forKey: K.Key.image)
            //assign default title
            editProductVC.defaultValues.updateValue(productTitle!, forKey: K.Key.title)
            //assign default description
            editProductVC.defaultValues.updateValue(detailLabel.text!, forKey: K.Key.description)
            //assign default tags
            editProductVC.defaultValues.updateValue(tags, forKey: K.Key.tags)
        }
    }
}

//MARK:- LinkView Delegate
extension ProductController: LinkViewDelegate {
    func didTapOnLinkView(_ linkView: LinkView) {
        self.openCravyWebKit(link: link) { (cravyWK) in
            cravyWK.delegate = self
            self.navigationController?.pushViewController(cravyWK, animated: true)
        }
    }
}

//MARK:- CravyWebViewController Delegate
extension ProductController: CravyWebViewControllerDelegate {
    func didCommitLink(URL: URL) {
        //TODO
        link = URL.absoluteString
    }
}


//MARK: UICollectionView DataSource
extension ProductController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == widgetCollectionView {
            return 2
        } else {
            return tags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == widgetCollectionView {
            let widgetCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.widgetCell, for: indexPath) as! WidgetCollectionCell
            
            let widget: UIImage = indexPath.item == 0 ? K.Image.thumbsUp : K.Image.cravings
            let widgetTitle: NSMutableAttributedString? = indexPath.item == 0 ? recomm.represent(unit: K.UIConstant.recommendations, size: .small) : cravings.represent(unit: K.UIConstant.cravings, size: .small)
            
            widgetCell.setWidgetCell(image: widget, title: widgetTitle)
            
            if isLoadingStats {
                widgetCell.startLoadingAnimation()
            } else {
                widgetCell.stopLoadingAnimation()
            }
            
            return widgetCell
        } else {
            let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.tagCell, for: indexPath) as! TagCollectionCell
            tagCell.setTagCollectionCell(tag: tags[indexPath.item])
            
            tagCell.tagLabel.font = UIFont.medium.small
            tagCell.isSeparatorHidden = indexPath.item == tags.count - 1
            
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
