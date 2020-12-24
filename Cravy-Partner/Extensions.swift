//
//  Extensions.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Lottie
import SwiftyCam
import Photos
/* -------------- UIKIT EXTENSIONS -------------- */

//MARK: - UIFont
extension UIFont {
    enum SIZE {
        case xsmall
        case small
        case medium
        case large
    }
    
    /// Returns an AvenirNext-Medium font style
    static var medium: UIFontDescriptor {
        return addAtrributeName(name: "AvenirNext-Medium")
    }
    
    /// Returns an AvenirNext-Bold font style
    static var bold: UIFontDescriptor {
        return addAtrributeName(name: "AvenirNext-Bold")
    }
    
    /// Returns an AvenirNext-DemiBold font style
    static var demiBold: UIFontDescriptor {
        return addAtrributeName(name: "AvenirNext-DemiBold")
    }
    
    /// Returns an AvenirNext-Regular font style
    static var regular: UIFontDescriptor {
        return addAtrributeName(name: "AvenirNext-Regular")
    }
    
    /// Returns an AvenirNext-Italic font style
    static var italic: UIFontDescriptor {
        return addAtrributeName(name: "AvenirNext-Italic")
    }
    
    /// Returns an AvenirNext-MediumItalic font style
    static var mediumItalic: UIFontDescriptor {
        return addAtrributeName(name: "AvenirNext-MediumItalic")
    }
    
    /// Returns an AvenirNext-Heavy font style
    static var heavy: UIFontDescriptor {
        return addAtrributeName(name: "AvenirNext-Heavy")
    }
    
    private static func addAtrributeName(name: String) -> UIFontDescriptor{
        return UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.name : name])
    }
}

//MARK: - UIFontDescriptor
extension UIFontDescriptor {
    /// Returns a font with a size of 32
    var large: UIFont {
        return UIFont(descriptor: self, size: 32)
    }
    
    /// Returns a font with a size of 24
    var medium: UIFont {
        return UIFont(descriptor: self, size: 24)
    }
    
    /// Returns a font with a size of 16
    var small: UIFont {
        return UIFont(descriptor: self, size: 16)
    }
    
    /// Returns a font with a size of 12
    var xSmall: UIFont {
        return UIFont(descriptor: self, size: 12)
    }
}

//MARK: - UILabel
extension UILabel {
    /// Underline the text displayed by the label. This method is nil safe.
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}


//MARK: - UIView
extension UIView {
    /// A boolean that determines if the view's background is clear.
    var isTransparent: Bool {
        set {
            if newValue {
                self.backgroundColor = .clear
            }
        }
        
        get {
            return self.backgroundColor == .clear
        }
    }
    /// Gives the view rounded corners
    /// - Parameter roundFactor: The factor which determines how curved the view's corner will be. The lower the factor the mroe the curved the view's corners will be. The default value is 2 which makes the corners form a full curve.
    func makeRounded(roundFactor: CGFloat = 2) {
        self.layer.cornerRadius = self.frame.height / roundFactor
        self.clipsToBounds = true
    }
    
    func removeRounded() {
        self.layer.cornerRadius = self.frame.height
        self.clipsToBounds = false
    }
    
    /// Gives the view a border of width 1 and primary color
    func makeBordered() {
        self.layer.borderWidth = 1
        self.layer.borderColor = K.Color.primary.cgColor
    }
    
    func removeBordered() {
        self.layer.borderWidth = 0
    }
    
    func topAnchor(to view: UIView, constant: CGFloat = 0) {
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
    }
    
    func topAnchor(to layoutGuide: UILayoutGuide, constant: CGFloat = 0) {
        self.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: constant).isActive = true
    }
    
    func bottomAnchor(to view: UIView, constant: CGFloat = 0) {
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).isActive = true
    }
    
    func bottomAnchor(to layoutGuide: UILayoutGuide, constant: CGFloat = 0) {
        self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -constant).isActive = true
    }
    
    func leadingAnchor(to view: UIView, constant: CGFloat = 0) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
    }
    
    func trailingAnchor(to view: UIView, constant: CGFloat = 0) {
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
    }
    
    /// Add top and bottom constraint
    func VConstraint(to view: UIView, constant: CGFloat = 0) {
        topAnchor(to: view, constant: constant)
        bottomAnchor(to: view, constant: constant)
    }
    
    /// Add leading and trailing constraint
    func HConstraint(to view: UIView, constant: CGFloat = 0) {
        leadingAnchor(to: view, constant: constant)
        trailingAnchor(to: view, constant: constant)
    }
    
    
    /// Add all anchor constraints (top, bottom, leading and trailing)
    func VHConstraint(to view: UIView, VConstant: CGFloat = 0, HConstant: CGFloat = 0) {
        VConstraint(to: view, constant: VConstant)
        HConstraint(to: view, constant: HConstant)
    }
    
    
    /// Anchor the view in the center vertically
    func centerYAnchor(to view: UIView) {
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    /// Anchor the view in the center horizontally
    func centerXAnchor(to view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    /// Anchor the vew in the center both horiziontally anf vertically
    func centerXYAnchor(to view: UIView) {
        centerYAnchor(to: view)
        centerXAnchor(to: view)
    }
    
    func heightAnchor(of size: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    func heightAnchor(to view: UIView, multiplier: CGFloat = 1) {
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
    }
    
    func widthAnchor(of size: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    func widthAnchor(to view: UIView, multiplier: CGFloat = 1) {
        self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
    }
    
    /// Sets constraints of the width and height of the view.
    func sizeAnchorOf(width: CGFloat, height: CGFloat) {
        self.widthAnchor(of: width)
        self.heightAnchor(of: height)
    }
    
    /// Adds a title on top of the view and returns the stack view that holds both the label and the view.
    func withSectionTitle(_ title: String, titleFont: UIFont = UIFont.medium.small, titleColor: UIColor = K.Color.dark.withAlphaComponent(0.5), alignment: UIStackView.Alignment = .fill) -> UIStackView {
        let sectionLabel = UILabel()
        sectionLabel.text = title
        sectionLabel.font = titleFont
        sectionLabel.textAlignment = .left
        sectionLabel.textColor = titleColor
        
        let vStackView = UIStackView(arrangedSubviews: [sectionLabel, self])
        vStackView.set(axis: .vertical, alignment: alignment ,distribution: .fill, spacing: 8)
        
        return vStackView
    }
    
    /// Sets the background color of the view to be a gradient color of the colors provided.
    func setGradientBackgroundWith(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setCravyGradientBackground() {
        setGradientBackgroundWith(colors: [K.Color.secondary.cgColor, K.Color.light.cgColor])
    }
    
    /// Add shadow in the view's layer
    func setShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = K.Color.dark.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
}


//MARK: - UIViewController
extension UIViewController {
    var cravySearchBar: CravySearchBar? {
        return self.view.subviews.first { (subview) -> Bool in
            return subview.tag == K.ViewTag.CRAVY_SEARCH_BAR
        } as? CravySearchBar
    }
    
    /// Displays a searchbar in this view controller.
    var showsCravySearchBar: Bool {
        set {
            cravySearchBar?.isHidden = !newValue
            
            if newValue {
                if cravySearchBar == nil {
                    let CSB = CravySearchBar()
                    
                    self.view.addSubview(CSB)
                    CSB.translatesAutoresizingMaskIntoConstraints = false
                    CSB.topAnchor(to: self.view.safeAreaLayoutGuide)
                    CSB.centerXAnchor(to: self.view)
                    CSB.HConstraint(to: self.view, constant: 8)
                }
            }
        }
        
        get {
            if let searchBar = cravySearchBar {
                return !searchBar.isHidden
            } else {
                return false
            }
        }
    }
    /// A view displayed at the bottom-right of the view controller.
    var floaterView: FloaterView? {
        return self.view.subviews.first { (subview) -> Bool in
            return subview.tag == K.ViewTag.FLOATER_VIEW
        } as? FloaterView
    }
    /// Initiliazes and displays a floater view.
    var showsFloaterView: Bool {
        set {
            floaterView?.isHidden = !newValue
            
            if newValue {
                if floaterView == nil {
                    let fv = FloaterView()
                    fv.tag = K.ViewTag.FLOATER_VIEW
                    self.view.addSubview(fv)
                    fv.translatesAutoresizingMaskIntoConstraints = false
                    fv.bottomAnchor(to: self.view.safeAreaLayoutGuide, constant: 3)
                    fv.trailingAnchor(to: self.view, constant: 3)
                }
            }
        }
        
        get {
            if let floater = floaterView {
                return !floater.isHidden
            } else {
                return false
            }
        }
    }
    
    /// Displays a floater view with the provided image and title.
    func setFloaterViewWith(image: UIImage, title: String) {
        self.showsFloaterView = true
        self.floaterView?.imageView.image = image
        self.floaterView?.titleLabel.text = title
    }
}

//MARK: - UIStackView
extension UIStackView {
    func set(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 8) {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}

//MARK: - UICollectionViewFlowLayout
extension UICollectionViewFlowLayout {
    static var horizontalTagCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.set(direction: .horizontal, estimatedItemSize: CGSize(width: 80, height: 20), sectionInset: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        return layout
    }
    
    static var verticalTagCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.set(direction: .vertical, estimatedItemSize: CGSize(width: 100, height: 30))
        
        return layout
    }
    
    static var verticalCraveCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.set(direction: .vertical, itemSize: CGSize(width: layout.widthVisibleFor(numberOfItems: 2), height: 340), minimumInterimSpacing: 3, sectionInset: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
       
        return layout
    }
    
    static var horizontalCraveCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.set(direction: .horizontal, itemSize: CGSize(width: layout.widthVisibleFor(numberOfItems: 1.8), height: 240), minimumLineSpacing: 3)
        
        return layout
    }
    
    /// Returns a layout that displays a single item column that can be scrolled through horizontally
    /// - Parameter height: The height of the item.
    static func singleItemHorizontalFlowLayoutWith(estimatedSize: CGSize? = nil, size: CGSize = UICollectionViewFlowLayout.automaticSize) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.set(direction: .horizontal, estimatedItemSize: estimatedSize, itemSize: size, sectionInset: .zero)
        
        return layout
    }
    
    static var imageCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.set(direction: .horizontal)
        let itemWidth = layout.widthVisibleFor(numberOfItems: 1.5)
        layout.itemSize = CGSize(width: itemWidth, height: 0.5 * itemWidth)
        
        return layout
    }
    
    static var widgetCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.set(direction: .horizontal, minimumLineSpacing: 3, sectionInset: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        layout.itemSize = CGSize(width: layout.widthVisibleFor(numberOfItems: 2), height: 120)
        
        return layout
    }
    
    /// Sets the main properties of a UICollectionViewFlowLayout
    func set(direction: UICollectionView.ScrollDirection, estimatedItemSize: CGSize? = nil, itemSize: CGSize = UICollectionViewFlowLayout.automaticSize, minimumLineSpacing: CGFloat = 8, minimumInterimSpacing: CGFloat = 8, sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)) {
        self.scrollDirection = direction
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInterimSpacing
        self.sectionInset = sectionInset
        if let size = estimatedItemSize {
            self.estimatedItemSize = size
        }
        self.itemSize = itemSize
    }
    
    /// - Calculates the width of a single item in the layout depending on the number of visible items provided. To get desired results, set all needed layout properties before setting the size of the layout item.
    /// - Returns: Width of item that will fit the number of visible items provided in the screen.
    func widthVisibleFor(numberOfItems: CGFloat) -> CGFloat {
        let spacing = self.scrollDirection == .vertical ? self.minimumInteritemSpacing : self.minimumLineSpacing
        let width = (UIScreen.main.bounds.width - (spacing + self.sectionInset.left + self.sectionInset.right)) / numberOfItems
        
        return width
    }
}

//MARK: - UIImage
extension UIImage {
    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
                            height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)

        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
        self.draw(at: origin)

        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
    }
}

//MARK: - UIButton
extension UIButton {
    /// Returns a button that represents an action of logging out.
    static var logOutButton: UIButton {
        let logOutButton = UIButton()
        logOutButton.setImage(UIImage(named: "logout"), for: .normal)
        
        return logOutButton
    }
    /// Returns a button containing an ellipsis image with a tint color of dark
    static var optionsButton: UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = K.Color.dark
        
        return btn
    }
}

//MARK: - UITableView
extension UITableView {
    /// Returns a view for a section inside a table view.
    /// - Parameter title: The text that will appear on the label inside the view.
    func sectionWithTitle(_ title: String) -> UIView {
        let section = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: 0)))
        section.backgroundColor = K.Color.light
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = UIFont.demiBold.small
        sectionTitle.textAlignment = .left
        sectionTitle.textColor = K.Color.dark.withAlphaComponent(0.5)
        section.addSubview(sectionTitle)
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        sectionTitle.bottomAnchor(to: section, constant: 3)
        sectionTitle.HConstraint(to: section, constant: 8)
        
        return section
    }
    
    /// Returns a view for a section inside a table view registered with ToggleTableCell
    /// - Parameter title: The text that will appear on the label inside the view.
    func sectionWithToggle(title: String) -> UIView {
        let section = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: 0)))
        section.backgroundColor = K.Color.light
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = UIFont.medium.medium
        sectionTitle.textAlignment = .left
        sectionTitle.adjustsFontSizeToFitWidth = true
        sectionTitle.textColor = K.Color.dark
        
        section.addSubview(sectionTitle)
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        sectionTitle.bottomAnchor(to: section, constant: 3)
        sectionTitle.HConstraint(to: section, constant: 16)
        
        return section
    }
}

//MARK: - UIImageView
extension UIImageView {
    /// Returns a view that contains the the image view.
    func withPlaceholderView(placeholderBackgroundColor: UIColor = K.Color.dark) -> UIView {
        self.alpha = 0.5
        
        let roundImageView = self as? RoundImageView
        let bgView = RoundView(frame: self.frame, roundFactor: roundImageView?.roundFactor)
        bgView.isBordered = true
        bgView.backgroundColor = placeholderBackgroundColor
        bgView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.VHConstraint(to: bgView)
        
        let placeholder = UIImageView(image: UIImage(systemName: "camera.circle.fill"))
        placeholder.tintColor = K.Color.light
        bgView.addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.centerXYAnchor(to: bgView)
        placeholder.heightAnchor(of: 50)
        placeholder.widthAnchor(of: 50)
        
        return bgView
    }
    
    /// Gets the image from the asset and assigns it to the image with the size and content mode provided.
    func fetchImageAsset(_ asset: PHAsset?, targetSize size: CGSize, contentMode: PHImageContentMode = .aspectFill, options: PHImageRequestOptions? = nil, completionHandler: ((Bool) -> ())?) {
      guard let asset = asset else {
        completionHandler?(false)
        return
      }
      
      PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: contentMode, options: options) { (requestedImage, info) in
        self.image = requestedImage
        completionHandler?(true)
      }
    }
}

//MARK: - UIAlertController
extension UIAlertController {
    /// An alert showing that the photo library could not be accessed.
    static var photoLibrayAccessAlert: UIAlertController {
        let alertController = UIAlertController(title: K.UIConstant.accessDenied, message: K.UIConstant.photoLibraryAccessDeniedMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.goToSettings)
        alertController.addAction(UIAlertAction.cancel)
        
        return alertController
    }
    
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

//MARK: - UIAlertAction
extension UIAlertAction {
    static var cancel: UIAlertAction {
        return UIAlertAction(title: K.UIConstant.cancel, style: .cancel)
    }
    
    /// Redirects the device to open settings.
    static var goToSettings: UIAlertAction {
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    if !success {return}
                })
            }
        }
        
        return settingsAction
    }
}


/* -------------- PHOTOKIT EXTENSIONS -------------- */

//MARK: - PHFetchOptions
extension PHFetchOptions {
    /// An asset collection under the name of the application.
    var cravyPartnerAlbum: PHAssetCollection? {
        return self.fetchAssetCollectionWithTitle(title: K.UIConstant.albumTitle).firstObject
    }
    
    /// Returns the asset collection with the specified title. If title is nil then it returns all asset collections that have been created by the user in the device
    func fetchAssetCollectionWithTitle(title: String? = nil) -> PHFetchResult<PHAssetCollection>  {
        self.predicate = title == nil ? nil : NSPredicate(format: "title = %@", "\(title!)")
        let results = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: self)
        return results
    }
}

//MARK: - PHAssetCollection
extension PHAssetCollection {
    /// Returns a result for collection of assets with the specified option.
    func fetchAssetsWith(options: PHFetchOptions? = nil) -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(in: self, options: options)
    }
}

//MARK: - PHPhotoLibrary
extension PHPhotoLibrary {
  /// Asynchronously creates a new asset collection with the specified title.
  func createAssetCollectionWithTitle(title: String, completionHander: @escaping (Bool, Error?)->()) {
    self.performChanges({
      PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
    }) { (completed, error) in
      completionHander(completed, error)
    }
  }
}

/* -------------- FOUNDATION EXTENSIONS -------------- */

//MARK: - Array
extension Array {
    /// Converts an array into an array of arrays, using whatever size you specify.
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

//MARK: - String
extension String {
    func withFont(font: UIFont) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
}

//MARK: - Int
extension Int {
    /// Changes the number to a format that represents a unit provided.
    func represent(unit: String, size: UIFont.SIZE = .xsmall) -> NSMutableAttributedString {
        var font1: UIFont!
        var font2: UIFont!
        if size == .xsmall {
            font1 = UIFont.demiBold.xSmall
            font2 = UIFont.regular.xSmall
        } else {
            font1 = UIFont.demiBold.small
            font2 = UIFont.regular.small
        }
        
        let fullText = NSMutableAttributedString()
        
        let firstString = String(self).withFont(font: font1)
        let space = NSMutableAttributedString(string: " ")
        let secondString = unit.withFont(font: font2)
        
        fullText.append(firstString)
        fullText.append(space)
        fullText.append(secondString)
        
        return fullText
    }
}

//MARK: - Double
extension Double {
    /// Changes the number to a format that represents a unit provided.
    func represent(unit: String, size: UIFont.SIZE = .xsmall) -> NSMutableAttributedString {
        var font1: UIFont!
        var font2: UIFont!
        if size == .xsmall {
            font1 = UIFont.demiBold.xSmall
            font2 = UIFont.regular.xSmall
        } else {
            font1 = UIFont.demiBold.small
            font2 = UIFont.regular.small
        }
        
        let fullText = NSMutableAttributedString()
        
        let firstString = String(self).withFont(font: font1)
        let space = NSMutableAttributedString(string: " ")
        let secondString = unit.withFont(font: font2)
        
        fullText.append(firstString)
        fullText.append(space)
        fullText.append(secondString)
        
        return fullText
    }
}

/* -------------- COCOAPODS EXTENSIONS -------------- */

//MARK: - AnimationView
extension AnimationView {
    static var focusAnimation: AnimationView {
        return AnimationView(name: "focus")
    }
    
    /// Plays the animation at the speicified position on the screen.
    func play(at position: CGPoint) {
        self.frame.origin = position
        self.play()
    }
}

//MARK: - SwiftyCamController
extension SwiftyCamViewController {
    func checkPhotoLibraryPermission(completionHandler: @escaping (Bool)->()) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            completionHandler(true)
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                completionHandler(status == .authorized)
            }
        }
    }
}
