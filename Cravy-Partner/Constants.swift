//
//  Constants.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

struct K {
    
    //MARK:- UIConstant
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
        static let post = "Post"
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
        static let changeBusinessLogo = "Change business logo"
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
        static let title = "TITLE"
        static let description = "DESCRIPTION"
        /// Returns "Write your product title here..."
        static let titlePlaceholder = "Write your product title here..."
        /// Returns "Write your product description here..."
        static let descriptionPlaceholder = "Write your product description here..."
        static let addMyOwn = "Add my own"
        static let newTag = "NEW TAG"
        /// Returns "Provide a name of something that would most likely represent this product, it could be a cuisine or an ingredient."
        static let newTagDetail = "Provide a name of something that would most likely represent this product, it could be a cuisine or an ingredient."
        static let add = "ADD"
        static let OK = "OK"
        static let loading = "Loading..."
        static let linkActionTitle = "Is this the web page you would like to use for linking your product?"
        static let addLink = "Add link"
        static let linkSearchPlaceholder = "Enter a link or search"
        static let searches = "search appearances"
        static let views = "views"
        static let visits = "visits"
        static let email = "Email"
        static let password = "Password"
        static let login = "LOGIN"
        static let confirm = "Confirm"
        static let promote = "Promote"
        static let promotionMessage = "Get this amazing product at the top of the feed so you can increase your chances of having more customers."
        static let postMessage = "Put this product in the market for people around the area to see!"
        static let takeProductOffMarket = "Take this product off the market?"
        static let takeProductOffMarketMessage = "People will no longer be able to see this product if you choose to take it off."
        static let takeItOff = "Take it off"
        static let delete = "Delete"
        static let deleteTagMessage = "Are you sure you want to delete this tag?"
        static let create = "Create"
        static let noLinkProvided = "No link provided"
        static let addPhoto = "Add photo"
        static let addProductPhotoMessage = "The photo added will represent your product and is what will be displayed to the customers"
        static let addBusinessLogoMessage = "A photo of your company/business logo"
        static let photoLibrary = "Photo Library"
        static let camera = "Camera"
        static let addNewLink = "Add new link"
        static let deleteLink = "Delete link"
        static let fillAlertMessage = "Please make sure you have filled in the required information."
        static let noLinkMessage = "This product does not have any link that it's associated with."
        static let noBusinessLinkMessage = "Looks like you have not provided your business website link."
        static let oops = "Oops!"
        static let comingSoonTitle = "Got a new product?"
        static let comingSoonMessage = "Let the people know as early as possible so they can save the date and be notified when you post it for the first time."
        static let doIt = "Let's do it!"
        static let account = "Account"
        static let emailFormatAlert = "Please check the format of the email you entered."
        static let no = "No"
        static let deleteProductMessage = "Are you sure you want to delete this product?"
        static let logoutMessage = "Logout of Cravy Partner?"
        static let logout = "Logout"
        static let savePhotoSuccessTitle = "Photo saved in your library"
        static let savePhotoFailTitle = "Could not save the photo, please check your settings"
        static let saveChangesSuccessTitle = "Changes have been saved"
        static let newProductTitle = "Congrats on the new added product!"
        static let newProductMessage = "Put your product on the market so as to attract customers to your business. You can do so by wakening up the sleeping fox with a simple touch."
        static let emptyProductsTitle = "You do not have any products to display."
        static let emptyGalleryTitle = "The kitchen is empty."
        static let internetConnectionAlertMessage = "Something went wrong, please check your internet connection."
        static let retry = "Retry"
    }
    
    //MARK:- Identifier
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
            /// A reusable identifier for the NewCollectionCell
            static let newCell = "newCell"
            
            struct ReusableView {
                /// A reusable identifier for the BasicReusableView
                static let basicView = "basicView"
            }
        }
        
        //MARK:- TableViewCell
        struct TableViewCell {
            /// A reusable identifier for the GalleryTableCell
            static let galleryCell = "galleryCell"
            /// A reusable identifier for the ImageCollectionTableCell
            static let imageCell = "imageCell"
            /// A reusable identifier for the BasicTableCell
            static let basicCell = "basicCell"
            /// A reusable identifier for the ToggleTableCell
            static let toggleCell = "toggleCell"
        }
        
        //MARK:- Segue
        struct Segue {
            static let toAlbumPageController = "toAlbumPageController"
            static let toNewProductPageVC = "toNewProductPageVC"
            static let splashToCravyTabBar = "SplashToCravyTabBar"
            static let toProductsPageVC = "toProductsPageVC"
            static let myProductsToProduct = "MyProductsToProduct"
            static let newProductToAlbum = "NewProductToAlbum"
            static let albumToNewProduct = "AlbumToNewProduct"
            static let newProductToImageView = "NewProductToImageView"
            static let imageViewToNewProductViews = "ImageViewToNewProductViews"
            static let newProductToProduct = "NewProductToProduct"
            static let productToEditProduct = "ProductToEditProduct"
            static let toTagsCollectionVC = "toTagsCollectionVC"
            static let editProductToEditTags = "EditProductToEditTags"
            static let businessToProduct = "BusinessToProduct"
            static let businessToSettings = "BusinessToSettings"
            static let settingsToAccount = "SettingsToAccount"
            static let settingsToSettingsTable = "SettingsToSettingsTable"
            static let toGalleryTableVC = "toGalleryTableVC"
            static let toPRCollectionVC = "toPRCollectionVC"
        }
        
        //MARK:- StoryboardID
        struct StoryboardID {
            static let textsVC = "textsVC"
            static let tagsCollectionVC = "tagsCollectionVC"
            static let linkVC = "linkVC"
            static let cravyWebVC = "CravyWebVC"
            static let newProductVC = "NewProductVC"
            static let productVC = "ProductVC"
            static let albumVC = "AlbumVC"
        }
        
        //MARK:- NibName
        struct NibName {
            static let cravyWebKitViewController = "CravyWebKitViewController"
            static let productEditView = "ProductEditView"
            static let uzumakiView = "UzumakiView"
            static let uchihaView = "UchihaView"
            static let textInputController = "TextInputController"
            static let tagsInputController = "TagsInputController"
            static let linkInputController = "LinkInputController"
            static let emptyView = "EmptyView"
        }
    }
    
    //MARK:- Collections
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
    
    //MARK:- Color
    struct Color {
        static let primary: UIColor = UIColor(named: "primary") ?? .orange
        static let secondary: UIColor = UIColor(named: "secondary") ?? .orange
        static let light: UIColor = UIColor(named: "light") ?? .white
        static let dark: UIColor = UIColor(named: "dark") ?? .black
        static let link: UIColor = UIColor(named: "link") ?? .link
        static let important: UIColor = UIColor(named: "important") ?? .red
        static let positive: UIColor = UIColor(named: "positive") ?? .green
    }
    
    //MARK:- Size
    struct Size {
        /// Returns a size of 40
        static let CRAVY_SEARCH_BAR_HEIGHT: CGFloat = 40
        /// Returns a size of 30
        static let CRAVY_TOOL_BAR_HEIGHT: CGFloat = 30
    }
    
    //MARK:- ViewTag
    struct ViewTag {
        /// Returns a tag value of 11
        static let CRAVY_SEARCH_BAR: Int = 11
        /// Returns a tag value of 22
        static let FLOATER_VIEW: Int = 22
        /// Returns a tag value of 33
        static let BACK_BUTTON: Int = 33
        /// Returns a tag value of 44
        static let BLURR_VIEW: Int = 44
        /// Returns a tag value of 55
        static let PLACEHOLDER_VIEW: Int = 55
        /// Returns a tag value of 66
        static let DISMISS_BUTTON: Int = 66
        /// Returns a tag value of 77
        static let IMAGE_COLLECTION_VIEW: Int = 77
        /// Returns a tag value of 88
        static let CRAVE_COLLECTION_VIEW: Int = 88
        /// Returns a tag value of 99
        static let EMPTY_VIEW: Int = 99
    }
    
    //MARK:- Image
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
    
    //MARK:- StoryBoard
    struct StoryBoard {
        static let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        static let product: UIStoryboard = UIStoryboard(name: "Product", bundle: nil)
        static let settings: UIStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        static let newProduct: UIStoryboard = UIStoryboard(name: "NewProduct", bundle: nil)
        static let album: UIStoryboard = UIStoryboard(name: "Album", bundle: nil)
    }
    
    //MARK:- Controller
    struct Controller {
        static let newProductController: NewProductController = StoryBoard.main.instantiateViewController(withIdentifier: Identifier.StoryboardID.newProductVC) as! NewProductController
        static let productController: ProductController = StoryBoard.product.instantiateViewController(withIdentifier: Identifier.StoryboardID.productVC) as! ProductController
        static let albumController: AlbumController = StoryBoard.album.instantiateViewController(withIdentifier: K.Identifier.StoryboardID.albumVC) as! AlbumController
    }
    
    //MARK:- Predicate
    struct Predicate {
        private static let firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        private static let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        private static let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,8}"
        static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    }
    
    //MARK:- Key
    struct Key {
        static let image = "image"
        static let title = "title"
        static let description = "description"
        static let tags = "tags"
        static let url = "url"
        static let name = "name"
        static let email = "email"
        static let number = "number"
        static let recommendations = "recommendations"
        static let subscribers = "subscribers"
        static let cravings = "cravings"
        static let state = "state"
    }
}
