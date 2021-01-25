//
//  RoundView.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

//MARK:- Round View
class RoundView: UIView {
    var roundFactor: CGFloat?
    var isBordered: Bool = false
    /// A boolean that determines if the view should have a shadow layer.
    var castShadow: Bool = false
    
    init(frame: CGRect = .zero, roundFactor: CGFloat? = nil) {
        self.roundFactor = roundFactor
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let factor = roundFactor {
            self.makeRounded(roundFactor: factor)
        } else {
            self.makeRounded()
        }
        if isBordered {
            self.makeBordered()
        }
        if castShadow {
            self.setShadow()
        }
    }
}

protocol FloaterViewDelegate {
    /// Use this to get the floater view in which the user has interacted with.
    func didTapFloaterButton(_ floaterView: FloaterView)
}

//MARK:- Floater View
/// Displays a rounded image view and a label.
class FloaterView: RoundView {
    private var button = RoundButton()
    private var floaterStackView: UIStackView!
    var imageView = RoundImageView(frame: .zero)
    var titleLabel = UILabel()
    /// Adjust the width and height of the view depending on the size of the subviews.
    private var resizesToSubview: Bool = false
    var image: UIImage? {
        set {
            imageView.image = newValue
        }
        
        get {
            return imageView.image
        }
    }
    var title: String? {
        set {
            titleLabel.text = newValue
        }
        
        get {
            return titleLabel.text
        }
    }
    var delegate: FloaterViewDelegate?
    
    init(resizesToSubview: Bool = false) {
        super.init(frame: .zero)
        self.resizesToSubview = resizesToSubview
        self.backgroundColor = K.Color.primary
        setFloaterStackView()
        setButton()
        self.sendSubviewToBack(floaterStackView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        resizesToSubview = true
        setFloaterStackView()
        setButton()
        self.sendSubviewToBack(floaterStackView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setShadow()
    }
    
    private func setFloaterStackView() {
        setImageView()
        setTitleLabel()
        floaterStackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        floaterStackView.set(axis: .horizontal, alignment: .center ,distribution: .fill, spacing: 8)
        self.addSubview(floaterStackView)
        floaterStackView.translatesAutoresizingMaskIntoConstraints = false
        if resizesToSubview {
            resizeToSubview()
        } else {
            floaterStackView.HConstraint(to: self, constant: 5)
            floaterStackView.centerYAnchor(to: self)
        }
    }
    
    private func setImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = K.Color.light
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.sizeAnchorOf(width: 30, height: 30)
    }
    
    private func setTitleLabel() {
        titleLabel.font = UIFont.demiBold.small
        titleLabel.textAlignment = .center
        titleLabel.textColor = K.Color.light
    }
    
    private func setButton() {
        button.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
        button.backgroundColor = .clear
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.VHConstraint(to: self)
    }
    
    private func resizeToSubview() {
        floaterStackView.centerXYAnchor(to: self)
        self.widthAnchor(to: floaterStackView, multiplier: 1.2)
        self.heightAnchor(of: 40)
    }
    
    @objc func tap(_ sender: RoundButton) {
        self.pulse()
        self.delegate?.didTapFloaterButton(self)
    }
}

//MARK:- Curtain View
/// A view with a gradient background and shadow at the bottom.
class CurtainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setCravyGradientBackground()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setCravyGradientBackground()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBottomShadow()
    }
    
    private func setBottomShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = K.Color.primary.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

//MARK:- Gallery View
/// Displays a collection of image views in different layouts.
class GalleryView: UIView {
    var gallery: [RoundImageView] {
        return []
    }
    var images: [UIImage] {
        set {
            for i in 0..<gallery.count {
                if i < newValue.count {
                    //assign availabel images
                    gallery[i].image = newValue[i]
                }
                gallery[i].tag = i
                gallery[i].roundFactor = 15
                gallery[i].isUserInteractionEnabled = true
                gallery[i].isHidden = i >= newValue.count
            }
            reloadVisible()
        }
        
        get {
            var imageArray: [UIImage] = []
            gallery.forEach { (imageView) in
                if let image = imageView.image, !imageView.isHidden {
                    imageArray.append(image)
                }
            }
            return imageArray
        }
    }
    
    /// This method is called when images are set to the image views. use it to update visibillity of image views.
    internal func reloadVisible() {}
}
