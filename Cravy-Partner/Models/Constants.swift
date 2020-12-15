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
        static let subscribers = "Subscribers"
        static let offTheMarket = "Off the market"
        static let onTheMarket = "On the market"
        static let post = "POST"
        static let edit = "Edit"
        static let settings = "Settings"
        static let settingsAlertMessage = "Important information regarding privacy and security rules will be alerted here"
        static let askPasswordTitle = "Ask password"
        static let askPasswordDetail = "Asks you for the password every time the app goes in background for more than one minute."
        static let termsAndAgreement = "Terms & Agreement"
    }
    
    struct Identifier {
        struct CollectionViewCell {
            /// A reusable identifier for the DetailCollectionCell
            static let detailCell = "detailCell"
            /// A resuable identifier for the CraveCollectionCell
            static let craveCell = "craveCell"
            /// A reusable identifier for the TagCollectionCell
            static let tagCell = "tagCell"
            /// A reusable identifier for the ImageCollectionCell
            static let imageCell = "imageCell"
        }
        
        struct TableViewCell {
            /// A reusable identifier for the GalleryTableCell
            static let galleryCell = "galleryCell"
            /// A reusable identifier for the ImageCollectionTableCell
            static let imageCell = "imageCell"
            /// A resuable identifier for the CraveCollectionTableCell
            static let craveCell = "craveCell"
            /// A reusable identifier for the BasicTableCell
            static let basicCell = "basicCell"
            /// A reusable identifier for the ToggleTableCell
            static let toggleCell = "toggleCell"
        }
    }
    
    struct Collections {
        /// Returns ["Cook", "Present", "Track"]
        static let introSections = ["Cook", "Present", "Track"]
        /// Returns ["Cook" : "You get to do what you have always been doing, that is making good food for your customers.", "Present" : "Good food ought to be noticed by people, post your greatest or upcoming creations for the people in your area to see!", "Track" : "See how many people are engaging with your creations, visiting your website and recommending people to try out your product!"]
        
        /// Returns ["Cook" : "You get to do what you have always been doing, that is making good food for your customers.", "Present" : "Good food ought to be noticed by people, post your greatest or upcoming creations for the people in your area to see!", "Track" : "See how many people are engaging with your creations, visiting your website and recommending people to try out your product!"]
        static let introSectionDetails = ["Cook" : "You get to do what you have always been doing, that is making good food for your customers.", "Present" : "Good food ought to be noticed by people, post your greatest or upcoming creations for the people in your area to see!", "Track" : "See how many people are engaging with your creations, visiting your website and recommending people to try out your product!"]
        /// Returns ["Make your business stand out", "Let your customers see them", "The Kitchen"]
        static let sectionTitles = ["Make your business stand out", "Let your customers see them", "The Kitchen"]
        /// Returns ["Account", "Notifications", "Privacy & Security", "Help & Support", "About"]
        static let settingsTitles = ["Account", "Notifications", "Privacy & Security", "Help & Support", "About"]
        /// Returns [K.Image.account, K.Image.notifications, K.Image.privacy, K.Image.help, K.Image.about]
        static let settingsImages = [K.Image.account, K.Image.notifications, K.Image.privacy, K.Image.help, K.Image.about]
        /// Returns ["Email notifications", "Push notifications"]
        static let notificationSectionTitles = ["Email notifications", "Push notifications"]
        /// Returns ["Product updates", "News Letters"]
        static let notificationTitles = ["Product updates", "News Letters"]
        /// Returns ["Receive updates on the product’s cravings and recommendations as well as information regarding the product’s engagement with the customers.", "Receive updates from the Cravy team regarding the application and any changes made to it. Also receive relevant news on food businesses."]
        static let notificationDetails = ["Receive updates on the product’s cravings and recommendations as well as information regarding the product’s engagement with the customers.", "Receive updates from the Cravy team regarding the application and any changes made to it. Also receive relevant news on food businesses."]
        /// Returns ["Send via Email", "Send via SMS"]
        static let twoFactorAuthenticationTitles = ["Send via Email", "Send via SMS"]
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
        static let FLOATER_VIEW: Int = 22
    }
    
    struct Image {
        static let ellipsisCricleFill: UIImage = UIImage(systemName: "ellipsis.circle.fill")!
        static let pencilCircleFill : UIImage = UIImage(systemName: "pencil.circle.fill")!
        static let account: UIImage = UIImage(named: "account")!
        static let notifications: UIImage = UIImage(systemName: "bell")!
        static let privacy: UIImage = UIImage(systemName: "lock")!
        static let about: UIImage = UIImage(systemName: "questionmark.circle")!
        static let help: UIImage = UIImage(named: "help")!
    }
}
