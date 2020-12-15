//
//  ToggleCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 15/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A Table cell that displays title, detail and a UISwitch.
class ToggleTableCell: UITableViewCell {
    var title: String! {
        set {
            self.textLabel?.text = newValue
        }
        
        get {
            return self.textLabel?.text
        }
    }
    var detail: String? {
        set {
            self.detailTextLabel?.isHidden = newValue == nil
            self.detailTextLabel?.text = newValue
        }
        
        get {
            return self.detailTextLabel?.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setToggleCell(title: String, detail: String? = nil) {
        setTitle(title)
        setDetail(detail)
        setToggle()
        self.backgroundColor = K.Color.secondary
    }
    
    private func setTitle(_ title: String) {
        if self.title == nil {
            self.textLabel?.font = UIFont.medium.small
            self.textLabel?.textAlignment = .left
            self.textLabel?.textColor = K.Color.dark
        }
        
        self.title = title
    }
    
    private func setDetail(_ detail: String?) {
        if self.detail == nil {
            self.detailTextLabel?.font = UIFont.regular.xSmall
            self.detailTextLabel?.textAlignment = .left
            self.detailTextLabel?.numberOfLines = 0
            self.detailTextLabel?.textColor = K.Color.dark
        }
        
        self.detail = detail
    }
    
    private func setToggle() {
        if self.accessoryView == nil {
            let toggle = UISwitch()
            toggle.onTintColor = K.Color.primary
            self.accessoryView = toggle
        }
    }
}
