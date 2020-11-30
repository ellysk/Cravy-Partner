//
//  CravySearchBar.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit


/// A custom search bar view that lets you search and filter data.
class CravySearchBar: UIView {
    private var searchButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
    private var textField = UITextField()
    private var filterButton = RoundButton(frame: CGRect(origin: .zero, size: CGSize(width: 70, height: 30)), roundFactor: 5)
    private var CSBTintColor: UIColor! {
        return K.Color.primary
    }
    
    init() {
        super.init(frame: .zero)
        self.tag = K.ViewTag.CRAVY_SEARCH_BAR
        setCravySearchBarView()
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeRounded(roundFactor: 5)
        makeBordered()
    }
    
    private func setCravySearchBarView() {
        let hStackView = UIStackView(arrangedSubviews: [searchButton, textField, filterButton])
        hStackView.set(axis: .horizontal, distribution: .fillProportionally, spacing: 16)
        
        self.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        hStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        hStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }
    
    private func style() {
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = CSBTintColor
        
        textField.font = UIFont.regular.small
        textField.placeholder = K.UIConstants.searchProductsPlaceholder
        textField.textColor = K.Color.dark
        
        filterButton.setTitle(K.UIConstants.filtersButtonTitle, for: .normal)
        filterButton.titleLabel?.font = UIFont.mediumItalic.small
        filterButton.setTitleColor(K.Color.light, for: .normal)
        filterButton.backgroundColor = CSBTintColor.withAlphaComponent(0.8)
    }
}
