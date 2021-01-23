//
//  ProductController.swift
//  Cravy-Partner
//
//  Created by Cravy on 19/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
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
        linkView.linkButton.addTarget(self, action: #selector(openWebKit(_:)), for: .touchUpInside)
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
    
    @objc func openWebKit(_ sender: UIButton) {
        self.openCravyWebKit(link: link) { (cravyWK) in
            cravyWK.delegate = self
            self.navigationController?.pushViewController(cravyWK, animated: true)
        }
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

//MARK:- FloaterView Delegate
extension ProductController: FloaterViewDelegate {
    func didTapFloaterButton(_ floaterView: FloaterView) {
        self.performSegue(withIdentifier: K.Identifier.Segue.productToEditProduct, sender: self)
    }
}

//MARK:- CravyWebViewController Delegate
extension ProductController: CravyWebViewControllerDelegate {
    func didCommitLink(URL: URL) {
        //TODO
        link = URL.absoluteString
    }
}
