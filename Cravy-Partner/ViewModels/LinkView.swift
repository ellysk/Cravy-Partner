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
    private var linkLabel = UILabel()
    private var linkImageView = UIImageView(image: UIImage(named: "go"))
    private var LINK_IMAGEVIEW_SIZE: CGFloat {
        return self.frame.height * 0.78
    }
    var delegate: LinkViewDelegate?
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = K.Color.link
        setLinkView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLinkView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        linkImageView.sizeAnchorOf(width: LINK_IMAGEVIEW_SIZE, height: LINK_IMAGEVIEW_SIZE)
        self.makeRounded()
        self.setShadow()
    }
    
    private func setLinkView() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkViewTapped(_:))))
        
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
    
    @objc func linkViewTapped(_ gesture: UITapGestureRecognizer) {
        self.flash()
        self.delegate?.didTapOnLinkView(self)
    }
}
