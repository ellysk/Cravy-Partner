//
//  Protocols.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

//MARK:- CravySearchBar Delegate

/// Notifies when changes are made in the Cravy Search Bar
protocol CravySearchBarDelegate {
    /// Called when there has been changes in the search bar textfield.
    func textDidChange(_ text: String)
    /// Called when user commits the search
    /// - Parameter text: The text to search for
    func didEnquireSearch(_ text: String)
    /// Called when the user has cancelled the search
    func didCancelSearch(_ searchBar: CravySearchBar)
    /// Called when user has chosen to filter the products.
    func didSort(by sort: PRODUCT_SORT)
}

//MARK:- CravyToolBar Delegate

/// Notifies when changes are made in the Cravy Tool Bar
protocol CravyToolBarDelegate {
    /// Called when item is selected at the specified position
    func itemSelected(at index: Int)
}

//MARK:- LinkView Delegate

/// Notifies when user has interacted with the LinkView
protocol LinkViewDelegate {
    func didTapOnLinkView(_ linkView: LinkView)
}

//MARK:- FloaterView Delegate

/// Notifies when user has interacted with the FloaterView
protocol FloaterViewDelegate {
    /// Use this to get the floater view in which the user has interacted with.
    func didTapFloaterButton(_ floaterView: FloaterView)
}

//MARK:- CravyText Delegate

/// Notifies when changes are made in the Textfield or TextView
protocol CravyTextDelegate {
    /// Called when there has been changes in the textfield text
    func textDidChange(on textField: UITextField, newText: String)
    /// Called when there has been changes in the textview text
    func textDidChange(on textView: UITextView, newText: String)
}

//MARK:- Transition Delegate

/// Notifies of transition between one view controller to another in various cases.
protocol TransitionDelegate {
    /// Called when the page view has successfully transitioned to another view controller(page)
    /// - Parameters:
    ///   - index: The index of the current page displayed.
    ///   - pages: The total number of pages the page view controller is able to display.
    func didTranisitionToViewAt(index: Int, pages: Int)
    /// Called when user has opted to go in the specified direction in a Page View Controller.
    func goTo(direction: UIPageViewController.NavigationDirection)
}

//MARK:- CravyWebViewController Delegate

protocol CravyWebViewControllerDelegate {
    /// Returns the link of the website the user is currently displaying
    /// - Parameter url: The url of the website displayed.
    func didCommitLink(URL: URL)
}

//MARK:- TagsInput Delegate

/// Notifies when user has edited the product's tags
protocol TagsInputDelegate {
    /// Called when user has updated the tags.
    /// - Parameter tags: The new updated tags.
    func didUpdateTags(tags: [String])
}

//MARK:- GalleryTableCell Delegate

protocol GalleryTableCellDelegate {
    /// Called when an image in the gallery view has been tapped by the user.
    /// - Parameters:
    ///   - indexPath: The index path in which the image is at. the row represents the position in which the image is arranged in the view and the section represents the row of this cell.
    ///   - tappedImage: The image tapped by the user.
    func didTapOnImageAt(indexPath: IndexPath, tappedImage: UIImage)
}

//MARK:- ScrollView Delegate

/// Notifies when there has been changes to the scroll view movement
protocol ScrollViewDelegate {
    /// Called when the scroll view has been moved in any direction
    func didScroll(scrollView: UIScrollView)
}

//MARK:- Presentation Delegate

/// Notifies of any view controller's presentation of another view that might occur
protocol PresentationDelegate {
    /// Notifies that a view controller of a certain type wth the provided data can be presented.
    /// - Parameter viewController: The view controller presented.
    func presentation(_ viewController: UIViewController.Type, data: Any?)
    /// Notifies that a view controller wth the provided data can be presented.
    func presentation(_ viewController: UIViewController, data: Any?)
}

//MARK:- ImageViewController Delegate

/// Notifies of interaction in the ImageViewController
protocol ImageViewControllerDelegate {
    /// Called when user has confirmed to use the image specified as the product image.
    /// - Parameter image: product image to be used
    func didConfirmImage(_ image: UIImage)
}

//MARK:- Product Delegate

/// Notifies of interaction with the products displayed
protocol ProductDelegate {
    /// Called when user has selected the specified product in the located position
    func didSelectProduct(_ product: String, at indexPath: IndexPath?)
    /// Called when user has posted the specified product located in the specified position
    func didPostProduct(_ product: String, at indexPath: IndexPath?)
}

//MARK:- LayoutUpdate Delegate

/// Notifies of any layout updates that might be required
protocol LayoutUpdateDelegate {
    func updateLayoutHeight(to height: CGFloat)
}

//MARK:- ProductInfo Delegate

/// Called to notify that the user has completed the new information about the product.
protocol ProductInfoDelegate {
    /// Called when user has confirmed on the input of the product title
    func didConfirmProductTitle(_ title: String)
    /// Called when the user has confirmed on the input of the product description
    func didConfirmProductDescription(_ description: String)
    /// Called when the user has confirmed on the input of the product tags
    func didConfirmProductTags(_ tags: [String])
    /// Called when the user has confirmed on the input of the product link
    func didConfirmProductLink(_ link: String?)
}
