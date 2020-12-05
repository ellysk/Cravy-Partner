//
//  Extensions.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

//MARK: - UI Extensions



//MARK: - UIFont
extension UIFont {
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
    
    /// Gives the view rounded corners
    /// - Parameter roundFactor: The factor which determines how curved the view's corner will be. The lower the factor the mroe the curved the view's corners will be. The default value is 2 which makes the corners form a full curve.
    func makeRounded(roundFactor: CGFloat = 2) {
        self.layer.cornerRadius = self.frame.height / roundFactor
        self.clipsToBounds = true
    }
    
    /// Gives the view a border of width 1 and primary color
    func makeBordered() {
        self.layer.borderWidth = 1
        self.layer.borderColor = K.Color.primary.cgColor
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
    /// A button displayed at the bottom-right of the view.
    var floaterButton: RoundButton? {
        return self.view.subviews.first { (subview) -> Bool in
            return subview.tag == K.ViewTag.FLOATER_BUTTON
        } as? RoundButton
    }
    var showsFloaterButton: Bool {
        set {
            floaterButton?.isHidden = !newValue
            
            if newValue {
                if floaterButton == nil {
                    let btn = RoundButton()
                    btn.tag = K.ViewTag.FLOATER_BUTTON
                    btn.backgroundColor = K.Color.primary
                    self.view.addSubview(btn)
                    btn.translatesAutoresizingMaskIntoConstraints = false
                    btn.bottomAnchor(to: self.view, constant: 8)
                    btn.heightAnchor(of: 50)
                    btn.trailingAnchor(to: self.view, constant: 8)
                    btn.widthAnchor(of: 50)
                }
            }
        }
        
        get {
            if let floater = floaterButton {
                return !floater.isHidden
            } else {
                return false
            }
        }
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
    static var tagCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 60, height: 20)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 8
        layout.sectionInset.left = 8
        
        return layout
    }
    
    static var craveCollectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        let itemWidth = (UIScreen.main.bounds.width - (layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right)) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 340)
        
        return layout
    }
    
    /// Returns a layout that displays a single item column that can be scrolled through horizontally
    /// - Parameter height: The height of the item.
    static func singleItemHorizontalFlowLayoutWith(height: CGFloat) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        return flowLayout
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
    /// Returns a button containing an ellipsis image with a tint color of dark
    static var optionsButton: UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = K.Color.dark
        
        return btn
    }
    
    /// Sets the background image specifically designed for the size ratio of a floater button that is displayed in a view controller.
    func setFloaterButtonBackgroundImage(image: UIImage?) {
        self.setBackgroundImage(image?.withInset(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))?.withTintColor(K.Color.light), for: .normal)
    }
}


//MARK: - Foundation Extensions



