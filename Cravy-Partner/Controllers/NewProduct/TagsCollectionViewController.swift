//
//  TagsCollectionViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Lottie

/// Handles the display of the tags that the user can select and manage.
class TagsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var tagsCollectionView: VerticalTagsCollectionView {
        let verticalTagsCollectionView = self.collectionView as! VerticalTagsCollectionView
        return verticalTagsCollectionView
    }
    var tags: [String : [String]] = ["My tags" : ["Burger", "Beef burger", "Beef"], "Common tags" : ["Fish and Chips", "Halal", "Dessert", "Chicken wings", "Meat and Chips", "Fries", "Chicken", "Vegetarian", "Pizza", "Breakfast", "Lunch", "Dinner"]]
    private var sections: [String] = ["My tags", "Common tags"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagsCollectionView.register()
        tagsCollectionView.register(BasicReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Identifier.CollectionViewCell.ReusableView.basicView)
        tagsCollectionView.register(NewCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.newCell)
    }

    //MARK:- DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = tags[sections[section]]?.count ?? 0
        if section == 0 {
            return count + 1 //The extra item is the NewCollectionCell
        } else {
            return count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //If there are tags in the first section and the item is at a position greater than the count of the tags in the section, then return a NewCollectionCell.
        if let myTags = tags[sections[0]], indexPath.section == 0, indexPath.item >= myTags.count {
            let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.newCell, for: indexPath) as! NewCollectionCell
            newCell.setNewCollectionCell()
            newCell.delegate = self
            
            return newCell
        } else {
            //Return TagCollectionCell.
            let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.tagCell, for: indexPath) as! TagCollectionCell
            tagCell.setTagCollectionCell(tag: tags[sections[indexPath.section]]?[indexPath.item], style: .filled)
            tagCell.allowsSelection = indexPath.section == 1
            tagCell.defaultBackgroundColor = indexPath.section == 0 ? K.Color.primary : K.Color.light
            tagCell.isSelected = indexPath.section == 0
            
            return tagCell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.Identifier.CollectionViewCell.ReusableView.basicView, for: indexPath) as! BasicReusableView
        reusableView.setBasicReusableView(title: sections[indexPath.section])
        reusableView.titleLabel.textColor = K.Color.light.withAlphaComponent(0.8)
        
        return reusableView
    }
    
    //MARK:- Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //If user has tapped on an item in the second section, then reorder the collection view
        if indexPath.section == 1 {
            //Update sturcture/model of tags.
            let tagToAdd = tags[sections[1]]![indexPath.item] //The tag being seleceted.
            tags[sections[0]]!.append(tagToAdd) //Add tag to the first section which represents the user's preference tags.
            
            //Reorder the collection view
            collectionView.performBatchUpdates({
                let item = collectionView.numberOfItems(inSection: 0) - 1
                let destinationIndexPath = IndexPath(item: item, section: 0)
                
                collectionView.insertItems(at: [destinationIndexPath])
            }) { (completed) in
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
}

//MARK:- FloaterView Delegate
extension TagsCollectionViewController: FloaterViewDelegate {
    func didTapFloaterButton(_ floaterView: FloaterView) {
        //TODO
        let popV = PopView(title: K.UIConstant.newTag, detail: K.UIConstant.newTagDetail, actionTitle: K.UIConstant.add)
        let popVC = PopViewController(popView: popV, animationView: AnimationView.ingredientsAnimation, actionHandler: {
            print("add tag")
        })
        present(popVC, animated: true, completion: nil)
    }
}

