//
//  CravySearchBar.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

protocol CravySearchBarDelegate {
    func willPresentFilterAlertController(alertController: UIAlertController)
}

/// A custom search bar view that lets you search and filter data.
class CravySearchBar: UIView {
    private var textField = CravyTextField()
    private var filterButton = RoundButton(roundFactor: 5)
    private let CSBTintColor: UIColor = K.Color.primary
    var isFilterHidden: Bool {
        set {
            filterButton.isHidden = newValue
        }
        
        get {
            return filterButton.isHidden
        }
    }
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
        filterButton.addTarget(self, action: #selector(showFilters(_:)), for: .touchUpInside)
        let hStackView = UIStackView(arrangedSubviews: [textField, filterButton])
        hStackView.set(axis: .horizontal, distribution: .fillProportionally, spacing: 0)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.widthAnchor(of: 70)
        
        self.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.VConstraint(to: self, constant: 3)
        hStackView.HConstraint(to: self, constant: 8)
    }
    
    private func style() {
        let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchImageView.tintColor = CSBTintColor
        textField.leftView = searchImageView
        textField.leftViewMode = .always
        textField.setPlaceholder(K.UIConstant.searchProductsPlaceholder)
        textField.font = UIFont.regular.small
        textField.returnKeyType = .search
        textField.textColor = K.Color.dark
        textField.tintColor = CSBTintColor
        
        filterButton.setTitle(K.UIConstant.filtersButtonTitle, for: .normal)
        filterButton.titleLabel?.font = UIFont.mediumItalic.small
        filterButton.setTitleColor(K.Color.light, for: .normal)
        filterButton.backgroundColor = CSBTintColor.withAlphaComponent(0.8)
    }
    
    func setPlaceholder(_ placeholder: String, color: UIColor) {
        textField.setPlaceholder(placeholder, placeholderTextColor: color)
    }
    
    @objc func showFilters(_ sender: UIButton) {
        let filterByTitle = UIAlertAction(title: K.UIConstant.byTitle, style: .default) { (action) in
            //TODO
        }
        let filterByCravings = UIAlertAction(title: K.UIConstant.byCravings, style: .default) { (action) in
            //TODO
        }
        let filterByRecommendations = UIAlertAction(title: K.UIConstant.byRecommendations, style: .default) { (action) in
            //TODO
        }
        let removeFilterAction = UIAlertAction(title: K.UIConstant.removeFilter, style: .destructive) { (action) in
            //TODO
        }
        
        let alertController = UIAlertController(title: nil, message: K.UIConstant.filtersMessage, preferredStyle: .actionSheet)
        alertController.addAction(filterByTitle)
        alertController.addAction(filterByCravings)
        alertController.addAction(filterByRecommendations)
        alertController.addAction(removeFilterAction)
        alertController.addAction(UIAlertAction.cancel)
        
        alertController.pruneNegativeWidthConstraints()
        
        self.delegate?.willPresentFilterAlertController(alertController: alertController)
    }
}
