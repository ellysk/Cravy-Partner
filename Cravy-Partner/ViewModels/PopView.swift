//
//  PopView.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A view that holds a vertical stack view which displays two labels, a textfield and a button.
class PopView: RoundView {
    private var popStackView: UIStackView!
    private var titleLabel = UILabel()
    private var detailLabel = UILabel()
    private var textField = RoundTextField(roundFactor: 5, placeholder: nil)
    private var actionButton = RoundButton()
    var title: String? {
        set {
            titleLabel.text = newValue
        }
        
        get {
            return titleLabel.text
        }
    }
    var detail: String {
        set {
            detailLabel.text = newValue
        }
        
        get {
            return detailLabel.text!
        }
    }
    /// The title displayed on the action button.
    var actionTitle: String {
        set {
            actionButton.setTitle(newValue, for: .normal)
        }
        
        get {
            return actionButton.titleLabel!.text!
        }
    }
    var isTextFieldHidden: Bool {
        set {
            textField.isHidden = newValue
        }
        
        get {
            return textField.isHidden
        }
    }
    
    init(title: String?, detail: String, actionTitle: String = K.UIConstant.confirm) {
        super.init(frame: .zero, roundFactor: 10)
        self.title = title
        self.detail = detail
        self.actionTitle = actionTitle
        setPopStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightAnchor(to: popStackView, multiplier: 1.1)
    }
    
    private func setPopStackView() {
        self.backgroundColor = K.Color.light
        setTitleLabel()
        setDetailLabel()
        setTextField()
        popStackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel, textField, setActionButton()])
        popStackView.set(axis: .vertical, alignment: .fill, distribution: .equalSpacing, spacing: 8)
        
        self.addSubview(popStackView)
        popStackView.translatesAutoresizingMaskIntoConstraints = false
        popStackView.centerYAnchor(to: self)
        popStackView.HConstraint(to: self, constant: 3)
    }
    
    private func setTitleLabel() {
        titleLabel.font = UIFont.bold.medium
        titleLabel.textAlignment = .center
        titleLabel.textColor = K.Color.primary
    }
    
    private func setDetailLabel() {
        detailLabel.font = UIFont.medium.small
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.textColor = K.Color.dark.withAlphaComponent(0.5)
    }
    
    private func setTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor(of: 40)
    }
    
    private func setActionButton() -> UIView {
        actionButton.titleLabel?.font = UIFont.bold.small
        actionButton.setTitleColor(K.Color.light, for: .normal)
        actionButton.backgroundColor = K.Color.primary
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.heightAnchor(of: 45)
        containerView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.VConstraint(to: containerView)
        actionButton.centerXAnchor(to: containerView)
        actionButton.widthAnchor(of: 100)
        
        return containerView
    }
}
