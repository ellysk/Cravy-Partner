//
//  CraveImageView.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

enum INTERACTABLE {
    case link
    case post
}

/// A custom view that displays an imageview and extra views at the bottom such as a linkview, an imagview for the cravings icon and a label showing the number of cravings.
class CraveImageView: UIView {
    private var imageView: RoundImageView
    private var cravingsImageView = RoundImageView(image: UIImage(named: "cravings")?.withInset(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)))
    private var cravingsLabel = UILabel()
    /// The image displayed in the imageview
    var craveImage: UIImage? {
        set {
            imageView.image = newValue
        }
        
        get {
            return imageView.image
        }
    }
    private var linkView: LinkView?
    private var postButton: RoundButton?
    var cravings: Int? {
        set {
            if let cravings = newValue {
                cravingsLabel.isHidden = false
                cravingsLabel.text = "\(cravings)"
            } else {
                cravingsLabel.isHidden = true
                cravingsLabel.text = nil
            }
        }
        
        get {
            guard let cravings = cravingsLabel.text else {return nil}
            return Int(cravings)
        }
    }
    private let interactableSize: CGSize = CGSize(width: 80, height: 30)
    private let cravingsImageViewSize: CGSize = CGSize(width: 30, height: 30)
    /// A boolean that determines whether the link view should be hidden
    var isInteractableHidden: Bool {
        set {
            linkView?.isHidden = newValue
            postButton?.isHidden = newValue
        }
        
        get {
            return linkView?.isHidden ?? postButton?.isHidden ?? false
        }
    }
    /// Changes the background color of the cravings image view, default color is secondary color.
    var cravingsTintColor: UIColor? {
        set {
            cravingsImageView.backgroundColor = newValue
        }
        
        get {
            return cravingsImageView.backgroundColor
        }
    }
    
    /// - Parameters:
    ///   - interactable: Determines which type of view to set as the interactable. defaulat is the LinkView.
    init(image: UIImage? = nil, cravings: Int? = nil, recommendations: Int? = nil, interactable: INTERACTABLE = .link) {
        self.imageView = RoundImageView(image: image, roundfactor: 10)
        super.init(frame: .zero)
        setCraveImageView()
        setInteractable(interactable)
        setCravingsView()
        self.cravings = cravings
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCraveImageView() {
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor(to: self)
        imageView.heightAnchor(to: self, multiplier: 0.85)
        imageView.HConstraint(to: self)
    }
    
    private func setCravingsImageView() {
        cravingsImageView.contentMode = .scaleAspectFit
        cravingsImageView.backgroundColor = K.Color.secondary
        cravingsImageView.translatesAutoresizingMaskIntoConstraints = false
        cravingsImageView.heightAnchor(of: cravingsImageViewSize.height)
        cravingsImageView.widthAnchor(of: cravingsImageViewSize.width)
    }
    
    private func setCravingsLabel() {
        cravingsLabel.font = UIFont.demiBold.xSmall
        cravingsLabel.textAlignment = .center
        cravingsLabel.textColor = K.Color.dark
    }
    
    /// Arranges the cravings imageview and the cravings label in a vertical stackview
    private func setCravingsView() {
        setCravingsImageView()
        setCravingsLabel()
        
        let vStackView = UIStackView(arrangedSubviews: [cravingsImageView, cravingsLabel])
        vStackView.set(axis: .vertical, alignment: .center, distribution: .fill, spacing: 3)
        self.addSubview(vStackView)
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(cravingsImageViewSize.height/2)).isActive = true
        vStackView.trailingAnchor(to: self, constant: 8)
    }
    
    /// Sets a button at the bottom-left edge of the image view.
    private func setInteractable(_ interactable: INTERACTABLE) {
        if interactable == .link {
            setLinkView()
        } else {
            setPostButton()
        }
    }
    
    private func setLinkView() {
        linkView = LinkView()
        self.addSubview(linkView!)
        linkView!.translatesAutoresizingMaskIntoConstraints = false
        linkView!.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(interactableSize.height/2)).isActive = true
        linkView!.heightAnchor(of: interactableSize.height)
        linkView!.leadingAnchor(to: self, constant: 8)
        linkView!.widthAnchor(of: interactableSize.width)
    }
    
    private func setPostButton() {
        postButton = RoundButton()
        postButton!.castShadow = true
        postButton!.setTitle(K.UIConstant.post, for: .normal)
        postButton!.titleLabel?.font = UIFont.demiBold.small
        postButton!.setTitleColor(K.Color.light, for: .normal)
        postButton!.backgroundColor = K.Color.primary
        self.addSubview(postButton!)
        postButton!.translatesAutoresizingMaskIntoConstraints = false
        postButton!.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(interactableSize.height/2)).isActive = true
        postButton!.heightAnchor(of: interactableSize.height)
        postButton!.leadingAnchor(to: self, constant: 8)
        postButton!.widthAnchor(of: interactableSize.width)
    }
}
