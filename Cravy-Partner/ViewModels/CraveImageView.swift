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
    private var cravingsImageView = RoundImageView(image: UIImage(named: "cravings")?.withInset(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), tintColor: K.Color.primary))
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
    /// A boolean that determines whether the view is displaying a post button or link view.
    var isInteractableHidden: Bool {
        set {
            linkView?.isHidden = newValue
            postButton?.isHidden = newValue
        }
        
        get {
            return linkView?.isHidden ?? postButton?.isHidden ?? true
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
    var interactable: INTERACTABLE? {
        if isInteractableHidden || (linkView == nil && postButton == nil) {
            return nil
        } else if linkView != nil {
            return .link
        } else {
            return .post
        }
    }
    var interaction: (()->())?
    
    /// - Parameters:
    ///   - interactable: Determines which type of view to set as the interactable. defaulat is the LinkView.
    init(image: UIImage? = nil, cravings: Int? = nil, recommendations: Int? = nil) {
        self.imageView = RoundImageView(image: image, roundfactor: 15)
        super.init(frame: .zero)
        setCraveImageView()
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
        cravingsImageView.sizeAnchorOf(width: cravingsImageViewSize.width, height:  cravingsImageViewSize.height)
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
    
    private func setLinkView() {
        if linkView == nil {
            linkView = LinkView()
            linkView!.delegate = self
            self.addSubview(linkView!)
            linkView!.translatesAutoresizingMaskIntoConstraints = false
            linkView!.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(interactableSize.height/2)).isActive = true
            linkView!.leadingAnchor(to: self, constant: 8)
            linkView!.sizeAnchorOf(width: interactableSize.width, height: interactableSize.height)
        }
    }
    
    private func setPostButton() {
        if postButton == nil {
            postButton = RoundButton()
            postButton?.addTarget(self, action: #selector(interact(_:)), for: .touchUpInside)
            postButton!.castShadow = true
            postButton!.setTitle(K.UIConstant.post.uppercased(), for: .normal)
            postButton!.titleLabel?.font = UIFont.demiBold.small
            postButton!.setTitleColor(K.Color.light, for: .normal)
            postButton!.backgroundColor = K.Color.primary
            self.addSubview(postButton!)
            postButton!.translatesAutoresizingMaskIntoConstraints = false
            postButton!.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(interactableSize.height/2)).isActive = true
            postButton!.leadingAnchor(to: self, constant: 8)
            postButton!.sizeAnchorOf(width: interactableSize.width, height: interactableSize.height)
        }
    }
    
    /// Adds a button at the bottom left of the image view that performs an action depending on the interactable provided.
    func addInteractable(_ interactable: INTERACTABLE, interactionHandler: (()->())? = nil) {
        self.interaction = interactionHandler
        switch interactable {
        case .link:
            setLinkView()
        case .post:
            setPostButton()
        }
    }
    
    @objc func interact(_ sender: UIButton) {
        sender.pulse()
        interaction?()
    }
}

//MARK: - LinkView Delegate
extension CraveImageView: LinkViewDelegate {
    func didTapOnLinkView(_ linkView: LinkView) {
        interaction?()
    }
}
