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
    @IBOutlet weak var backNavButton: UIButton!
    @IBOutlet weak var linkView: LinkView!
    @IBOutlet weak var widgetCollectionView: WidgetCollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var horizontalTagsCollectionView: HorizontalTagsCollectionView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var marketView: MarketView!
    var tags = ["Chicken", "Wings", "Street", "Spicy"]
    var productTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "bgimage")
        titleLabel.text = productTitle
        titleLabel.underline()
        detailLabel.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"
        marketView.numberOfSearches = 254
        marketView.nuberOfViews = 122
        marketView.numberOfVisits = 120
        // Do any additional setup after loading the view.
        additionalSetup()
    }
    
    private func setBackNavButton() {
        //Get the image that is on the background of the back button
        guard let image = imageView.image else {return}
        //Extract the colors from the image
        image.getColors { (colors) in
            //Get the dominant background color of the image
            guard let background = colors?.background else {return}
            DispatchQueue.main.async {
                //Set the tint color of the back button depending on the contrast of the dominant background color extracted from the image.
                self.backNavButton.tintColor = background.isDarkColor ? K.Color.light : K.Color.dark
            }
        }
    }
    
    private func additionalSetup() {
        setBackNavButton()
        self.setFloaterViewWith(image: K.Image.pencilCircleFill, title: K.UIConstant.edit)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        marketView.playAnimation()
    }
    
    @IBAction func navigateBack(_ sender: UIButton) {
        self.goBack()
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
