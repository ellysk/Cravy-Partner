//
//  CraveImageView.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

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
    private var linkView = LinkView()
    /// The button in the link view
    var linkButton: RoundButton {
        return linkView.linkButton
    }
    /// The expected maximum height of the view
    private let EXPECTED_MAX_HEIGHT:CGFloat = 350
    
    /// The expected minimum height of the view
    private let EXPECTED_MIN_HEIGHT: CGFloat = 250
    private var height: CGFloat
    /// The height and width value of the cravings image view which displays the cravings icon
    private var cravingsImageViewSize: CGFloat {
        if height <= EXPECTED_MAX_HEIGHT {
            return 0.1 * height
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
    var showsLink: Bool {
        set {
            linkView.isHidden = !newValue
        }
        
        get {
            return linkView.isHidden
        }
    }
    
    /// - Parameters:
    ///   - height: The height of the view, default height is 250 which is recommended as the minimum height.
    init(height: CGFloat = 250, image: UIImage? = nil, cravings: Int? = nil) {
        self.height = height
        self.imageView = RoundImageView(image: image, roundfactor: 10)
        super.init(frame: .zero)
        self.cravings = cravings
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightAnchor(of: height)
        setCraveImageView()
        setLinkView()
        setCravingsView()
    }
    
    private func setCraveImageView() {
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor(to: self)
        imageView.heightAnchor(to: self, multiplier: 0.8)
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
    
    private func setLinkView() {
        self.addSubview(linkView)
        linkView.translatesAutoresizingMaskIntoConstraints = false
        linkView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(linkView.height/2)).isActive = true
        linkView.leadingAnchor(to: self, constant: 8)
        linkView.setNeedsLayout()
    }
}
