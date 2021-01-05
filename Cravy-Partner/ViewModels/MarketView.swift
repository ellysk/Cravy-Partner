//
//  MarketView.swift
//  Cravy-Partner
//
//  Created by Cravy on 05/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Lottie

/// A custom class that displays content related to the information of whether the product is on the market or not. If product is on the market then the contents displayed include number of seach appearances, views and web visits.
class MarketView: UIView {
    private var toolStackView: UIStackView!
    private var marketLabel = UILabel()
    private var optionsButton = UIButton.optionsButton
    private var contentStackView: UIStackView?
    private let searchContentView = ContentView(contentImage: UIImage(systemName: "magnifyingglass"))
    private let viewsContentView = ContentView(contentImage: UIImage(systemName: "eye.fill"))
    private let linksContentView = ContentView(contentImage: UIImage(systemName: "link"))
    private var animationView: AnimationView?
    var state: PRODUCT_STATE {
        set {
            contentStackView?.isHidden = newValue == .inActive
            animationView?.isHidden = newValue == .active
            marketLabel.text = newValue == .active ? K.UIConstant.onTheMarket : K.UIConstant.offTheMarket
            marketLabel.textColor = newValue == .active ? K.Color.positive : K.Color.important
            if newValue == .active {
                animationView?.stop()
                setContentStackView()
            } else {
                setAnimationView()
            }
        }
        
        get {
            if contentStackView != nil && !contentStackView!.isHidden {
                return .active
            } else {
                return .inActive
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
            searchContentView.content = "\(newValue) \(K.UIConstant.searches)"
        }
        
        get {
            return searches
        }
    }
    /// The content related to number of views.
    var nuberOfViews: Int {
        set {
            viewsContentView.content = "\(newValue) \(K.UIConstant.views)"
        }
        
        get {
            return views
        }
    }
    /// The content related to number of visits.
    var numberOfVisits: Int {
        set {
            linksContentView.content = "\(newValue) \(K.UIConstant.visits)"
        }
        
        get {
            return links
        }
    }
    private var action: (()->())?
    
    init(frame: CGRect = .zero, state: PRODUCT_STATE = .inActive) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setToolStackView()
        self.state = state
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setToolStackView()
        self.state = .inActive
    }
    
    private func setToolStackView() {
        marketLabel.font = UIFont.demiBold.small
        marketLabel.textAlignment = .left
        optionsButton.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        toolStackView = UIStackView(arrangedSubviews: [marketLabel, optionsButton])
        toolStackView.set(axis: .horizontal, alignment: .center, spacing: 0)
        self.addSubview(toolStackView)
        toolStackView.translatesAutoresizingMaskIntoConstraints = false
        toolStackView.topAnchor(to: self)
        toolStackView.HConstraint(to: self, constant: 8)
    }
    
    private func setContentStackView() {
        if contentStackView == nil {
            contentStackView = UIStackView(arrangedSubviews: [searchContentView, viewsContentView, linksContentView])
            contentStackView!.set(axis: .vertical, alignment: .fill, distribution: .fillEqually)
            self.addSubview(contentStackView!)
            contentStackView!.translatesAutoresizingMaskIntoConstraints = false
            contentStackView!.topAnchor.constraint(equalTo: toolStackView.bottomAnchor, constant: 8).isActive = true
            contentStackView!.bottomAnchor(to: self)
            contentStackView!.HConstraint(to: self, constant: 8)
        }
    }
    
    private func setAnimationView() {
        if animationView == nil {
            animationView = AnimationView.inactiveAnimation
            animationView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action(_:))))
            self.addSubview(animationView!)
            animationView!.translatesAutoresizingMaskIntoConstraints = false
            animationView!.topAnchor.constraint(equalTo: toolStackView.bottomAnchor, constant: 8).isActive = true
            animationView!.bottomAnchor(to: self)
            animationView!.HConstraint(to: self, constant: 8)
            playAnimation()
        } else {
            playAnimation()
        }
    }
    
    func playAnimation() {
        guard let animation = animationView, !animation.isHidden else {return}
        if !animation.isAnimationPlaying {
            animation.play()
            animation.loopMode = .loop
        }
    }
    
    func stopAnimation() {
        animationView?.pause()
    }
    
    func addAction(_ action: (()->())?) {
        self.action = action
    }
    
    @objc func action(_ sender: Any) {
        action?()
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
