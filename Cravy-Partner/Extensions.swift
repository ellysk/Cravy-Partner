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
import NotificationBannerSwift
import FirebaseAuth

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
    var emptyView: EmptyView? {
        return self.subviews.first { (subview) -> Bool in
            return subview.tag == K.ViewTag.EMPTY_VIEW
        } as? EmptyView
    }
    var isEmptyView: Bool {
        set {
            emptyView?.isHidden = !newValue
            if newValue {
                if emptyView == nil {
                    let ev = Bundle.main.loadNibNamed(K.Identifier.NibName.emptyView, owner: nil, options: nil)?.first as! EmptyView
                    ev.tag = K.ViewTag.EMPTY_VIEW
                    ev.createButton.castShadow = true
                    self.addSubview(ev)
                    ev.translatesAutoresizingMaskIntoConstraints = false
                    ev.VHConstraint(to: self)
                }
            }
        }
        
        get {
            if let emptyView = emptyView {
                return !emptyView.isHidden
            } else {
                return false
            }
        }
    }
    static var bottomCornerMask: CACornerMask {
        return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    /// Gives the view rounded corners
    /// - Parameter roundFactor: The factor which determines how curved the view's corner will be. The lower the factor the mroe the curved the view's corners will be. The default value is 2 which makes the corners form a full curve.
    func makeRounded(roundFactor: CGFloat = 2, cornerMask: CACornerMask? = nil) {
        self.layer.cornerRadius = self.frame.height / roundFactor
        self.clipsToBounds = true
        if let mask = cornerMask {
            self.layer.maskedCorners = mask
        }
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
        sectionLabel.adjustsFontSizeToFitWidth = true
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
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        self.layer.add(animation, forKey: "shake")
    }
    
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.initialVelocity = 0.5
        pulse.damping = 5.0
        self.layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.5
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        self.layer.add(flash, forKey: nil)
    }
    
    func startLoadingAnimation() {
        self.isSkeletonable = true
        self.showAnimatedSkeleton(usingColor: K.Color.light, animation: nil, transition: .none)
    }
    
    func stopLoadingAnimation() {
        self.hideSkeleton()
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
    private var showsFloaterView: Bool {
        set {
            floaterView?.isHidden = !newValue
            
            if newValue {
                if floaterView == nil {
                    let fv = FloaterView(resizesToSubview: true)
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
    /// A button responsible for navogating to a previous view.
    var backButton: RoundButton? {
        return self.view.subviews.first { (subview) -> Bool in
            return subview.tag == K.ViewTag.BACK_BUTTON
        } as? RoundButton
    }
    /// Determines if the view should display a button responsible for navogating to a previous view.
    var showsBackButton: Bool {
        set {
            backButton?.isHidden = !newValue
            
            if newValue {
                if backButton == nil {
                    let bb = RoundButton()
                    bb.addTarget(self, action: #selector(goBack), for: .touchUpInside)
                    bb.setBackgroundImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
                    bb.tag = K.ViewTag.BACK_BUTTON
                    bb.tintColor = K.Color.light
                    self.view.addSubview(bb)
                    bb.translatesAutoresizingMaskIntoConstraints = false
                    bb.topAnchor(to: self.view.safeAreaLayoutGuide, constant: 8)
                    bb.leadingAnchor(to: self.view, constant: 8)
                    bb.sizeAnchorOf(width: 30, height: 30)
                }
            }
        }
        
        get {
            if let backButton = backButton {
                return !backButton.isHidden
            } else {
                return false
            }
        }
    }
    var dismissButton: RoundButton? {
        return self.view.subviews.first { (subview) -> Bool in
            return subview.tag == K.ViewTag.BACK_BUTTON
        } as? RoundButton
    }
    var showsDismissButton: Bool {
        set {
            dismissButton?.isHidden = !newValue
            
            if newValue {
                if dismissButton == nil {
                    let db = RoundButton()
                    db.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
                    db.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                    db.tag = K.ViewTag.DISMISS_BUTTON
                    db.castShadow = true
                    db.tintColor = K.Color.light
                    db.backgroundColor = K.Color.primary
                    self.view.addSubview(db)
                    db.translatesAutoresizingMaskIntoConstraints = false
                    db.bottomAnchor(to: self.view.safeAreaLayoutGuide, constant: 8)
                    db.leadingAnchor(to: self.view, constant: 8)
                    db.sizeAnchorOf(width: 30, height: 30)
                }
            }
        }
        
        get {
            if let dismissButton = dismissButton {
                return !dismissButton.isHidden
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
    
    /// Initialises the CravyWebKitController for display.
    /// - Parameters:
    ///   - isVisiting: Determines the state of the CravyWebKitController, if user is visiting then there is no action to add link.
    ///   - link: The first content for the web to load, if not provided then CravyWebKitController uses the default base url.
    func openCravyWebKit(link: String?, alertTitle: String = K.UIConstant.noLinkMessage, completion: @escaping (CravyWebKitViewController)->()) {
        func goToCravyWebVC(link: String?) {
            let cravyWebVC = CravyWebKitViewController(URLString: link)
            completion(cravyWebVC)
        }
        if let link = link {
            goToCravyWebVC(link: link)
        } else {
            let alertController = UIAlertController(title: K.UIConstant.oops, message: alertTitle, preferredStyle: .alert)
            let addLinkAction = UIAlertAction(title: K.UIConstant.addLink, style: .default) { (action) in
                goToCravyWebVC(link: nil)
            }
            alertController.addAction(addLinkAction)
            alertController.addAction(UIAlertAction.cancel)
            present(alertController, animated: true)
        }
    }
    
    /// Presents an action sheet that asks the user to add photo either by opening up the camera or the photo library.
    func presentEditPhotoAlert(in responder: ImageViewControllerDelegate, message: String) {
        let alertController = UIAlertController(title: K.UIConstant.addPhoto, message: message, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: K.UIConstant.photoLibrary, style: .default) { (action) in
            let albumVC = K.Controller.albumController
            albumVC.isUserEditingProduct = true
            albumVC.imageViewDelegate = responder
            self.present(albumVC, animated: true)
        }
        let cameraAction = UIAlertAction(title: K.UIConstant.camera, style: .default) { (action) in
            let newProductVC = K.Controller.newProductController
            newProductVC.isUserEditingProduct = true
            newProductVC.imageViewDelegate = responder
            self.present(newProductVC, animated: true)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(UIAlertAction.cancel)
        
        alertController.pruneNegativeWidthConstraints()
        self.present(alertController, animated: true)
    }
    
    func showStatusBarNotification(title: String, style: BannerStyle) {
        let banner = StatusBarNotificationBanner(title: title, style: style)
        banner.show()
    }
    
    func showFloaterBarNotification(title: String, subtitle: String, completion: (FloatingNotificationBanner)->()) {
        let floatingBanner = FloatingNotificationBanner(title: title, subtitle: subtitle, titleFont: UIFont.demiBold.medium, titleColor: nil, titleTextAlign: nil, subtitleFont: UIFont.regular.small, subtitleColor: nil, subtitleTextAlign: nil
            , leftView: nil, rightView: nil, style: .success, colors: nil, iconPosition: .top)
        floatingBanner.show(queuePosition: .front, bannerPosition: .top, queue: .default, on: nil, edgeInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3), cornerRadius: 10, shadowColor: K.Color.dark, shadowOpacity: 0.7, shadowBlurRadius: UIScreen.main.bounds.width / 2, shadowCornerRadius: 10, shadowOffset: .zero, shadowEdgeInsets: nil)
        floatingBanner.autoDismiss = false
        floatingBanner.dismissOnSwipeUp = true
        completion(floatingBanner)
    }
    
    /// Saves the image provided to a Cravy Partner Album.
    func saveImageToCravyPartnerAlbum(_ image: UIImage) {
        /// Add image asset to the album.
        func saveImage(_ album: PHAssetCollection) {
            album.addImage(image) { (completed, error) in
                DispatchQueue.main.async {
                    if let _ = error {
                        self.showStatusBarNotification(title: K.UIConstant.savePhotoFailTitle, style: .danger)
                    } else if completed {
                        //TODO
                        self.showStatusBarNotification(title: K.UIConstant.savePhotoSuccessTitle, style: .success)
                    }
                }
            }
        }
        
        if let album = PHFetchOptions().cravyPartnerAlbum  {
            saveImage(album)
        } else {
            //Create Cravy Partner album
            let photoLibrary = PHPhotoLibrary.shared()
            photoLibrary.createAssetCollectionWithTitle(title: K.UIConstant.albumTitle) { (completed, error) in
                if let _ = error {
                    DispatchQueue.main.async {
                        self.showStatusBarNotification(title: K.UIConstant.savePhotoFailTitle, style: .danger)
                    }
                } else if completed {
                    guard let album = PHFetchOptions().cravyPartnerAlbum else {return}
                    saveImage(album)
                }
            }
        }
    }
    
    func startLoader(for task: @escaping (LoaderViewController)->()) {
        let loaderVC = LoaderViewController()
        self.present(loaderVC, animated: true) {
            task(loaderVC)
        }
    }
    
    @objc internal func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc internal func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc internal func dismissView() {
        self.dismiss(animated: true)
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
        layout.set(direction: .horizontal, estimatedItemSize: CGSize(width: 80, height: 20), sectionInset: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        return layout
    }
    
    static var verticalTagCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.set(direction: .vertical, estimatedItemSize: CGSize(width: 100, height: 30), sectionInset: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
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
    
    static var albumCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.set(direction: .vertical, minimumLineSpacing: 1, minimumInterimSpacing: 1, sectionInset: UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1))
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
        let layoutSize = layout.widthVisibleFor(numberOfItems: 3)
        layout.itemSize = CGSize(width: layoutSize, height: layoutSize)
        
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
        let spacing = (self.scrollDirection == .vertical ? self.minimumInteritemSpacing : self.minimumLineSpacing) * (numberOfItems - 1)
        let width = (UIScreen.main.bounds.width - (spacing + self.sectionInset.left + self.sectionInset.right)) / numberOfItems
        
        return width
    }
}

//MARK: - UIImage
extension UIImage {
    func withInset(_ insets: UIEdgeInsets, tintColor: UIColor = K.Color.light) -> UIImage? {
        let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
                            height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)

        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
        self.draw(at: origin)

        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode).withTintColor(tintColor)
    }
}

extension Data {
    enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }

    func size(in type: DataUnits)-> Double {
        var size: Double = 0.0
        switch type {
        case .byte:
            size = Double(self.count)
        case .kilobyte:
            size = Double(self.count) / 1024
        case .megabyte:
            size = Double(self.count) / 1024 / 1024
        case .gigabyte:
            size = Double(self.count) / 1024 / 1024 / 1024
        }

        return size
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
    var blurrView: UIVisualEffectView? {
        return self.subviews.first { (subview) -> Bool in
            subview.tag == K.ViewTag.BLURR_VIEW
        } as? UIVisualEffectView
    }
    var isBlurr: Bool {
        set {
            blurrView?.isHidden = !isBlurr
            if newValue {
                let blurEfffect = UIBlurEffect(style: .dark)
                let blurredEffectView = UIVisualEffectView(effect: blurEfffect)
                blurredEffectView.tag = K.ViewTag.BLURR_VIEW
                blurredEffectView.frame = self.bounds
                
                self.insertSubview(blurredEffectView, at: 0)
            }
        }
        
        get {
            if let view = blurrView {
                return !view.isHidden
            } else {
                return false
            }
        }
    }
    var showsPlaceholder: Bool {
        set {
            placeholderView?.isHidden = !newValue
            
            if newValue {
                if placeholderView == nil {
                    let pv = UIView()
                    pv.tag = K.ViewTag.PLACEHOLDER_VIEW
                    pv.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    pv.clipsToBounds = true
                    let placeholderImage = UIImageView(image: UIImage(systemName: "camera.circle.fill"))
                    placeholderImage.tintColor = K.Color.light
                    pv.addSubview(placeholderImage)
                    placeholderImage.translatesAutoresizingMaskIntoConstraints = false
                    placeholderImage.centerXYAnchor(to: pv)
                    placeholderImage.sizeAnchorOf(width: 50, height: 50)
                    self.addSubview(pv)
                    pv.translatesAutoresizingMaskIntoConstraints = false
                    pv.VHConstraint(to: self)
                }
            }
        }
        
        get {
            return placeholderView != nil && !placeholderView!.isHidden
        }
    }
    var placeholderView: UIView? {
        return self.subviews.first { (subview) -> Bool in
            return subview.tag == K.ViewTag.PLACEHOLDER_VIEW
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
    
    static func takeProductOffMarket(actionHandler: @escaping ()->()) -> UIAlertController {
        let alertController  = UIAlertController(title: K.UIConstant.takeProductOffMarket, message: K.UIConstant.takeProductOffMarketMessage, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: K.UIConstant.takeItOff, style: .destructive, handler: { (action) in
            actionHandler()
        }))
        alertController.addAction(UIAlertAction.cancel)
        alertController.pruneNegativeWidthConstraints()
        return alertController
    }
    
    static func internetConnectionAlert(actionHandler: (()->())?) -> UIAlertController {
        let alertController  = UIAlertController(title: K.UIConstant.oops, message: K.UIConstant.internetConnectionAlertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: K.UIConstant.retry, style: .default, handler: { (action) in
            actionHandler?()
        }))
        alertController.addAction(UIAlertAction.cancel)
        return alertController
    }
    
    static func errorAlert(message: String) -> UIAlertController {
        let alertController  = UIAlertController(title: K.UIConstant.oops, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: K.UIConstant.OK, style: .cancel))
        return alertController
    }
}

//MARK: - UIAlertAction
extension UIAlertAction {
    static var cancel: UIAlertAction {
        return UIAlertAction(title: K.UIConstant.cancel, style: .cancel)
    }
    static var no: UIAlertAction {
        return UIAlertAction(title: K.UIConstant.no, style: .default)
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

//MARK: - UIColor
extension UIColor {
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
    }
}

//MARK: - UIBarButtonItem
extension UIBarButtonItem {
    static var flexibleSpace: UIBarButtonItem {
        // Flexible Space
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        return flexibleSpace
    }
    
    static func fixedSpace(_ width: CGFloat) -> UIBarButtonItem {
        // Fixed Space
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = width
        
        return fixedSpace
    }
}


/* -------------- PHOTOKIT EXTENSIONS -------------- */

//MARK: - PHFetchOptions
extension PHFetchOptions {
    /// An asset collection under the name of the application.
    var cravyPartnerAlbum: PHAssetCollection? {
        return self.fetchAssetCollectionWithTitle(title: K.UIConstant.albumTitle).firstObject
    }
    /// A result of assets in Cravy Partner Album.
    var cravyPartnerAssets: PHFetchResult<PHAsset> {
        guard let assetCollection = self.cravyPartnerAlbum else {fatalError("Cravy Partner Album not created!")}
        let assets = assetCollection.fetchAssets()
        
        return assets
    }
    /// Returns all the photos in the user's library that are available.
    var allPhotos: PHFetchResult<PHAsset> {
        self.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        return PHAsset.fetchAssets(with: .image, options: self)
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
    func fetchAssets(with options: PHFetchOptions? = nil) -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(in: self, options: options)
    }
    
    /// Adds the specified image into this asset collection.
    func addImage(_ image: UIImage, completionHandler: @escaping (Bool, Error?)->()) {
        PHPhotoLibrary.shared().performChanges({
            //asset change request
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self)
            let enumeration: NSArray = [assetPlaceHolder!]
            
            if self.estimatedAssetCount == 0 {
                albumChangeRequest?.addAssets(enumeration)
            } else {
                albumChangeRequest?.insertAssets(enumeration, at: [0])
            }
            
        }) { (completed, error) in
            completionHandler(completed, error)
        }
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

//MARK: - PHFetchResult
extension PHFetchResult where ObjectType == PHAsset {
    /// Returns a dictionary of a key containing the created date of the asset and a value containing the array of assets created on that date. Also returns an array of all keys.
    func splitByCreationDate(completionHandler: ([String : [PHAsset]], [String])->()) {
        var dict: [String : [PHAsset]] = [:]
        var keys: [String] = []
        
        for i in 0...self.count - 1 {
            guard let creationDate = self[i].creationDate?.shortFormat else {continue}
            
            if dict[creationDate] == nil {
                keys.append(creationDate)
                dict[creationDate] = [self[i]]
            } else {
                var updatedAssets = dict[creationDate]!
                updatedAssets.append(self[i])
                dict.updateValue(updatedAssets, forKey: creationDate)
            }
        }
        
        let sortedKeys = keys.sortBy(formatter: DateFormatter.shortDateFormatter)
        
        completionHandler(dict, sortedKeys)
    }
}

//MARK: - PHAsset
extension PHAsset {
    /// Gets the image from the asset and assigns it to the image with the size and content mode provided.
    func fetchImage(targetSize size: CGSize = PHImageManagerMaximumSize, contentMode: PHImageContentMode = .aspectFill, completionHandler: @escaping (UIImage?, [AnyHashable : Any]?)->()) {
        var imageRequestOptions: PHImageRequestOptions?
        imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions!.deliveryMode = size == PHImageManagerMaximumSize ? .highQualityFormat : .opportunistic
        imageRequestOptions!.resizeMode = size == PHImageManagerMaximumSize ? .none : .exact
        
        PHImageManager.default().requestImage(for: self, targetSize: size, contentMode: contentMode, options: imageRequestOptions) { (requestedImage, info) in
            completionHandler(requestedImage, info)
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

extension Array where Element == String {
  /// Sorts the elements which represent a date of a specific format from latest to oldest. The formatter should match the format of the strings in the array
  /// - Parameter formatter: The format in which the date is represented.
  func sortBy(formatter: DateFormatter) -> [String] {
    return self.sorted(by: { formatter.date(from: $0)! > formatter.date(from: $1)! })
  }
}

//MARK: - String
extension String {
    var deleteFormat: String {
        return "\(self) has been deleted"
    }
    var editFormat: String {
        return "\(self) has been edited"
    }
    var isValidEmail: Bool {
        return K.Predicate.emailPredicate.evaluate(with: self)
    }
    var removeLeadingAndTrailingSpaces: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var zeroSpaced: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func withFont(font: UIFont) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
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

//MARK: - Int64
extension Int64 {
    static let MAX_IMAGE_SIZE: Int64 = 10*1024*1024
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

//MARK: - Date
extension Date {
    /// Returns a string obtained from a date parsed through a shortDateFormatter.
    var shortFormat: String {
      return DateFormatter.shortDateFormatter.string(from: self)
  }
}

//MARK: - DateFormatter
extension DateFormatter {
    /// returns an  "MMMM yyyy" format. eg: August 2020, September 2020 etc.
  static var shortDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    
    return formatter
  }
}

//MARK:- URLError.code
extension URLError.Code {
    var title: String {
        switch self {
        case .timedOut:
            return "Poor network connection"
        case .notConnectedToInternet:
            return "No internet connection"
        case .unknown:
            return "Oops!"
        case .appTransportSecurityRequiresSecureConnection:
            return "Not secure"
        default:
            return "Oops!"
        }
    }
    var description: String {
        switch self {
        case .timedOut:
            return "Your connection timed out. Make sure you have a good internet connection and try again."
        case .notConnectedToInternet:
            return "The Internet connection appears to be offline. Make sure you have turned off your airplane mode or your mobile data is on."
        case .unknown:
            return "Please check your internet connection"
        case .appTransportSecurityRequiresSecureConnection:
            return "Sorry we can not allow you to access this web page as it is not secure."
        default:
            return "Please check your internet connection"
        }
    }
}

/* -------------- COCOAPODS EXTENSIONS -------------- */

//MARK: - AnimationView
extension AnimationView {
    static var focusAnimation: AnimationView {
        return AnimationView(name: "focus")
    }
    static var ingredientsAnimation: AnimationView {
        return AnimationView(name: "ingredients")
    }
    static var promoteAnimation: AnimationView {
        return AnimationView(name: "promote")
    }
    static var postAnimation: AnimationView {
        return AnimationView(name: "post")
    }
    static var inactiveAnimation: AnimationView {
        return AnimationView(name: "inactive")
    }
    static var comingSoonAnimation: AnimationView {
        return AnimationView(name: "comingsoon")
    }
    static var loaderAnimation: AnimationView {
        return AnimationView(name: "loader")
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

//MARK: - AuthErrorCode
extension AuthErrorCode {
    var description: String {
        switch self {
        case .invalidEmail:
            return "The email you entered is invalid."
        case .missingEmail:
            return "Please provde your email."
        case .invalidUserToken:
            return "Sorry, we have to log you out at the moment. Try and sign in again."
        case .networkError:
            return "Something went wrong, please check your internet connection."
        case .userNotFound:
            return "The email or password provided is incorrect!"
        case .wrongPassword:
            return "The password you entered is incorrect!"
        default:
            return AuthErrorCode.networkError.description
        }
    }
}
