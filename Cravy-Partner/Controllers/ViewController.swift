//
//  ViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var theCollectionView: UICollectionView!
    @IBOutlet weak var thePageControl: UIPageControl!
    var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theCollectionView.register(DetailCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.detailCell)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        if flowLayout == nil {
            flowLayout = UICollectionViewFlowLayout.singleItemHorizontalFlowLayoutWith(height: theCollectionView.frame.height)
            theCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.Collections.introSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.detailCell, for: indexPath) as! DetailCollectionCell
        
        let title = K.Collections.introSections[indexPath.item]
        let detail = K.Collections.introSectionDetails[title]
        
        cell.setDetailCollectionCell(title: title, detail: detail!)
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        thePageControl.currentPage = collectionView.indexPathsForVisibleItems[0].item
    }
}
