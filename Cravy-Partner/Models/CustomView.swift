//
//  RoundView.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class RoundView: UIView {
    private var roundFactor: CGFloat?
    
    init(frame: CGRect = .zero, roundFactor: CGFloat? = nil) {
        self.roundFactor = roundFactor
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let factor = roundFactor {
            self.makeRounded(roundFactor: factor)
        } else {
            self.makeRounded()
        }
    }
}

/// Displays a rounded image view and a label.
class FloaterView: RoundView {
    private var button = RoundButton()
    private var floaterStackView: UIStackView!
    var imageView = RoundImageView(frame: .zero)
    var titleLabel = UILabel()
    
    init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.backgroundColor = K.Color.primary
        setFloaterStackView()
        setButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.widthAnchor(to: floaterStackView, multiplier: 1.1)
        self.heightAnchor(to: floaterStackView, multiplier: 1.2)
    }
    
    private func setFloaterStackView() {
        setImageView()
        setTitleLabel()
        floaterStackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        floaterStackView.set(axis: .horizontal, alignment: .center ,distribution: .fill, spacing: 8)
        self.addSubview(floaterStackView)
        floaterStackView.translatesAutoresizingMaskIntoConstraints = false
        floaterStackView.centerYAnchor(to: self)
        floaterStackView.centerYAnchor(to: self)
    }
    
    private func setImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = K.Color.light
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor(of: 30)
        imageView.widthAnchor(of: 30)
    }
    
    private func setTitleLabel() {
        titleLabel.font = UIFont.demiBold.small
        titleLabel.textColor = K.Color.light
    }
    
    private func setButton() {
        button.backgroundColor = .clear
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.VHConstraint(to: self)
    }
}
