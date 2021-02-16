//
//  EditProductController.swift
//  Cravy-Partner
//
//  Created by Cravy on 18/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import PromiseKit
import FirebaseFunctions

/// Handles the display and editing of the product's information
class EditProductController: UIViewController {
    var saveItem: UIBarButtonItem {
        return navigationItem.rightBarButtonItem!
    }
    let productEditView: ProductEditView = Bundle.main.loadNibNamed(K.Identifier.NibName.productEditView, owner: nil, options: nil)?.first as! ProductEditView
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
    private var productImage: UIImage {
        set {
            imageView.image = newValue
            imageView.showsPlaceholder = !isImageEdited
            if isImageEdited {
                updateData.updateValue(newValue, forKey: K.Key.image)
            } else {
                updateData.removeValue(forKey: K.Key.image)
            }
            reloadEditable()
        }
        
        get {
            return imageView.image!
        }
    }
    private var productTitle: String {
        set {
            titleTextField.text = newValue
            editedProduct.title = newValue
            if isTitleEdited {
                updateData.updateValue(newValue, forKey: K.Key.title)
            } else {
                updateData.removeValue(forKey: K.Key.title)
            }
            reloadEditable()
        }
        
        get {
            return titleTextField.text!
        }
    }
    private var productDescription: String {
        set {
            descriptionTextView.text = newValue
            editedProduct.description = newValue
            if isDescriptionEdited {
                updateData.updateValue(newValue, forKey: K.Key.description)
            } else {
                updateData.removeValue(forKey: K.Key.description)
            }
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
            if let link = newValue {
                editedProduct.productLink = URL(string: link)
            }
            if isLinkEdited {
                updateData.updateValue(newValue, forKey: K.Key.url)
            } else {
                updateData.removeValue(forKey: K.Key.url)
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
    var defaultProduct: Product!
    private var editedProduct: Product!
    private var updateData: [String : Any?] = [:]
    var isImageEdited: Bool = false
    var isTitleEdited: Bool {
        return  defaultProduct.title != editedProduct.title
    }
    var isDescriptionEdited: Bool {
        return defaultProduct.description != editedProduct.description
    }
    var isTagsEdited: Bool {
        return defaultProduct.tags != editedProduct.tags
    }
    var isLinkEdited: Bool {
        let defaultLink = defaultProduct.productLink?.absoluteString
        return defaultLink != editedProduct.productLink?.absoluteString
    }
    var isProductEdited: Bool {
        return isImageEdited || isTitleEdited || isDescriptionEdited || isTagsEdited || isLinkEdited
    }
    private var navGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(navigateTo(_:)))
    }
    private var productFB: ProductFirebase!
    var delegate: ProductDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productFB = ProductFirebase()
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
        editedProduct = defaultProduct
        productImage = UIImage(data: defaultProduct.image)!
        
        productTitle = defaultProduct.title
        productDescription = defaultProduct.description
        productTags = defaultProduct.tags
        productLink = defaultProduct.productLink?.absoluteString
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
        func save() {
            self.startLoader { (loaderVC) in
                firstly {
                    self.productFB.updateProduct(id: self.editedProduct.id, update: self.updateData, imageURL: self.editedProduct.imageURL)
                }.done(on: .main) { (results) in
                    let (_, data) = results
                    if let imageData = data {
                        self.editedProduct.image = imageData
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.didEditProduct(self.editedProduct)
                    self.showStatusBarNotification(title: self.productTitle.editFormat, style: .success)
                }.ensure(on: .main, {
                    loaderVC.stopLoader()
                }).catch(on: .main) { (error) in
                    print(error.localizedDescription)
                    self.present(UIAlertController.internetConnectionAlert(actionHandler: save), animated: true)
                }
            }
        }
        save()
    }
    
    @objc func deleteProduct(_ sender: UIButton) {
        //TODO
        let alertController = UIAlertController(title: defaultProduct.title, message: K.UIConstant.deleteProductMessage, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: K.UIConstant.delete, style: .destructive) { (action) in
            let loaderVC = LoaderViewController()
            self.present(loaderVC, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    loaderVC.stopLoader {
                        guard let nav = self.navigationController else {return}
                        for viewController in nav.viewControllers {
                            if let cravyTabBarController = viewController as? CravyTabBarController {
                                print(nav.viewControllers.firstIndex(of: viewController)!)
                                nav.popToViewController(cravyTabBarController, animated: true)
                            }
                        }
                        self.showStatusBarNotification(title: self.defaultProduct.title.deleteFormat, style: .danger)
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
        isImageEdited = true
        productImage = image
    }
}

//MARK:- UITextField Delegate
extension EditProductController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.removeLeadingAndTrailingSpaces != "" {
            productTitle = text.removeLeadingAndTrailingSpaces
        } else {
            productTitle = defaultProduct.title
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
            productDescription = defaultProduct.description
        }
    }
}

//MARK:- TagsCollectionViewController Delegate
extension EditProductController: TagsInputDelegate {
    func didUpdateTags(tags: [String]) {
        productTags = tags
        editedProduct.tags = tags
        updateData.updateValue(tags, forKey: K.Key.tags)
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
        cell.isSeparatorHidden = indexPath.item == productTags.count - 1
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
