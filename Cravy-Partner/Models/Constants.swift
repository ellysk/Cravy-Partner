//
//  Constants.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

struct K {
    
    struct UIConstant {
        /// Returns "Search for your products..."
        static let searchProductsPlaceholder: String = "Search for your products..."
        /// Returns "Filters"
        static let filtersButtonTitle: String = "Filters"
        /// Returns ""VISIT"
        static let visit: String = "VISIT"
        static let recommendations = "recommendations"
        static let offTheMarket = "Off the market"
        static let onTheMarket = "On the market"
    }
    
    struct Identifier {
        struct CollectionViewCell {
            /// A reusable identifier for the DetailCollectionCell
            static let detailCell = "detailCell"
            /// A resuable identifier for the CraveCollectionCell
            static let craveCell = "craveCell"
            /// A reusable identifier for the TagCollectionCell
            static let tagCell = "tagCell"
        }
    }
    
    struct Collections {
        /// Returns ["Cook", "Present", "Track"]
        static let introSections = ["Cook", "Present", "Track"]
        /// Returns ["Cook" : "You get to do what you have always been doing, that is making good food for your customers.", "Present" : "Good food ought to be noticed by people, post your greatest or upcoming creations for the people in your area to see!", "Track" : "See how many people are engaging with your creations, visiting your website and recommending people to try out your product!"]
        static let introSectionDetails = ["Cook" : "You get to do what you have always been doing, that is making good food for your customers.", "Present" : "Good food ought to be noticed by people, post your greatest or upcoming creations for the people in your area to see!", "Track" : "See how many people are engaging with your creations, visiting your website and recommending people to try out your product!"]
    }
    
    struct Color {
        static let primary: UIColor = UIColor(named: "primary") ?? .orange
        static let secondary: UIColor = UIColor(named: "secondary") ?? .orange
        static let light: UIColor = UIColor(named: "light") ?? .white
        static let dark: UIColor = UIColor(named: "dark") ?? .black
        static let link: UIColor = UIColor(named: "link") ?? .link
        static let important: UIColor = UIColor(named: "important") ?? .red
    }
    
    struct Size {
        /// Returns a size of 40
        static let CRAVY_SEARCH_BAR_HEIGHT: CGFloat = 40
        /// Returns a size of 30
        static let CRAVY_TOOL_BAR_HEIGHT: CGFloat = 30
    }
    
    struct ViewTag {
        /// Returns a tag value of 11
        static let CRAVY_SEARCH_BAR: Int = 11
        /// Returns a tag value of 22
        static let FLOATER_BUTTON: Int = 22
    }
}
