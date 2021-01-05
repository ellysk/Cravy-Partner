//
//  CravyToolBar.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

protocol CravyToolBarDelegate {
    func itemSelected(at index: Int)
}

/// A custom class that acts as a tool bar containing different items that the user can interact with.
class CravyToolBar: UIView {
    private var toolBarStackView = UIStackView()
    var items: [UIButton] = []
    private var item: UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(itemSelected(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.demiBold.small
        
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
    var titles: [String] {
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
    var delegate: CravyToolBarDelegate?
    
    init(titles: [String]) {
        super.init(frame: .zero)
        setCravyToolBarLayout()
        self.titles = titles
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCravyToolBarLayout()
    }
    
    private func setCravyToolBarLayout() {
        self.backgroundColor = .clear
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
        guard let firstItem = items.first else {return}
        isSelected(selectedItem: firstItem)
    }
    
    func isSelected(selectedItem: UIButton) {
        selectedItem.setTitleColor(K.Color.primary, for: .normal)
        
        items.forEach { (button) in
            if button != selectedItem {
                button.setTitleColor(K.Color.dark.withAlphaComponent(0.5), for: .normal)
            }
        }
    }
    
    func isSelectedItemAt(index: Int) {
        if !items.isEmpty {
            isSelected(selectedItem: items[index])
        }
    }
    
    @objc func itemSelected(_ sender: UIButton) {
        isSelected(selectedItem: sender)
        self.delegate?.itemSelected(at: sender.tag)
    }
}

//MARK:- Transition Delegate
extension CravyToolBar: TransitionDelegate {
    func didTranisitionToViewAt(index: Int) {
        isSelectedItemAt(index: index)
    }
}
