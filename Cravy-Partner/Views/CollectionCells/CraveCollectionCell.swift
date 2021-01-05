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
    private var craveImageView: CraveImageView!
    private var craveTitleRecommendationStackView: UIStackView!
    private var craveTitleLabel: UILabel!
    private var craveRecommendationLabel: UILabel!
    private var craveTagsCollectionView: UICollectionView!
    private var tags: [String]?
    private var style: CRAVE_COLLECTION_STYLE!
    var interactable: INTERACTABLE? {
        return craveImageView.interactable
    }
    private var action: ()->() = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Initializes the subviews in this cell while optionally populating them with the related data.
    ///   - style: Determines the layout style of the cell. The default is expanded whereby all the view are visible except the interactable view inside a CraveImageView. contained style does not show the TagsCollectionView and displays a UIButton inside the CraveImageView.
    func setCraveCollectionCell(image: UIImage? = nil, cravings: Int? = nil, title: String? = nil, recommendations: Int? = nil, tags: [String]? = nil, stat: String? = nil, style: CRAVE_COLLECTION_STYLE = .expanded) {
        self.style = style
        setContainerView()
        setToolBarView(stat: stat)
        setCraveView(image: image, cravings: cravings, title: title, recommendations: recommendations, tags: tags)
        self.isTransparent = true
    }
    
    private func setContainerView() {
        if containerView == nil {
            containerView = UIStackView()
            containerView.set(axis: .vertical, spacing: 0)
            self.addSubview(containerView)
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
    
    private func setCraveView(image: UIImage? = nil, cravings: Int? = nil, title: String? = nil, recommendations: Int? = nil, tags: [String]? = nil) {
        if craveView == nil {
            craveView = RoundView(roundFactor: 15)
            craveView.backgroundColor = K.Color.secondary
            containerView.addArrangedSubview(craveView)
        }
        setCraveImageView(image: image, cravings: cravings)
        setCraveTitleRecommendationStackView(title: title, recommendations: recommendations)
        setCraveTagsCollectionView(tags: tags)
    }
    
    private func setCraveImageView(image: UIImage? = nil, cravings: Int? = nil) {
        if craveImageView == nil {
            craveImageView = CraveImageView(image: image, cravings: cravings)
            
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
            craveImageView.cravings = cravings
        }
    }
    
    private func setCraveTitleLabel(title: String? = nil) {
        if craveTitleLabel == nil {
            craveTitleLabel = UILabel()
            craveTitleLabel.text = title
            craveTitleLabel.font = UIFont.bold.small
            craveTitleLabel.textAlignment = .left
            craveTitleLabel.textColor = K.Color.dark
        } else {
            craveTitleLabel.text = title
        }
    }
    
    private func setCraveRecommendationLabel(recommendations: Int? = nil) {
        if craveRecommendationLabel == nil {
            craveRecommendationLabel = UILabel()
            craveRecommendationLabel.text = "\(recommendations ?? 0) \(K.UIConstant.recommendations)"
            craveRecommendationLabel.font = UIFont.regular.xSmall
            craveRecommendationLabel.textAlignment = .left
            craveRecommendationLabel.textColor = K.Color.dark
        } else {
            craveRecommendationLabel.text = "\(recommendations ?? 0) \(K.UIConstant.recommendations)"
        }
    }
    
    private func setCraveTitleRecommendationStackView(title: String? = nil, recommendations: Int? = nil) {
        setCraveTitleLabel(title: title)
        setCraveRecommendationLabel(recommendations: recommendations)
        
        if craveTitleRecommendationStackView == nil {
            craveTitleRecommendationStackView = UIStackView(arrangedSubviews: [craveTitleLabel, craveRecommendationLabel])
            craveTitleRecommendationStackView.set(axis: .vertical, alignment: .leading, spacing: 1)
            craveView.addSubview(craveTitleRecommendationStackView)
            craveTitleRecommendationStackView.translatesAutoresizingMaskIntoConstraints = false
            craveTitleRecommendationStackView.topAnchor.constraint(equalTo: craveImageView.bottomAnchor, constant: 3).isActive = true
            craveTitleRecommendationStackView.HConstraint(to: self, constant: 8)
        }
    }
    
    private func setCraveTagsCollectionView(tags: [String]? = nil) {
        if style == .expanded {
            self.tags = tags
            
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
                let post = PostView(toPost: "Chicken Wings")
                let popViewController = PopViewController(popView: post, animationView: AnimationView.postAnimation) {
                    print("post")
                }
                presentationHandler(popViewController)
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
        return tags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.tagCell, for: indexPath) as! TagCollectionCell
        
        cell.setTagCollectionCell(tag: tags![indexPath.item])
        cell.isSeparatorHidden = indexPath.item == tags!.count - 1
        
        return cell
    }
}
