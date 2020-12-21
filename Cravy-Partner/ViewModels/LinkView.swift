//
//  LinkView.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A custom view that portrays a link to the related website.
class LinkView: UIView {
    /// The button that is triggered when the user taps in this view
    private var linkButton = RoundButton()
    private var linkLabel = UILabel()
    private var linkImageView = UIImageView(image: UIImage(named: "go"))
    private var LINK_IMAGEVIEW_SIZE: CGFloat {
        return self.frame.height * 0.78
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = K.Color.link
        setLinkView()
        setLinkButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLinkView()
        setLinkButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        linkImageView.sizeAnchorOf(width: LINK_IMAGEVIEW_SIZE, height: LINK_IMAGEVIEW_SIZE)
        self.makeRounded()
        self.setShadow()
    }
    
    private func setLinkView() {
        linkLabel.text = K.UIConstant.visit
        linkLabel.adjustsFontSizeToFitWidth = true
        linkLabel.font = UIFont.demiBold.medium
        linkLabel.textAlignment = .left
        linkLabel.textColor = K.Color.light
        
        linkImageView.contentMode = .scaleAspectFit
        linkImageView.tintColor = K.Color.light
        linkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let hStackView = UIStackView(arrangedSubviews: [linkLabel, linkImageView])
        hStackView.set(axis: .horizontal, alignment: .center, spacing: 3)
        self.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.centerXYAnchor(to: self)
    }
    
    private func setLinkButton() {
        linkButton.backgroundColor = .clear
        self.addSubview(linkButton)
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        linkButton.VHConstraint(to: self)
    }
}
