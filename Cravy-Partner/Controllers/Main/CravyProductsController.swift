//
//  CravyProductsController.swift
//  Cravy-Partner
//
//  Created by Cravy on 01/03/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import PromiseKit
import Lottie

enum PRODUCT_STATE: Int {
    case active = 1
    case inActive = 0
    
    var description: String {
        switch self {
        case .active:
            return "active"
        case .inActive:
            return "inactive"
        }
    }
}

enum PRODUCTS_UPDATE {
    case add
    case remove
    case edit
}

class CravyProductsController: UICollectionViewController {
    internal var products: [Product] = [] {
        didSet {
            reloadEmptyView()
            self.collectionView.reloadData()
        }
    }
    internal var filteredProducts: [Product] = []
    internal var showFiltered: Bool = false {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var state: PRODUCT_STATE = .inActive
    var dummyCount: Int = 10
    internal var isLoadingProducts: Bool! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var data: [Product] {
        return showFiltered ? filteredProducts : products
    }
    var dataCount: Int {
        if isLoadingProducts {
            return products.count + dummyCount
        } else {
            return data.count
        }
    }
    internal var productUpdate: PRODUCTS_UPDATE?
    internal var productFB: ProductFirebase!
    /// A boolean that determines if the products have been loaded at all.
    var didInitializeFirstBatch: Bool {
        return productFB != nil
    }
    internal var isContained: Bool = false
    var scrollDelegate: ScrollViewDelegate?
    var presentationDelegate: PresentationDelegate?
    var delegate: ProductDelegate?
    
    init(state: PRODUCT_STATE) {
        self.state = state
        super.init(collectionViewLayout: UICollectionViewFlowLayout.verticalCraveCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productFB = ProductFirebase(state: state)
        self.collectionView.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
        self.collectionView.isTransparent = true
        loadCraves()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch productUpdate {
        case .add:
            sortProductsBy(sort: .normal)
        case .remove, .edit:
            self.collectionView.reloadData()
        default:
            break
        }
        productUpdate = nil
    }
    
    internal func loadCraves() {
        isLoadingProducts = true
        
        firstly {
            productFB.loadProducts()
        }.done { (products) in
            self.products.append(contentsOf: products)
        }.ensure(on: .main) {
            self.isLoadingProducts = false
            self.reloadEmptyView()
        }.catch { (error) in
            self.present(UIAlertController.internetConnectionAlert(actionHandler: self.loadCraves), animated: true)
        }
    }
    
    internal func reloadEmptyView() {}
    
    func searchForProductWith(query text: String?) {
        if let queryText = text {
            filteredProducts = products.filter({ (product) -> Bool in
                return product.title.containsIgnoringCase(find: queryText) || product.detail.containsIgnoringCase(find: queryText) || product.tags.contains(where: { (tag) -> Bool in
                    return tag.containsIgnoringCase(find: queryText)
                })
            })
        }
        showFiltered = text != nil && text != ""
    }
    
    func sortProductsBy(sort: PRODUCT_SORT) {
        switch sort {
        case .title:
            products = products.sorted(by: { (aProduct, bProduct) -> Bool in
                return aProduct.title < bProduct.title
            })
        case .cravings:
            products = products.sorted(by: { (aProduct, bProduct) -> Bool in
                return aProduct.cravings > bProduct.cravings
            })
        case .recommmendations:
            products = products.sorted(by: { (aProduct, bProduct) -> Bool in
                return aProduct.recommendations > bProduct.recommendations
            })
        case .date:
            products = products.sorted(by: { (aProduct, bProduct) -> Bool in
                return aProduct.date < bProduct.date
            })
        case .normal:
            products = products.sorted(by: { (aProduct, bProduct) -> Bool in
                return aProduct.date > bProduct.date
            })
        }
    }
    
    func add(_ product: Product) {
        if didInitializeFirstBatch {
            products.append(product)
            productUpdate = .add
        }
    }
    
    func remove(_ product: Product, indexPath: IndexPath? = nil) {
        if let path = indexPath {
            products.remove(at: path.item)
            self.collectionView.deleteItems(at: [path])
        } else {
            guard let index = products.firstIndex(of: product) else {return}
            products.remove(at: index)
            productUpdate = .remove
        }
    }
    
    func edit(_ product: Product) {
        guard let index = products.firstIndex(of: product) else {return}
        products[index] = product
        productUpdate = .edit
    }
    
    //MARK:- UICollectionView DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.craveCell, for: indexPath) as! CraveCollectionCell
        
        if isLoadingProducts && indexPath.item >= products.count {
            //Show loading animation to this cell
            if isContained {
                cell.setCraveCollectionCell(style: .contained)
            } else {
                cell.setCraveCollectionCell()
            }
            cell.startLoadingAnimation()
        } else {
            cell.stopLoadingAnimation()
            if isContained {
                cell.setCraveCollectionCell(product: data[indexPath.item], style: .contained)
            } else {
                cell.setCraveCollectionCell(product: data[indexPath.item])
            }
            cell.addAction {
                let promo = PromoView(toPromote: self.data[indexPath.item].title)
                let popVC = PopViewController(popView: promo, animationView: AnimationView.promoteAnimation, actionHandler: {
                    //Promote product
                    //TODO
                    func promote() {
                        self.startLoader { (loaderVC) in
                            firstly {
                                self.productFB.setPromotion(id: self.data[indexPath.item].id, isPromoted: true)
                            }.done { (result) in
                                guard let isPromoted = result.data as? Bool else {return}
                                if self.showFiltered {
                                    self.filteredProducts[indexPath.item].isPromoted = isPromoted
                                } else {
                                    self.products[indexPath.item].isPromoted = isPromoted
                                }
                            }.ensure(on: .main, {
                                loaderVC.stopLoader()
                            })
                            .catch(on: .main) { (error) in
                                self.present(UIAlertController.internetConnectionAlert(actionHandler: promote), animated: true)
                            }
                        }
                    }
                    promote()
                })
                //Notifies so as to dismiss any first responders.
                self.presentationDelegate?.presentation(PopViewController.self, data: nil)
                self.present(popVC, animated: true)
            }
        }
        if state == .inActive {
            cell.addInteractable(.post) { (popVC) in
                //Notifies so as to dismiss any first responders.
                self.presentationDelegate?.presentation(PopViewController.self, data: nil)
                popVC.action = {
                    func post() {
                        self.startLoader { (loaderVC) in
                            firstly {
                                self.productFB.updateMarketStatus(of: self.data[indexPath.item])
                            }.done { (result) in
                                guard let value = result.data as? Int, let newState = PRODUCT_STATE(rawValue: value) else {return}
                                if self.showFiltered {
                                    self.filteredProducts[indexPath.item].state = newState
                                } else {
                                    self.products[indexPath.item].state = newState
                                }
                                self.delegate?.didPostProduct(self.data[indexPath.item], at: indexPath)
                            }.ensure(on: .main) {
                                loaderVC.stopLoader()
                            }.catch(on: .main) { (error) in
                                self.present(UIAlertController.internetConnectionAlert(actionHandler: post), animated: true)
                            }
                        }
                    }
                    post()
                }
                self.present(popVC, animated: true)
            }
        }
        return cell
    }
    
    //MARK:- UICollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presentationDelegate?.presentation(ProductController.self, data: data[indexPath.item])
    }
    
    //MARK:- UIScrollView Delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.didScroll(scrollView: scrollView)
    }
}
