//
//  ProductController.swift
//  Cravy-Partner
//
//  Created by Cravy on 19/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Handles the display of the properties of a product.
class ProductController: UIViewController {
    @IBOutlet weak var imageView: RoundImageView!
    @IBOutlet weak var linkView: LinkView!
    @IBOutlet weak var widgetCollectionView: WidgetCollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var horizontalTagsCollectionView: HorizontalTagsCollectionView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var marketView: MarketView!
    var tags = ["Chicken", "Wings", "Street", "Spicy"]
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "bgimage")
        titleLabel.text = "Chicken wings"
        titleLabel.underline()
        detailLabel.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"
        marketView.numberOfSearches = 254
        marketView.nuberOfViews = 122
        marketView.numberOfVisits = 120
        // Do any additional setup after loading the view.
        widgetCollectionView.register()
        horizontalTagsCollectionView.register()
        customiseHorizontalTagsCollectionLayout()
        customiseHorizontalTagsCollectionLayout()
        setFloaterView()
    }
    
    /// Set left inset of the layout to 0
    private func customiseHorizontalTagsCollectionLayout() {
        let layout = horizontalTagsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset.left = 0
    }
    
    /// Show floater view for representing an edit button.
    private func setFloaterView() {
        self.showsFloaterView = true
        floaterView?.imageView.image = K.Image.pencilCircleFill
        floaterView?.titleLabel.text = K.UIConstant.edit
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
