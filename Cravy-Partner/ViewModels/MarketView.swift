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
    private var contentStackView: UIStackView!
    private let searchContentView = ContentView(contentImage: UIImage(systemName: "magnifyingglass"))
    private let viewsContentView = ContentView(contentImage: UIImage(systemName: "eye.fill"))
    private let linksContentView = ContentView(contentImage: UIImage(systemName: "link"))
    private var animationView: AnimationView = AnimationView.inactiveAnimation
    private let loaderAnimation = AnimationView.loaderAnimation
    var state: PRODUCT_STATE {
        set {
            marketLabel.text = newValue == .active ? K.UIConstant.onTheMarket : K.UIConstant.offTheMarket
            marketLabel.textColor = newValue == .active ? K.Color.positive : K.Color.important
        }
        
        get {
            if marketLabel.text == K.UIConstant.onTheMarket && marketLabel.textColor == K.Color.positive {
                return .active
            } else {
                return .inActive
            }
        }
    }
    private var searches: Int = 0
    private var views: Int = 0
    private var visits: Int = 0
    var statTitle: String? {
        return marketLabel.text
    }
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
            views = newValue
            viewsContentView.content = "\(newValue) \(K.UIConstant.views)"
        }
        
        get {
            return views
        }
    }
    /// The content related to number of visits.
    var numberOfVisits: Int {
        set {
            visits = newValue
            linksContentView.content = "\(newValue) \(K.UIConstant.visits)"
        }
        
        get {
            return visits
        }
    }
    private var action: (()->())?
    
    init(frame: CGRect = .zero, state: PRODUCT_STATE = .inActive) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.state = state
        setToolStackView()
        setAnimationView()
        setContentStackView()
        setLoaderAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setToolStackView()
        setAnimationView()
        setContentStackView()
        setLoaderAnimation()
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
            contentStackView.set(axis: .vertical, alignment: .fill, distribution: .fillEqually)
            self.addSubview(contentStackView)
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.topAnchor.constraint(equalTo: toolStackView.bottomAnchor, constant: 8).isActive = true
            contentStackView.bottomAnchor(to: self)
            contentStackView.HConstraint(to: self, constant: 8)
        }
    }
    
    private func setAnimationView() {
        animationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action(_:))))
        self.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: toolStackView.bottomAnchor, constant: 8).isActive = true
        animationView.bottomAnchor(to: self)
        animationView.HConstraint(to: self, constant: 8)
    }
    
    private func setLoaderAnimation() {
        self.addSubview(loaderAnimation)
        loaderAnimation.translatesAutoresizingMaskIntoConstraints = false
        loaderAnimation.centerXYAnchor(to: self)
        loaderAnimation.sizeAnchorOf(width: 50, height: 50)
    }
    
    
    /// Plays the sleeping fox animation showing that there is no activity to this product as it is off the market
    func playAnimation() {
        if !animationView.isAnimationPlaying {
            animationView.play()
            animationView.loopMode = .loop
        }
    }
    
    /// Stops any animation playing in this view
    func stopAnimation() {
        if animationView.isAnimationPlaying {
            animationView.pause()
        }
    }
    
    /// Starts to play the loading animation indicating the market view is fetching data.
    func startLoader(completion: (()->())?) {
        contentStackView.isHidden = true
        animationView.isHidden =  true
        stopAnimation()
        loaderAnimation.isHidden = false
        toolStackView.isHidden = true
        if !loaderAnimation.isAnimationPlaying {
            loaderAnimation.play()
            loaderAnimation.loopMode = .loop
        }
        completion?()
    }
    
    func stopLoader(completion: (()->())? = nil) {
        loaderAnimation.isHidden = true
        toolStackView.isHidden = false
        contentStackView.isHidden = state == .inActive
        animationView.isHidden = state == .active
        if !animationView.isHidden {
            playAnimation()
        } else {
            stopAnimation()
        }
        if loaderAnimation.isAnimationPlaying {
            loaderAnimation.stop()
        }
        completion?()
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
