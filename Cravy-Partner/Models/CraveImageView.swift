//
//  CraveImageView.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A custom view that displays an imageview and extra views at the bottom such a an imagview for the cravings icon and a label showing the number of cravings.
class CraveImageView: UIView {
    private var imageView: RoundImageView
    private var cravingsImageView = RoundImageView(image: UIImage(named: "cravings"))
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
    
    /// - Parameters:
    ///   - height: The height of the view, default height is 250 which is recommended as the minimum height.
    init(height: CGFloat = 250, image: UIImage? = nil, cravings: Int? = nil) {
        imageView = RoundImageView(roundfactor: 10, image: image)
        self.height = height
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
        cravingsImageView.backgroundColor = K.Color.light
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
}
