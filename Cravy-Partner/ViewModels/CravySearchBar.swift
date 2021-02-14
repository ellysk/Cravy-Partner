//
//  CravySearchBar.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

enum PRODUCT_SORT {
    case date
    case title
    case cravings
    case recommmendations
    case normal
}

/// A custom search bar view that lets you search and filter data.
class CravySearchBar: UIView, UITextFieldDelegate {
    private var textField = CravyTextField()
    private var sortButton = RoundButton(roundFactor: 5)
    private let CSBTintColor: UIColor = K.Color.primary
    var isFilterHidden: Bool {
        set {
            sortButton.isHidden = newValue
        }
        
        get {
            return sortButton.isHidden
        }
    }
    var beginResponder: Bool {
        set {
            if newValue {
                textField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        
        get {
            return textField.isFirstResponder
        }
    }
    var textColor: UIColor? {
        set {
            textField.textColor = newValue
        }
        
        get {
            return textField.textColor
        }
    }
    var presentationDelegate: PresentationDelegate?
    var delegate: CravySearchBarDelegate?
    
    init() {
        super.init(frame: .zero)
        setCravySearchBarLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCravySearchBarLayout()
    }
    
    private func setCravySearchBarLayout() {
        self.tag = K.ViewTag.CRAVY_SEARCH_BAR
        setCravySearchBarView()
        style()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeRounded(roundFactor: 5)
        makeBordered()
    }
    
    private func setCravySearchBarView() {
        sortButton.addTarget(self, action: #selector(sortBy(_:)), for: .touchUpInside)
        let hStackView = UIStackView(arrangedSubviews: [textField, sortButton])
        hStackView.set(axis: .horizontal, distribution: .fillProportionally, spacing: 0)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.widthAnchor(of: 70)
        
        self.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.VConstraint(to: self, constant: 3)
        hStackView.HConstraint(to: self, constant: 8)
    }
    
    private func style() {
        let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchImageView.tintColor = CSBTintColor
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.leftView = searchImageView
        textField.leftViewMode = .always
        textField.setPlaceholder(K.UIConstant.searchProductsPlaceholder)
        textField.font = UIFont.regular.small
        textField.returnKeyType = .search
        textField.addRightButtonOnKeyboardWithText(K.UIConstant.cancel, target: self, action: #selector(cancel))
        textField.keyboardToolbar.tintColor = K.Color.primary
        textField.textColor = K.Color.dark
        textField.tintColor = CSBTintColor
        
        sortButton.setTitle(K.UIConstant.sort.uppercased(), for: .normal)
        sortButton.titleLabel?.font = UIFont.mediumItalic.small
        sortButton.setTitleColor(K.Color.light, for: .normal)
        sortButton.backgroundColor = CSBTintColor.withAlphaComponent(0.8)
    }
    
    func setPlaceholder(_ placeholder: String, color: UIColor) {
        textField.setPlaceholder(placeholder, placeholderTextColor: color)
    }
    
    private func enquire(text: String?) {
        guard let text = textField.text else {return}
        self.delegate?.textDidChange(text.removeLeadingAndTrailingSpaces)
    }
    
    func clear() {
        textField.text = nil
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        enquire(text: textField.text)
    }
    
    @objc func sortBy(_ sender: UIButton) {
        sender.pulse()
        
        let sortByDefault = UIAlertAction(title: K.UIConstant.byDefault, style: .default) { (action) in
            self.delegate?.didSort(by: .normal)
        }
        let sortByDate = UIAlertAction(title: K.UIConstant.byDate, style: .default) { (action) in
            self.delegate?.didSort(by: .date)
        }
        let sortByTitle = UIAlertAction(title: K.UIConstant.byTitle, style: .default) { (action) in
            self.delegate?.didSort(by: .title)
        }
        let sortByCravings = UIAlertAction(title: K.UIConstant.byCravings, style: .default) { (action) in
            self.delegate?.didSort(by: .cravings)
        }
        let sortByRecommendations = UIAlertAction(title: K.UIConstant.byRecommendations, style: .default) { (action) in
            self.delegate?.didSort(by: .recommmendations)
        }
        
        let alertController = UIAlertController(title: nil, message: K.UIConstant.sortMessage, preferredStyle: .actionSheet)
        alertController.addAction(sortByDefault)
        alertController.addAction(sortByDate)
        alertController.addAction(sortByTitle)
        alertController.addAction(sortByCravings)
        alertController.addAction(sortByRecommendations)
        alertController.addAction(UIAlertAction.cancel)
        
        alertController.pruneNegativeWidthConstraints()
        
        self.presentationDelegate?.presentation(alertController, data: nil)
    }
    
    @objc private func cancel() {
        textField.resignFirstResponder()
        clear()
        self.delegate?.didCancelSearch(self)
    }
    
    //MARK:- UITextfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enquire(text: textField.text)
        textField.resignFirstResponder()
        return true
    }
}
