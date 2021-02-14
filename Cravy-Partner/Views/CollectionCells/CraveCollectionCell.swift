//
//  CraveCollectionCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Lottie

enum CRAVE_COLLECTION_STYLE {
    case contained
    case expanded
}

/// A cell that displays infromation of a product. Use craveCollectionViewFlowLayout to set the layout of the collection view registered with this cell.
class CraveCollectionCell: UICollectionViewCell {
    private var containerView: UIStackView!
    private var toolBarStackView: UIStackView!
    private var statLabel: UILabel!
    private var craveView: RoundView!
    var craveImageView: CraveImageView!
    private var craveTitleRecommendationStackView: UIStackView!
    private var craveTitleLabel: UILabel!
    private var craveRecommendationLabel: UILabel!
    private var craveTagsCollectionView: UICollectionView!
    private var product: Product?
    private var style: CRAVE_COLLECTION_STYLE!
    var interactable: INTERACTABLE? {
        return craveImageView.interactable
    }
    private var action: ()->() = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeRounded(roundFactor: 15, cornerMask: nil)
    }
    
    /// Initializes the subviews in this cell while optionally populating them with the related data.
    ///   - style: Determines the layout style of the cell. The default is expanded whereby all the view are visible except the interactable view inside a CraveImageView. contained style does not show the TagsCollectionView and displays a UIButton inside the CraveImageView.
    func setCraveCollectionCell(product: Product? = nil, style: CRAVE_COLLECTION_STYLE = .expanded, stat: String? = nil) {
        self.isTransparent = true
        self.product = product
        self.style = style
        setContainerView()
        setToolBarView(stat: stat)
        setCraveView()
    }
    
    private func setContainerView() {
        if containerView == nil {
            containerView = UIStackView()
            containerView.set(axis: .vertical, spacing: 0)
            self.contentView.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.VHConstraint(to: self)
        }
    }
    
    private func setToolBarView(stat: String? = nil) {
        if style == .expanded {
            if toolBarStackView == nil && statLabel == nil {
                let optionsButton = UIButton.optionsButton
                optionsButton.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
                optionsButton.imageEdgeInsets.left = 8
                optionsButton.contentHorizontalAlignment = .left
                
                statLabel = UILabel()
                statLabel.text = stat
                statLabel.font = UIFont.medium.xSmall
                statLabel.textAlignment = .center
                statLabel.textColor = K.Color.important
                
                toolBarStackView = UIStackView(arrangedSubviews: [optionsButton, statLabel])
                toolBarStackView.set(axis: .horizontal, alignment: .center, distribution: .fillEqually, spacing: 0)
                
                containerView.addArrangedSubview(toolBarStackView)
            } else {
                statLabel.text = stat
            }
        }
    }
    
    private func setCraveView() {
        if craveView == nil {
            craveView = RoundView(roundFactor: 15)
            craveView.backgroundColor = K.Color.secondary
            containerView.addArrangedSubview(craveView)
        }
        setCraveImageView()
        setCraveTitleRecommendationStackView()
        setCraveTagsCollectionView()
    }
    
    private func setCraveImageView() {
        let image = product?.image == nil ? nil : UIImage(data: product!.image)
        if craveImageView == nil {
            craveImageView = CraveImageView(image: image, cravings: product?.cravings)
            craveView.addSubview(craveImageView)
            craveImageView.translatesAutoresizingMaskIntoConstraints = false
            craveImageView.topAnchor(to: craveView)
            craveImageView.HConstraint(to: craveView)
            
            if style == .expanded {
                craveImageView.heightAnchor(of: 230)
            } else {
                craveImageView.heightAnchor(of: 180)
            }
        } else {
            craveImageView.craveImage = image
            craveImageView.cravings = product?.cravings
        }
    }
    
    private func setCraveTitleLabel() {
        if craveTitleLabel == nil {
            craveTitleLabel = UILabel()
            craveTitleLabel.text = product?.title
            craveTitleLabel.font = UIFont.bold.small
            craveTitleLabel.textAlignment = .left
            craveTitleLabel.textColor = K.Color.dark
        } else {
            craveTitleLabel.text = product?.title
        }
    }
    
    private func setCraveRecommendationLabel() {
        if craveRecommendationLabel == nil {
            craveRecommendationLabel = UILabel()
            craveRecommendationLabel.text = "\(product?.recommendations ?? 0) \(K.UIConstant.recommendations)"
            craveRecommendationLabel.font = UIFont.regular.xSmall
            craveRecommendationLabel.textAlignment = .left
            craveRecommendationLabel.textColor = K.Color.dark
        } else {
            craveRecommendationLabel.text = "\(product?.recommendations ?? 0) \(K.UIConstant.recommendations)"
        }
    }
    
    private func setCraveTitleRecommendationStackView() {
        setCraveTitleLabel()
        setCraveRecommendationLabel()
        
        if craveTitleRecommendationStackView == nil {
            craveTitleRecommendationStackView = UIStackView(arrangedSubviews: [craveTitleLabel, craveRecommendationLabel])
            craveTitleRecommendationStackView.set(axis: .vertical, alignment: .leading, spacing: 1)
            craveView.addSubview(craveTitleRecommendationStackView)
            craveTitleRecommendationStackView.translatesAutoresizingMaskIntoConstraints = false
            craveTitleRecommendationStackView.topAnchor.constraint(equalTo: craveImageView.bottomAnchor, constant: 3).isActive = true
            craveTitleRecommendationStackView.HConstraint(to: self, constant: 8)
        }
    }
    
    private func setCraveTagsCollectionView() {
        if style == .expanded {
            if craveTagsCollectionView == nil {
                craveTagsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.horizontalTagCollectionViewFlowLayout)
                craveTagsCollectionView.showsHorizontalScrollIndicator = false
                craveTagsCollectionView.register(TagCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.tagCell)
                craveTagsCollectionView.dataSource = self
                craveTagsCollectionView.delegate = self
                craveTagsCollectionView.backgroundColor = .clear
                craveView.addSubview(craveTagsCollectionView)
                craveTagsCollectionView.translatesAutoresizingMaskIntoConstraints = false
                craveTagsCollectionView.topAnchor.constraint(equalTo: craveTitleRecommendationStackView.bottomAnchor, constant: 8).isActive = true
                craveTagsCollectionView.heightAnchor(of: 30)
                craveTagsCollectionView.HConstraint(to: craveView)
            } else {
                craveTagsCollectionView.reloadData()
            }
        }
    }
    
    /// Enables the view to have an interactable that initiate an action. This mainly includes a post button or link view.
    func addInteractable(_ interactable: INTERACTABLE, presentationHandler: @escaping (PopViewController)->()) {
        craveImageView.addInteractable(interactable) {
            if interactable == .post {
                //A post button interaction to allow user to post the product to the market
                let post = PostView(toPost: "Chicken Wings")
                let popVC = PopViewController(popView: post, animationView: AnimationView.postAnimation)
                presentationHandler(popVC)
            } else if interactable == .promote {
                //A promote button interaction to allow user to promote the product on the market
                let promo = PromoView(toPromote: "Chicken Wings")
                let popVC = PopViewController(popView: promo, animationView: AnimationView.promoteAnimation)
                presentationHandler(popVC)
            }
        }
    }
    
    func addAction(_ action: @escaping ()->()) {
        self.action = action
    }
    
    @objc func action(_ sender: UIButton) {
        action()
    }
}

//MARK: - TagCollectionView DataSource, Delegate
extension CraveCollectionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.tags.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.tagCell, for: indexPath) as! TagCollectionCell
        
        cell.setTagCollectionCell(tag: product!.tags[indexPath.item])
        cell.isSeparatorHidden = indexPath.item == product!.tags.count - 1
        
        return cell
    }
}
