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
        static let cravings = "cravings"
        static let subscribers = "Subscribers"
        static let offTheMarket = "Off the market"
        static let onTheMarket = "On the market"
        static let post = "POST"
        static let edit = "Edit"
        static let settings = "Settings"
        /// Returns "Important information regarding privacy and security rules will be alerted here"
        static let settingsAlertMessage = "Important information regarding privacy and security rules will be alerted here"
        /// Returns "Terms & Agreement"
        static let termsAndAgreement = "Terms & Agreement"
        static let byTitle = "By Title"
        static let byCravings = "By Cravings"
        static let byRecommendations = "By Recommendations"
        static let filtersMessage = "Choose a filter"
        static let removeFilter = "Remove Filter"
        static let cancel = "Cancel"
        static let addBusinessLogo = "Change business logo"
        static let changeBusinessName = "Change business name"
        static let changeBusinessEmail = "Change business email"
        static let changePhoneNumber = "Change business phone number"
        static let twoFactorAuth = "Two-Factor Authentication"
        /// Returns "Cravy Partner"
        static let albumTitle = "Cravy Partner"
        static let accessDenied = "Access denied"
        static let photoLibraryAccessDeniedMessage = "We can not access your photo library, please go to settings to change this"
        static let cameraRoll = "Camera roll"
        static let active = "Active"
        static let inactive = "Inactive"
        static let next = "Next"
    }
    
    struct Identifier {
        struct CollectionViewCell {
            /// A resuable identifier for the CraveCollectionCell
            static let craveCell = "craveCell"
            /// A reusable identifier for the TagCollectionCell
            static let tagCell = "tagCell"
            /// A reusable identifier for the ImageCollectionCell
            static let imageCell = "imageCell"
            /// A reusable identifier for the WidgetCollectionCell
            static let widgetCell = "widgetCell"
            /// A reusable identifier for the AlbumCollectionCell
            static let albumCell = "albumCell"
            
            struct ReusableView {
                /// A reusable identifier for the BasicReusableView
                static let basicView = "basicView"
            }
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
        
        struct Segue {
            static let toAlbumPageController = "toAlbumPageController"
        }
    }
    
    struct Collections {
        /// Returns ["Cook", "Present", "Track"]
        static let introSections = ["Cook", "Present", "Track"]
        /// Returns ["Cook" : "You get to do what you have always been doing, that is making good food for your customers.", "Present" : "Good food ought to be noticed by people, post your greatest or upcoming creations for the people in your area to see!", "Track" : "See how many people are engaging with your creations, visiting your website and recommending people to try out your product!"]
        
        /// Returns ["Cook" : "You get to do what you have always been doing, that is making good food for your customers.", "Present" : "Good food ought to be noticed by people, post your greatest or upcoming creations for the people in your area to see!", "Track" : "See how many people are engaging with your creations, visiting your website and recommending people to try out your product!"]
        static let introSectionDetails: [String : String] = ["Cook" : "You get to do what you have always been doing, that is making good food for your customers.", "Present" : "Good food ought to be noticed by people, post your greatest or upcoming creations for the people in your area to see!", "Track" : "See how many people are engaging with your creations, visiting your website and recommending people to try out your product!"]
        /// Returns ["Make your business stand out", "Let your customers see them", "The Kitchen"]
        static let businessSectionTitles = ["Make your business stand out", "Let your customers see them", "The Kitchen"]
        /// Returns [K.Image.promote, K.Image.comingSoon]
        static let businessStandoutImages = [K.Image.promote, K.Image.comingSoon]
        /// Returns ["Account", "Notifications", "Privacy & Security", "Help & Support", "About"]
        static let settingsTitles = ["Account", "Notifications", "Privacy & Security", "Help & Support", "About"]
        /// Returns [K.Image.account, K.Image.notifications, K.Image.privacy, K.Image.help, K.Image.about]
        static let settingsImages = [K.Image.account, K.Image.notifications, K.Image.privacy, K.Image.help, K.Image.about]
        /// Returns ["Email notifications", "Push notifications"]
        static let notificationSectionTitles = ["Email notifications", "Push notifications"]
        /// Returns settings related to notifications.
        static let notificationSettings = [Setting(title: "Product updates", detail: "Receive updates on the product’s cravings and recommendations as well as information regarding the product’s engagement with the customers."), Setting(title: "News Letters", detail: "Receive updates from the Cravy team regarding the application and any changes made to it. Also receive relevant news on food businesses.")]
        /// Returns settings related to two factor authentication
        static let twoFactorAuthenticationSettings = [Setting(title: "Send via Email", detail: nil), Setting(title: "Send via SMS", detail: nil), Setting(title: "Ask password", detail: "Asks you for the password every time the app goes in background for more than one minute.")]
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
        static let thumbsUp: UIImage = UIImage(systemName: "hand.thumbsup.fill")!
        static let cravings: UIImage = UIImage(named: "cravings")!
        static let promote: UIImage = UIImage(named: "promote")!
        static let comingSoon: UIImage = UIImage(named: "comingsoon")!
        static let flashOn: UIImage = UIImage(systemName: "bolt.fill")!
        static let flashOff: UIImage = UIImage(systemName: "bolt.slash.fill")!
    }
}
