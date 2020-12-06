//
//  BusinessView.swift
//  Cravy-Partner
//
//  Created by Cravy on 06/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A custom class that displays business information.
class BusinessView: UIView {
    private var businessStackView = UIStackView()
    private var businessImageView = RoundImageView(image: nil, roundfactor: 5)
    private var businessInfoStackView = UIStackView()
    private var nameLabel = UILabel()
    private var emailLabel = UILabel()
    private var linkView = LinkView()
    /// The company logo or any image that represents the business.
    var image: UIImage? {
        set {
            businessImageView.image = newValue
        }
        
        get {
            return businessImageView.image
        }
    }
    /// The name of the business/company
    var name: String? {
        set {
            nameLabel.text = newValue
        }
        
        get {
            return nameLabel.text
        }
    }
    /// The company/business email
    var email: String? {
        set {
            emailLabel.text = newValue
        }
        
        get {
            return emailLabel.text
        }
    }
    
    init(frame: CGRect = .zero, image: UIImage? = nil, name: String? = nil, email: String? = nil) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setBusinessStackView()
        setBusinessImageView()
        setBusinessInfoStackView()
        self.image = image
        self.name = name
        self.email = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightAnchor(of: 100)
    }
    
    private func setBusinessStackView() {
        businessStackView.set(axis: .horizontal, spacing: 8)
        self.addSubview(businessStackView)
        businessStackView.translatesAutoresizingMaskIntoConstraints = false
        businessStackView.VHConstraint(to: self)
    }
    
    private func setBusinessImageView() {
        businessImageView.contentMode = .scaleAspectFill
        businessImageView.translatesAutoresizingMaskIntoConstraints = false
        businessImageView.heightAnchor(of: 100)
        businessImageView.widthAnchor(of: 100)
        businessStackView.addArrangedSubview(businessImageView)
    }
    
    private func setBusinessInfoStackView() {
        businessInfoStackView.set(axis: .vertical, alignment: .leading, spacing: 8)
        setNameLabel()
        setEmailLabel()
        setLinkView()
        businessStackView.addArrangedSubview(businessInfoStackView)
    }
    
    private func setNameLabel() {
        nameLabel.font = UIFont.medium.small
        nameLabel.textColor = K.Color.dark
        businessInfoStackView.addArrangedSubview(nameLabel)
    }
    
    private func setEmailLabel() {
        emailLabel.font = UIFont.italic.small
        emailLabel.textColor = K.Color.dark
        businessInfoStackView.addArrangedSubview(emailLabel)
    }
    
    private func setLinkView() {
        businessInfoStackView.addArrangedSubview(linkView)
    }
}

/// A custom class that displays business stat information.
class BusinessStatView: UIView {
    private var businessStatStackView = UIStackView()
    private var statStackView: UIStackView {
        let statLabel = UILabel()
        statLabel.font = UIFont.bold.small
        statLabel.textAlignment = .center
        statLabel.textColor = K.Color.dark
        
        let descLabel = UILabel()
        descLabel.font = UIFont.regular.small
        descLabel.textAlignment = .center
        descLabel.textColor = K.Color.dark.withAlphaComponent(0.5)
        
        let vStackView = UIStackView(arrangedSubviews: [statLabel, descLabel])
        vStackView.set(axis: .vertical, spacing: 0)
        
        return vStackView
    }
    private var recommendationStatLabel: UILabel {
        let statStackView = self.subviews[0] as! UIStackView
        let recommendationStatStackView = statStackView.arrangedSubviews[0] as! UIStackView
        
        return recommendationStatStackView.arrangedSubviews[0] as! UILabel
    }
    private var subscriberStatLabel: UILabel {
        let statStackView = self.subviews[0] as! UIStackView
        let subscriberStatStackView = statStackView.arrangedSubviews[1] as! UIStackView
        
        return subscriberStatStackView.arrangedSubviews[0] as! UILabel
    }
    var recommendations: Int {
        set {
            recommendationStatLabel.text = "\(newValue)"
        }
        
        get {
            return Int(recommendationStatLabel.text!)!
        }
    }
    var subscribers: Int {
        set {
            subscriberStatLabel.text = "\(newValue)"
        }
        
        get {
            return Int(subscriberStatLabel.text!)!
        }
    }
    
    init(frame: CGRect = .zero, recommendations: Int = 0, subscribers: Int = 0) {
        super.init(frame: frame)
        setBusinessStatStackView()
        setRecommendationStatStackView()
        setSubscriberStatStackView()
        self.recommendations = recommendations
        self.subscribers = subscribers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightAnchor(of: 45)
    }
    
    private func setBusinessStatStackView() {
        businessStatStackView.set(axis: .horizontal, distribution: .fillEqually)
        self.addSubview(businessStatStackView)
        businessStatStackView.translatesAutoresizingMaskIntoConstraints = false
        businessStatStackView.VHConstraint(to: self)
    }
    
    private func setRecommendationStatStackView() {
        let stackView = statStackView
        stackView.tag = 1
        let descLabel = stackView.arrangedSubviews[1] as! UILabel
        descLabel.text = K.UIConstant.recommendations
        businessStatStackView.addArrangedSubview(stackView)
    }
    
    private func setSubscriberStatStackView() {
        let stackView = statStackView
        stackView.tag = 2
        let descLabel = stackView.arrangedSubviews[1] as! UILabel
        descLabel.text = K.UIConstant.subscribers
        businessStatStackView.addArrangedSubview(stackView)
    }
}
