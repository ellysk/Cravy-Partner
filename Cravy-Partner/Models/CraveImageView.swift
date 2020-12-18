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
    private var recommendationsLabel = UILabel()
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
    var recommendations: Int? {
        set {
            if let recommendations = newValue {
                recommendationsLabel.isHidden = false
                
                let fullText = NSMutableAttributedString()
                
                let firstString = String(recommendations).withFont(font: UIFont.demiBold.small)
                let space = NSMutableAttributedString(string: " ")
                let secondString = "recommendations".withFont(font: UIFont.regular.small)
                
                fullText.append(firstString)
                fullText.append(space)
                fullText.append(secondString)
                
                recommendationsLabel.attributedText = fullText
            } else {
                recommendationsLabel.isHidden = true
                recommendationsLabel.text = nil
            }
        }
        
        get {
            guard let recommendations = recommendationsLabel.text else {return nil}
            return Int(recommendations)
        }
    }
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
        setRecommendationLabel()
        self.cravings = cravings
        self.recommendations = recommendations
    }
    
    required init?(coder: NSCoder) {
        self.imageView = RoundImageView(image: UIImage(named: "bgimage"), roundfactor: 10)
        super.init(coder: coder)
        setCraveImageView()
        setInteractable(.link)
        setCravingsView()
        cravingsLabel.font = UIFont.demiBold.small
        setRecommendationLabel()
        cravingsTintColor = K.Color.light
        self.cravings = 438
        self.recommendations = 200
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
        cravingsImageView.heightAnchor(of: 30)
        cravingsImageView.widthAnchor(of: 30)
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
        vStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(cravingsImageView.frame.height/2)).isActive = true
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
    
    private func setRecommendationLabel() {
        recommendationsLabel.textAlignment = .left
        recommendationsLabel.textColor = K.Color.dark
        self.addSubview(recommendationsLabel)
        recommendationsLabel.translatesAutoresizingMaskIntoConstraints = false
        recommendationsLabel.topAnchor.constraint(equalTo: linkView?.bottomAnchor ?? imageView.bottomAnchor, constant: 8).isActive = true
        recommendationsLabel.bottomAnchor(to: self)
        recommendationsLabel.leadingAnchor(to: self, constant: 8)
    }
}
