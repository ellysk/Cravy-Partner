//
//  CravyToolBar.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A custom class that acts as a tool bar containing different items that the user can interact with.
class CravyToolBar: UIView {
    private var toolBarStackView = UIStackView()
    private var items: [UIButton] = []
    private var item: UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont.demiBold.small
        button.setTitleColor(K.Color.dark.withAlphaComponent(0.5), for: .normal)
        
        return button
    }
    /// The line that separates two items
    private var separatorView: UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor(of: K.Size.CRAVY_TOOL_BAR_HEIGHT * 0.6)
        separator.widthAnchor(of: 1)
        separator.backgroundColor = K.Color.primary
        
        return separator
    }
    private var titles: [String] {
        set {
            //set the title and tag of each item
            for i in 0...newValue.count - 1 {
                let button = item
                button.setTitle(newValue[i], for: .normal)
                button.tag = i
                
                items.append(button)
            }
            
            //then add them to the stackview
            arrangeItems()
        }
        
        get {
            var array: [String] = []
            
            items.forEach { (button) in
                if let title = button.title(for: .normal) {
                    array.append(title)
                }
            }
            
            return array
        }
    }
    
    init(titles: [String]) {
        super.init(frame: .zero)
        self.titles = titles
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setToolBarStackView()
    }
    
    private func setToolBarStackView() {
        toolBarStackView.set(axis: .horizontal, alignment: .center, distribution: .fillProportionally, spacing: 16)
        
        self.addSubview(toolBarStackView)
        toolBarStackView.translatesAutoresizingMaskIntoConstraints = false
        toolBarStackView.heightAnchor(to: self)
        toolBarStackView.centerXAnchor(to: self)
    }
    
    /// Adds all the items into the stackview
    private func arrangeItems() {
        items.forEach { (button) in
            toolBarStackView.addArrangedSubview(button)
            
            if items.last != button {
                toolBarStackView.addArrangedSubview(separatorView)
            }
        }
    }
}
