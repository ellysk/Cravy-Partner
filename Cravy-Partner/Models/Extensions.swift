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
                    CSB.heightAnchor.constraint(equalToConstant: K.Size.CRAVY_SEARCH_BAR_HEIGHT).isActive = true
                    CSB.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
                    CSB.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    CSB.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
                    CSB.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
                }
            }
        }
        
        get {
            return cravySearchBar != nil
        }
    }
}



//MARK: - Foundation Extensions



