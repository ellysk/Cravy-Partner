//
//  MarketView.swift
//  Cravy-Partner
//
//  Created by Cravy on 05/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A custom class that displays content related to the information of whether the product is on the market or not. If product is on the market then the contents displayed include number of seach appearances, views and web visits.
class MarketView: UIView {
    private var marketStackView: UIStackView!
    private var marketLabel = UILabel()
    private var optionsButton = UIButton.optionsButton
    private let searchContentView = ContentView(contentImage: UIImage(systemName: "magnifyingglass"))
    private let viewsContentView = ContentView(contentImage: UIImage(systemName: "eye.fill"))
    private let linksContentView = ContentView(contentImage: UIImage(systemName: "link"))
    var marketStatus: Int {
        set {
            marketLabel.text = newValue == 0 ? K.UIConstant.offTheMarket : K.UIConstant.onTheMarket
        }
        
        get {
            if marketLabel.text == K.UIConstant.offTheMarket {
                return 0
            } else {
                return 1
            }
        }
    }
    private var searches: Int = 0
    private var views: Int = 0
    private var links: Int = 0
    /// The content related to number of searches.
    var numberOfSearches: Int {
        set {
            searches = newValue
            searchContentView.content = "\(newValue) search appearances"
        }
        
        get {
            return searches
        }
    }
    /// The content related to number of views.
    var nuberOfViews: Int {
        set {
            viewsContentView.content = "\(newValue) views"
        }
        
        get {
            return views
        }
    }
    /// The content related to number of visits.
    var numberOfVisits: Int {
        set {
            linksContentView.content = "\(newValue) visits"
        }
        
        get {
            return links
        }
    }
    
    init(frame: CGRect = .zero, marketStatus: Int = 0) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.marketStatus = marketStatus
        setMarketStackView()
        setTopView()
        setContentStackView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.marketStatus = 0
        setMarketStackView()
        setTopView()
        setContentStackView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightAnchor(to: marketStackView)
    }
    
    private func setMarketStackView() {
        marketStackView = UIStackView()
        marketStackView.set(axis: .vertical, alignment: .fill)
        self.addSubview(marketStackView)
        marketStackView.translatesAutoresizingMaskIntoConstraints = false
        marketStackView.VHConstraint(to: self, HConstant: 8)
    }
    
    private func setTopView() {
        marketLabel.font = UIFont.demiBold.small
        marketLabel.textAlignment = .left
        marketLabel.textColor = K.Color.dark.withAlphaComponent(0.5)
        
        let hStackView = UIStackView(arrangedSubviews: [marketLabel, optionsButton])
        hStackView.set(axis: .horizontal, alignment: .center, spacing: 0)
        marketStackView.addArrangedSubview(hStackView)
    }
    
    private func setContentStackView() {
        let vStackView = UIStackView(arrangedSubviews: [searchContentView, viewsContentView, linksContentView])
        vStackView.set(axis: .vertical, alignment: .fill, distribution: .fillEqually)
        marketStackView.addArrangedSubview(vStackView)
    }
}

/// A custom class that displays a horizontal stack view that contains an image view and a label.
class ContentView: RoundView {
    private var contentImageView = RoundImageView(image: nil, roundfactor: 10)
    private var contentLabel = UILabel()
    /// The image displayed to represent the content.
    var contentImage: UIImage? {
        set {
            contentImageView.image = newValue
        }
        
        get {
            return contentImageView.image
        }
    }
    var content: String? {
        set {
            contentLabel.text = newValue
        }
        
        get {
            return contentLabel.text
        }
    }
    
    init(roundFactor: CGFloat? = nil, contentImage: UIImage? = nil, contentDescription: String? = nil) {
        super.init(roundFactor: roundFactor)
        self.backgroundColor = K.Color.secondary
        setContentView()
        self.contentImage = contentImage
        self.content = contentDescription
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightAnchor(of: 50)
    }
    
    private func setContentView() {
        contentImageView.contentMode = .scaleAspectFit
        contentImageView.tintColor = K.Color.primary
        contentImageView.backgroundColor = K.Color.light
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        contentImageView.sizeAnchorOf(width: 40, height: 40)
        
        contentLabel.font = UIFont.mediumItalic.small
        contentLabel.textAlignment = .left
        contentLabel.textColor = K.Color.dark
        
        let hStackView = UIStackView(arrangedSubviews: [contentImageView, contentLabel])
        hStackView.set(axis: .horizontal, alignment: .center)
        self.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.centerYAnchor(to: self)
        hStackView.HConstraint(to: self, constant: 8)
    }
}
