//
//  EditTagsController.swift
//  Cravy-Partner
//
//  Created by Cravy on 19/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// Handles the display and editing of the product's tags information.
class EditTagsController: UIViewController {
    @IBOutlet weak var blurrImageView: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var backgroundImage: UIImage!
    var tags: [String]!
    var defaultTags: [String]!
    var delegate: TagsCollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurrImageView.image = backgroundImage
        blurrImageView.isBlurr = true
        doneButton.isEnabled = false
        defaultTags = tags
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toTagsCollectionVC {
            let tagsCollectionVC = segue.destination as! TagsCollectionViewController
            tagsCollectionVC.tags["My tags"] = tags
            tagsCollectionVC.delegate = self
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.didUpdateTags(tags: tags)
    }
}

//MARK:- TagsCollectionViewController Delegate
extension EditTagsController: TagsCollectionViewControllerDelegate {
    func didUpdateTags(tags: [String]) {
        doneButton.isEnabled = defaultTags != tags
        self.tags = tags
    }
}
