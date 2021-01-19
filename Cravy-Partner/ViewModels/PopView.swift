//
//  PopView.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A view that holds a vertical stack view which displays two labels, a textfield and a button.
class PopView: RoundView, UITextFieldDelegate {
    private var popStackView: UIStackView!
    private var titleLabel = UILabel()
    private var detailLabel = UILabel()
    private var textField: RoundTextField?
    var actionButton = RoundButton()
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
    var popTintColor: UIColor? {
        set {
            actionButton.backgroundColor = newValue
        }
        
        get {
            return actionButton.backgroundColor
        }
    }
    var beginResponder: Bool {
        set {
            textField?.becomeFirstResponder()
        }
        
        get {
            return textField?.isFirstResponder ?? false
        }
    }
    
    init(title: String?, detail: String, actionTitle: String = K.UIConstant.confirm.uppercased()) {
        super.init(frame: .zero, roundFactor: 10)
        self.title = title
        self.detail = detail
        self.actionTitle = actionTitle
        setPopStackView()
        actionButton.castShadow = true
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
        popStackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel, setActionButton()])
        popStackView.set(axis: .vertical, alignment: .fill, distribution: .equalSpacing, spacing: 8)
        
        self.addSubview(popStackView)
        popStackView.translatesAutoresizingMaskIntoConstraints = false
        popStackView.centerYAnchor(to: self)
        popStackView.HConstraint(to: self, constant: 3)
    }
    
    private func setTitleLabel() {
        titleLabel.font = UIFont.bold.medium
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.textColor = K.Color.primary
    }
    
    private func setDetailLabel() {
        detailLabel.font = UIFont.medium.small
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.textColor = K.Color.dark.withAlphaComponent(0.5)
    }
    
    func addTextField(textFieldHandler: (UITextField)->()) {
        textField = RoundTextField(roundFactor: 5, placeholder: nil)
        textField!.textAlignment = .center
        textField!.backgroundColor = K.Color.secondary
        textField!.delegate = self
        textField!.translatesAutoresizingMaskIntoConstraints = false
        textField!.heightAnchor(of: 40)
        
        popStackView.insertArrangedSubview(textField!, at: 2)
        textField!.becomeFirstResponder()
        
        textFieldHandler(textField!)
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
    
    //MARK:- UITextfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

/// Displays a pop view specifically for enabling a user to promote a product.
class PromoView: PopView {
    init(toPromote product: String) {
        super.init(title: "\(K.UIConstant.promote) \(product)", detail: K.UIConstant.promotionMessage, actionTitle: K.UIConstant.promote.uppercased())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Displays a pop view specifically for enabling the user to post a product.
class PostView: PopView {
    init(toPost product: String) {
        super.init(title: "\(K.UIConstant.post) \(product)", detail: K.UIConstant.postMessage, actionTitle: K.UIConstant.post.uppercased())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
