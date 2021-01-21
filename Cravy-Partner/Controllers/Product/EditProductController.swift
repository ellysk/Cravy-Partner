//
//  EditProductController.swift
//  Cravy-Partner
//
//  Created by Cravy on 18/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// Handles the display and editing of the product's information
class EditProductController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var imageView: RoundImageView!
    @IBOutlet weak var titleTextField: RoundTextField!
    @IBOutlet weak var descriptionTextView: RoundTextView!
    @IBOutlet weak var horizontalTagsCollectionView: HorizontalTagsCollectionView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var tagsStackView: UIStackView!
    @IBOutlet weak var linkStackView: UIStackView!
    @IBOutlet weak var deleteButton: UIButton!
    private var productImage: UIImage {
        set {
            imageView.image = newValue
            imageView.showsPlaceholder = !isImageEdited
            reloadEditable()
        }
        
        get {
            return imageView.image!
        }
    }
    private var productTitle: String {
        set {
            titleTextField.text = newValue
            reloadEditable()
        }
        
        get {
            return titleTextField.text!
        }
    }
    private var productDescription: String {
        set {
            descriptionTextView.text = newValue
            reloadEditable()
        }
        
        get {
            return descriptionTextView.text
        }
    }
    private var productTags: [String]!
    private var productLink: String? {
        set {
            if newValue == nil {
                linkLabel.text = K.UIConstant.noLinkProvided
            } else {
                linkLabel.text = newValue
            }
            reloadEditable()
        }
        
        get {
            if linkLabel.text == K.UIConstant.noLinkProvided || linkLabel.text?.removeLeadingAndTrailingSpaces == "" || linkLabel.text == nil {
                return nil
            } else {
                return linkLabel.text
            }
        }
    }
    var defaultValues: [String:Any] = [:]
    var isImageEdited: Bool {
        guard let defaultImage = defaultValues[UserDefaults.imageKey] as? UIImage else {return false}
        return defaultImage != productImage
    }
    var isTitleEdited: Bool {
        guard let defaultTitle = defaultValues[UserDefaults.titleKey] as? String else {return false}
        return defaultTitle != productTitle
    }
    var isDescriptionEdited: Bool {
        guard let defaultDescription = defaultValues[UserDefaults.descriptionKey] as? String else {return false}
        return defaultDescription != productDescription
    }
    var isTagsEdited: Bool {
        guard let defaultTags = defaultValues[UserDefaults.tagsKey] as? [String] else {return false}
        return defaultTags != productTags
    }
    var isLinkEdited: Bool {
        let defaultLink = defaultValues[UserDefaults.URLKey] as? String
        return defaultLink != productLink
    }
    var isProductEdited: Bool {
        return isImageEdited || isTitleEdited || isDescriptionEdited || isTagsEdited || isLinkEdited
    }
    private var navGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(navigateTo(_:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.roundFactor = 15
        imageView.cornerMask = UIView.bottomCornerMask
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPhotoAction(_:))))
        titleTextField.isBordered = true
        titleTextField.roundFactor = 5
        descriptionTextView.roundFactor = 20
        horizontalTagsCollectionView.register()
        tagsStackView.addGestureRecognizer(navGesture)
        linkStackView.addGestureRecognizer(navGesture)
        setUpDefaultValues()
        deleteButton.setTitle("\(K.UIConstant.delete) \(productTitle)", for: .normal)
        deleteButton.titleLabel?.numberOfLines = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /// Assign the variables to the default values.
    private func setUpDefaultValues() {
        productImage = defaultValues[UserDefaults.imageKey] as! UIImage
        productTitle = defaultValues[UserDefaults.titleKey] as! String
        productDescription = defaultValues[UserDefaults.descriptionKey] as! String
        productTags = (defaultValues[UserDefaults.tagsKey] as! [String])
        productLink = defaultValues[UserDefaults.URLKey] as? String
    }
        
    private func reloadEditable() {
        saveButton.isEnabled = isProductEdited
    }
    
    @objc func editPhotoAction(_ gesture: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: K.UIConstant.addPhoto, message: K.UIConstant.addPhotoMessage, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: K.UIConstant.photoLibrary, style: .default) { (action) in
            let albumVC = K.Controller.albumController
            albumVC.isUserEditingProduct = true
            albumVC.imageViewDelegate = self
            self.present(albumVC, animated: true)
        }
        let cameraAction = UIAlertAction(title: K.UIConstant.camera, style: .default) { (action) in
            let newProductVC = K.Controller.newProductController
            newProductVC.isUserEditingProduct = true
            newProductVC.imageViewDelegate = self
            self.present(newProductVC, animated: true)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(UIAlertAction.cancel)
        
        alertController.pruneNegativeWidthConstraints()
        self.present(alertController, animated: true)
    }
    
    @objc func navigateTo(_ gesture: UITapGestureRecognizer) {
        guard let v =  gesture.view else {return}
        
        func goToCravyWebVC() {
            let cravyWebVC = CravyWebKitController(URLString: productLink)
            cravyWebVC.delegate = self
            self.navigationController?.pushViewController(cravyWebVC, animated: true)
        }
        
        if v.tag == 3 {
            self.performSegue(withIdentifier: K.Identifier.Segue.editProductToEditTags, sender: self)
        } else if v.tag == 4 {
            if productLink == nil {
                goToCravyWebVC()
            } else {
                let alertControler = UIAlertController(title: nil, message: productLink, preferredStyle: .actionSheet)
                let editLinkAction = UIAlertAction(title: K.UIConstant.addNewLink, style: .default) { (action) in
                    goToCravyWebVC()
                }
                let deleteLinkAction = UIAlertAction(title: K.UIConstant.deleteLink, style: .destructive) { (action) in
                    self.productLink = nil
                }
                alertControler.addAction(editLinkAction)
                alertControler.addAction(deleteLinkAction)
                alertControler.addAction(UIAlertAction.cancel)
                
                alertControler.pruneNegativeWidthConstraints()
                self.present(alertControler, animated: true)
            }
        }
    }
    
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        //TODO
    }
    
    @IBAction func deleteProduct(_ sender: UIButton) {
        //TODO
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.editProductToEditTags {
            let editTagsVC = segue.destination as! EditTagsController
            editTagsVC.tags = productTags
            editTagsVC.backgroundImage = productImage
            editTagsVC.delegate = self
        }
    }
}

//MARK:- ImageViewController Delegate
extension EditProductController: ImageViewControllerDelegate {
    func didConfirmImage(_ image: UIImage) {
        productImage = image
    }
}

//MARK:- UITextField Delegate
extension EditProductController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.removeLeadingAndTrailingSpaces != "" else {return}
        productTitle = text.removeLeadingAndTrailingSpaces
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- UITextView Delegate
extension EditProductController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.removeLeadingAndTrailingSpaces != "" {
            productDescription = textView.text.removeLeadingAndTrailingSpaces
        }
    }
}

//MARK:- TagsCollectionViewController Delegate
extension EditProductController: TagsCollectionViewControllerDelegate {
    func didUpdateTags(tags: [String]) {
        productTags = tags
        reloadEditable()
        horizontalTagsCollectionView.reloadData()
    }
}

//MARK:- UICollectionView DataSource
extension EditProductController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.tagCell, for: indexPath) as! TagCollectionCell
        cell.setTagCollectionCell(tag: productTags[indexPath.item])
        cell.tagLabel.font = UIFont.medium.small
        
        return cell
    }
}

//MARK:- UICollectionView DelegateFlowLayout
extension EditProductController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
}

//MARK:- CravyWebViewController Delegate
extension EditProductController: CravyWebViewControllerDelegate {
    func didCommitLink(URL: URL) {
        productLink = URL.absoluteString
    }
}
