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
    var saveItem: UIBarButtonItem {
        return navigationItem.rightBarButtonItem!
    }
    var imageView: RoundImageView {
        return productEditView.imageView
    }
    var titleTextField: RoundTextField {
        return productEditView.titleTextField
    }
    var descriptionTextView: RoundTextView {
        return productEditView.descriptionTextView
    }
    var horizontalTagsCollectionView: HorizontalTagsCollectionView {
        return productEditView.horizontalTagsCollectionView
    }
    var linkLabel: UILabel {
        return productEditView.linkLabel
    }
    var tagsStackView: UIStackView {
        return productEditView.tagsStackView
    }
    var linkStackView: UIStackView {
        return productEditView.linkStackView
    }
    var deleteButton: UIButton {
        return productEditView.deleteButton
    }
    let productEditView: ProductEditView = Bundle.main.loadNibNamed(K.Identifier.NibName.productEditView, owner: nil, options: nil)?.first as! ProductEditView
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
        guard let defaultImage = defaultValues[K.Key.image] as? UIImage else {return false}
        return defaultImage != productImage
    }
    var isTitleEdited: Bool {
        guard let defaultTitle = defaultValues[K.Key.title] as? String else {return false}
        return defaultTitle != productTitle
    }
    var isDescriptionEdited: Bool {
        guard let defaultDescription = defaultValues[K.Key.description] as? String else {return false}
        return defaultDescription != productDescription
    }
    var isTagsEdited: Bool {
        guard let defaultTags = defaultValues[K.Key.tags] as? [String] else {return false}
        return defaultTags != productTags
    }
    var isLinkEdited: Bool {
        let defaultLink = defaultValues[K.Key.url] as? String
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
        setUpDefaultValues()
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        additionalSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func additionalSetup() {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges(_:))), animated: true)
        saveItem.isEnabled = false
        self.view.addSubview(productEditView)
        productEditView.translatesAutoresizingMaskIntoConstraints = false
        productEditView.topAnchor(to: self.view.safeAreaLayoutGuide)
        productEditView.bottomAnchor(to: self.view)
        productEditView.HConstraint(to: self.view)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPhotoAction(_:))))
        horizontalTagsCollectionView.register()
        horizontalTagsCollectionView.dataSource = self
        horizontalTagsCollectionView.delegate = self
        tagsStackView.addGestureRecognizer(navGesture)
        linkStackView.addGestureRecognizer(navGesture)
        deleteButton.addTarget(self, action: #selector(deleteProduct(_:)), for: .touchUpInside)
        deleteButton.setTitle("\(K.UIConstant.delete) \(productTitle)", for: .normal)
        deleteButton.titleLabel?.numberOfLines = 0
    }
    
    /// Assign the variables to the default values.
    private func setUpDefaultValues() {
        productImage = defaultValues[K.Key.image] as! UIImage
        productTitle = defaultValues[K.Key.title] as! String
        productDescription = defaultValues[K.Key.description] as! String
        productTags = (defaultValues[K.Key.tags] as! [String])
        productLink = defaultValues[K.Key.url] as? String
    }
        
    private func reloadEditable() {
        saveItem.isEnabled = isProductEdited
    }
    
    @objc func editPhotoAction(_ gesture: UITapGestureRecognizer) {
        self.presentEditPhotoAlert(in: self, message: K.UIConstant.addProductPhotoMessage)
    }
    
    
    @objc func navigateTo(_ gesture: UITapGestureRecognizer) {
        guard let v =  gesture.view else {return}
        
        func goToCravyWebVC() {
            let cravyWebVC = CravyWebKitViewController(URLString: productLink)
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
    
    @objc func saveChanges(_ sender: UIBarButtonItem) {
        //TODO
        let loaderVC = LoaderViewController()
        self.present(loaderVC, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                loaderVC.stopLoader {
                    print("changes saved!")
                }
            }
        }
    }
    
    @objc func deleteProduct(_ sender: UIButton) {
        //TODO
        let alertController = UIAlertController(title: defaultValues[K.Key.title] as? String, message: K.UIConstant.deleteProductMessage, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: K.UIConstant.delete, style: .destructive) { (action) in
            let loaderVC = LoaderViewController()
            self.present(loaderVC, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    loaderVC.stopLoader {
                        print("deleted!")
                    }
                }
            }
        }
        alertController.addAction(UIAlertAction.no)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true)
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
        if let text = textField.text, text.removeLeadingAndTrailingSpaces != "" {
            productTitle = text.removeLeadingAndTrailingSpaces
        } else {
            productTitle = defaultValues[K.Key.title] as! String
        }
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
        } else {
            productDescription = defaultValues[K.Key.description] as! String
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
