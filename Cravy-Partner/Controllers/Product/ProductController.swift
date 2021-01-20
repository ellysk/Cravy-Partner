//
//  ProductController.swift
//  Cravy-Partner
//
//  Created by Cravy on 19/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import UIImageColors
import Lottie

/// Handles the display of the properties of a product.
class ProductController: UIViewController {
    @IBOutlet weak var imageView: RoundImageView!
    @IBOutlet weak var linkView: LinkView!
    @IBOutlet weak var widgetCollectionView: WidgetCollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var horizontalTagsCollectionView: HorizontalTagsCollectionView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var marketView: MarketView!
    var link: String?
    var tags = ["Chicken", "Wings", "Street", "Spicy"]
    var productTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chicken wings"
        imageView.roundFactor = 15
        imageView.cornerMask = UIView.bottomCornerMask
        imageView.image = UIImage(named: "bgimage")
        linkView.linkButton.addTarget(self, action: #selector(openWebVC(_:)), for: .touchUpInside)
        titleLabel.text = productTitle
        titleLabel.underline()
        detailLabel.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"
        marketView.numberOfSearches = 254
        marketView.nuberOfViews = 122
        marketView.numberOfVisits = 120
        // Do any additional setup after loading the view.
        additionalSetup()
    }
    
    private func additionalSetup() {
        self.setFloaterViewWith(image: K.Image.pencilCircleFill, title: K.UIConstant.edit)
        floaterView?.delegate = self
        widgetCollectionView.register()
        horizontalTagsCollectionView.register()
        marketView.addAction {
            if self.marketView.state == .active {
                UIAlertController.takeProductOffMarket(actionHandler: {
                    //TODO
                    self.marketView.state = .inActive
                }) { (alertController) in
                    self.present(alertController, animated: true)
                }
            } else {
                let post = PostView(toPost: "Chicken Wings")
                let popVC = PopViewController(popView: post, animationView: AnimationView.postAnimation, actionHandler: {
                     print("post")
                    self.marketView.state = .active
                }) {
                    self.marketView.playAnimation()
                }
                self.present(popVC, animated: true) {
                    self.marketView.stopAnimation()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        marketView.playAnimation()
    }
    
    @objc func openWebVC(_ sender: UIButton) {
        func goToCravyWebVC(isVisiting: Bool, link: String?) {
            let cravyWebVC = CravyWebKitController(URLString: link)
            cravyWebVC.delegate = self
            cravyWebVC.isVisiting = isVisiting
            self.navigationController?.pushViewController(cravyWebVC, animated: true)
        }
        if let link = link {
            goToCravyWebVC(isVisiting: true, link: link)
        } else {
            let alertController = UIAlertController(title: K.UIConstant.oops, message: K.UIConstant.noLinkMessage, preferredStyle: .alert)
            let addLinkAction = UIAlertAction(title: K.UIConstant.addLink, style: .default) { (action) in
                goToCravyWebVC(isVisiting: false, link: nil)
            }
            alertController.addAction(addLinkAction)
            alertController.addAction(UIAlertAction.cancel)
            present(alertController, animated: true)
        }
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.productToEditProduct {
            let editProductVC = segue.destination as! EditProductController
            //store default image
            editProductVC.defaultValues.updateValue(imageView.image!, forKey: UserDefaults.imageKey)
            //store default title
            editProductVC.defaultValues.updateValue(productTitle!, forKey: UserDefaults.titleKey)
            //store default description
            editProductVC.defaultValues.updateValue(detailLabel.text!, forKey: UserDefaults.descriptionKey)
            //store default tags
            editProductVC.defaultValues.updateValue(tags, forKey: UserDefaults.tagsKey)
        }
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
            let widgetTitle: NSMutableAttributedString? = indexPath.item == 0 ? 120.represent(unit: K.UIConstant.recommendations, size: .small) : 344.represent(unit: K.UIConstant.cravings, size: .small)
            
            widgetCell.setWidgetCell(image: widget, title: widgetTitle)
            
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

//MARK:- NewProductViewsController Delegate
extension ProductController: NewProductViewsControllerDelegate {
    func didCreateProduct() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done(_:)))
    }
}

//MARK:- FloaterView Delegate
extension ProductController: FloaterViewDelegate {
    func didTapFloaterButton(_ floaterView: FloaterView) {
        self.performSegue(withIdentifier: K.Identifier.Segue.productToEditProduct, sender: self)
    }
}

//MARK:- CravyWebViewController Delegate
extension ProductController: CravyWebViewControllerDelegate {
    func didCommitLink(URL: URL) {
        link = URL.absoluteString
        print("commited!")
    }
}
