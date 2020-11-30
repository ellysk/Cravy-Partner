//
//  Constants.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

struct K {
    
    struct UIConstants {
        static let searchProductsPlaceholder: String = "Search for your products..."
        static let filtersButtonTitle: String = "Filters"
    }
    
    struct Color {
        static let primary: UIColor = UIColor(named: "primary") ?? .orange
        static let light: UIColor = UIColor(named: "light") ?? .white
        static let dark: UIColor = UIColor(named: "dark") ?? .black
    }
    
    struct Size {
        static let CRAVY_SEARCH_BAR_HEIGHT: CGFloat = 40
        static let CRAVY_TOOL_BAR_HEIGHT: CGFloat = 30
    }
    
    struct ViewTag {
        static let CRAVY_SEARCH_BAR: Int = 11
    }
}
