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
    var linkButton = RoundButton()
    var height: CGFloat {
        return 45
    }
    var width: CGFloat {
        return 120
    }
    private let LINK_IMAGEVIEW_SIZE: CGFloat = 30
        
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightAnchor(of: height)
        self.widthAnchor(of: width)
        self.makeRounded()
        setLinkView()
        setLinkButton()
        style()
    }
    
    private func setLinkView() {
        let linkLabel = UILabel()
        linkLabel.text = K.UIConstant.visit
        linkLabel.font = UIFont.demiBold.medium
        linkLabel.textAlignment = .left
        linkLabel.textColor = K.Color.light
        
        let linkImageView = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
        linkImageView.contentMode = .scaleAspectFit
        linkImageView.tintColor = K.Color.light
        linkImageView.translatesAutoresizingMaskIntoConstraints = false
        linkImageView.heightAnchor(of: LINK_IMAGEVIEW_SIZE)
        linkImageView.widthAnchor(of: LINK_IMAGEVIEW_SIZE)
        
        let hStackView = UIStackView(arrangedSubviews: [linkLabel, linkImageView])
        hStackView.set(axis: .horizontal, alignment: .center, distribution: .fillProportionally)
        self.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.VConstraint(to: self)
        hStackView.HConstraint(to: self, constant: 8)
    }
    
    private func setLinkButton() {
        linkButton.backgroundColor = .clear
        self.addSubview(linkButton)
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        linkButton.VHConstraint(to: self)
    }
    
    private func style() {
        self.backgroundColor = K.Color.link
    }
}
