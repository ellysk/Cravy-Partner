//
//  CustomTextView.swift
//  Cravy-Partner
//
//  Created by Cravy on 05/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

/// A subclass of UITextField that gives rounded corners and is bordered.
class RoundTextView: UITextView {
    override var isFirstResponder: Bool {
        set {
            if newValue {
                self.becomeFirstResponder()
                if textIsPlaceholder {
                    self.text = ""
                    self.textColor = K.Color.dark
                }
            } else {
                if self.text.zeroSpaced == "" {
                    self.text = placeholder
                    self.textColor = K.Color.dark.withAlphaComponent(0.5)
                }
            }
        }

        get {
            return super.isFirstResponder
        }
    }
    var roundFactor: CGFloat?
    private var placeholder: String?
    var textIsPlaceholder: Bool {
        return self.text == placeholder
    }
    
    init(roundFactor: CGFloat? = nil, placeholder: String?) {
        self.roundFactor = roundFactor
        super.init(frame: .zero, textContainer: nil)
        self.placeholder = placeholder
        self.text = placeholder
        self.font = UIFont.regular.small
        self.textColor = K.Color.dark.withAlphaComponent(0.5)
        self.backgroundColor = K.Color.light.withAlphaComponent(0.8)
        additionalSetup()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        additionalSetup()
    }
    
    private func additionalSetup() {
        self.addKeyboardToolbarWithTarget(target: self, titleText: nil, rightBarButtonConfiguration: IQBarButtonItemConfiguration(title: "Done", action: #selector(resign(_:))))
        self.keyboardToolbar.doneBarButton.tintColor = K.Color.primary
        self.textContainerInset.top = 16
        self.textContainerInset.bottom = 16
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let factor = roundFactor {
            self.makeRounded(roundFactor: factor)
        }
        self.makeBordered()
    }
    
    @objc func resign(_ sender: Any) {
        self.resignFirstResponder()
    }
}
