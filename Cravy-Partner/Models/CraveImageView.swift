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
    /// The expected maximum height of the view
    private let EXPECTED_MAX_HEIGHT:CGFloat = 350
    
    /// The expected minimum height of the view
    private let EXPECTED_MIN_HEIGHT: CGFloat = 230
    private var height: CGFloat
    /// The height and width value of the cravings image view which displays the cravings icon
    private var cravingsImageViewSize: CGFloat {
        if height <= EXPECTED_MAX_HEIGHT {
            return 0.1 * EXPECTED_MIN_HEIGHT
        } else {
            return 0.1 * EXPECTED_MAX_HEIGHT
        }
    }
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
    /// A boolean that determines whether the link view should be hidden
    var isInteractableHidden: Bool {
        set {
            linkView?.isHidden = !newValue
            postButton?.isHidden = !newValue
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
    ///   - height: The height of the view, default height is 250 which is recommended as the minimum height.
    ///   - interactable: Determines which type of view to set as the interactable. defaulat is the LinkView.
    init(height: CGFloat = 230, image: UIImage? = nil, cravings: Int? = nil, interactable: INTERACTABLE = .link) {
        self.height = height
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightAnchor(of: height)
    }
    
    private func setCraveImageView() {
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor(to: self)
        imageView.heightAnchor(to: self, multiplier: 0.87)
        imageView.HConstraint(to: self)
    }
    
    private func setCravingsImageView() {
        cravingsImageView.contentMode = .scaleAspectFit
        cravingsImageView.backgroundColor = K.Color.secondary
        cravingsImageView.translatesAutoresizingMaskIntoConstraints = false
        cravingsImageView.heightAnchor(of: cravingsImageViewSize)
        cravingsImageView.widthAnchor(of: cravingsImageViewSize)
    }
    
    private func setCravingsLabel() {
        let fontDescriptor = UIFont.demiBold
        if height <= EXPECTED_MIN_HEIGHT {
            cravingsLabel.font = fontDescriptor.xSmall
        } else {
            cravingsLabel.font = fontDescriptor.small
        }
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
        vStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(cravingsImageViewSize/2)).isActive = true
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
        linkView!.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(linkView!.height/2)).isActive = true
        linkView!.leadingAnchor(to: self, constant: 8)
        linkView!.setNeedsLayout()
    }
    
    private func setPostButton() {
        postButton = RoundButton()
        postButton!.setTitle(K.UIConstant.post, for: .normal)
        postButton!.titleLabel?.font = UIFont.demiBold.small
        postButton!.setTitleColor(K.Color.light, for: .normal)
        postButton!.backgroundColor = K.Color.primary
        self.addSubview(postButton!)
        let postButtonSize = CGSize(width: 80, height: 30)
        postButton!.translatesAutoresizingMaskIntoConstraints = false
        postButton!.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(postButtonSize.height/2)).isActive = true
        postButton!.heightAnchor(of: postButtonSize.height)
        postButton!.leadingAnchor(to: self, constant: 8)
        postButton!.widthAnchor(of: postButtonSize.width)
    }
}
