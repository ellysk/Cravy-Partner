//
//  TagsCollectionViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class TagsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var tagsCollectionView: VerticalTagsCollectionView {
        let verticalTagsCollectionView = self.collectionView as! VerticalTagsCollectionView
        return verticalTagsCollectionView
    }
    var tags: [String : [String]] = ["My tags" : ["Burger", "Beef burger", "Beef"], "Common tags" : ["Fish and Chips", "Halal", "Dessert", "Chicken wings", "Meat and Chips", "Fries", "Chicken", "Vegetarian", "Pizza", "Breakfast", "Lunch", "Dinner"]]
    private var sections: [String] = ["My tags", "Common tags"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagsCollectionView.dragInteractionEnabled = true
        tagsCollectionView.register()
        tagsCollectionView.register(BasicReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Identifier.CollectionViewCell.ReusableView.basicView)
    }
    
    private func reorderTags(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let tag = coordinator.items.first, let sourceIndexPath = tag.sourceIndexPath {
            collectionView.performBatchUpdates({
                self.tags[sections[sourceIndexPath.section]]?.remove(at: sourceIndexPath.item)
                self.tags[sections[destinationIndexPath.section]]?.insert(tag.dragItem.localObject as! String, at: destinationIndexPath.item)

                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
//            coordinator.drop(tag.dragItem, toItemAt: destinationIndexPath)
        }
    }

    //MARK:- DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags[sections[section]]?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.tagCell, for: indexPath) as! TagCollectionCell
        cell.setTagCollectionCell(tag: tags[sections[indexPath.section]]?[indexPath.item], style: .filled)
        
        if indexPath.section == 0 {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        return cell
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
}

//MARK:- UICollectionView DragDelegate
extension TagsCollectionViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("preparing drag session")
        //Get the tag to be dragged
        let tag = tags[sections[indexPath.section]]![indexPath.item]
        //Assign the tag to itemProvider
        let itemProvider = NSItemProvider(object: tag as NSString)
        //Assign the itemProvider to dragItem
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = tag
        
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        print("drag session will begin")
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        print("drag session ended")
    }
}

//MARK:- UICollectionView DropDelegate
extension TagsCollectionViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag {
            print("is dragging...")
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            print("stop dragging")
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("performing drop")
        
        if let destinationIndexPath = coordinator.destinationIndexPath, coordinator.proposal.operation == .move {
            print("performin drop at position \(destinationIndexPath.item)")
            reorderTags(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        } else {
            print("outsideee")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        print("drop session did enter")
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        print("drop session did exit")
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        print("drop sessoon did end")
    }
}

