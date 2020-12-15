//
//  GalleryTableCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 11/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

enum GALLERY_LAYOUT: Int {
    case uzumaki
    case uchiha
    
    /// Changes to another layout.
    mutating func change() {
        if self == .uzumaki {
            self = .uchiha
        } else {
            self = .uzumaki
        }
    }
}

/// Displays a collection of RoundImageViews arranged in mutiple stackviews with a layout that is dynamic.
class GalleryTableCell: UITableViewCell {
    private var containerView: UIView!
    private var uzumakiGalleryView: GalleryView?
    private var uchihaGalleryView: GalleryView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// - Parameters:
    ///   - layout: Determines how the image views are layout and presented. adjusts the size and position.
    ///   - images: The images that will be displayed. The maximum number of images displayed is 5.
    func setGalleryTableCell(layout: GALLERY_LAYOUT = .uzumaki, images: [UIImage] = []) {
        setContainerView()
        setGalleryView(layout: layout, images: images)
    }
    
    private func setContainerView() {
        if containerView == nil {
            self.backgroundColor = .clear
            containerView = UIView()
            containerView.backgroundColor = .clear
            self.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.VHConstraint(to: self)
        }
    }
    
    private func setGalleryView(layout: GALLERY_LAYOUT, images: [UIImage]) {
        if layout == .uzumaki {
            uzumakiGalleryView?.isHidden = false
            uchihaGalleryView?.isHidden = true
            if uzumakiGalleryView == nil {
                uzumakiGalleryView = GalleryView(layout: layout, images: images)
                containerView.addSubview(uzumakiGalleryView!)
                uzumakiGalleryView!.translatesAutoresizingMaskIntoConstraints = false
                uzumakiGalleryView!.VConstraint(to: containerView, constant: 1.5)
                uzumakiGalleryView!.HConstraint(to: containerView, constant: 8)
            } else {
                uzumakiGalleryView?.images = images
                uzumakiGalleryView?.setGalleryStackView(layout: layout)
            }
        } else {
            uchihaGalleryView?.isHidden = false
            uzumakiGalleryView?.isHidden = true
            if uchihaGalleryView == nil {
                uchihaGalleryView = GalleryView(layout: layout, images: images)
                containerView.addSubview(uchihaGalleryView!)
                uchihaGalleryView!.translatesAutoresizingMaskIntoConstraints = false
                uchihaGalleryView!.VConstraint(to: containerView, constant: 1.5)
                uchihaGalleryView!.HConstraint(to: containerView, constant: 8)
            } else {
                uchihaGalleryView?.images = images
                uchihaGalleryView?.setGalleryStackView(layout: layout)
            }
        }
    }
}

/// A collection of RoundImageViews that are arranged in mutiple stackviews with a layout that is dynamic.
class GalleryView: UIStackView {
    private var imageViews: [RoundImageView] = []
    /// Returns a collection of RoundImageViews.
    var gallery: [RoundImageView] {
        return imageViews
    }
    /// Returns a collection of images displayed in the image views.
    var images: [UIImage] {
        set {
            if newValue.count > 0 {
                for i in 0...newValue.count - 1 {
                    gallery[i].image = newValue[i]
                    gallery[i].contentMode = .scaleAspectFill
                }
            }
        }
        
        get {
            var images: [UIImage] = []
            gallery.forEach { (imageView) in
                if let image = imageView.image {
                    images.append(image)
                }
            }
            return images
        }
    }
    private var horizontalSpaceToFill: CGFloat {
        return UIScreen.main.bounds.width - (spacing+16)
    }
    private var verticalSpaceToFill: CGFloat {
        return height - spacing
    }
    /// The maximum number of round image views.
    static let MAX_SUBVIEWS: Int = 5
    private var height: CGFloat {
        return 320
    }
    
    init(frame: CGRect = .zero, layout: GALLERY_LAYOUT = .uzumaki, images: [UIImage] = []) {
        super.init(frame: frame)
        setImageViews()
        self.images = images
        setGalleryStackView(layout: layout)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImageViews() {
        for _ in 0...GalleryView.MAX_SUBVIEWS - 1 {
            let imageView = RoundImageView(frame: .zero, roundfactor: 10)
            imageViews.append(imageView)
        }
    }
    
    func setGalleryStackView(layout: GALLERY_LAYOUT) {
        if layout == .uzumaki {
            setUzumakiLayout()
        } else {
            setUchihaLayout()
        }
    }
    
    private func setUzumakiLayout() {
        var vStackView1: UIStackView!
        var hStackView: UIStackView!
        
        if self.arrangedSubviews.isEmpty {
            self.set(axis: .horizontal, distribution: .fillProportionally, spacing: 3)
            
            //firstvertical
            vStackView1 = UIStackView(arrangedSubviews: [gallery[0]])
            vStackView1.set(axis: .vertical, distribution: .fillProportionally, spacing: spacing)
            
            hStackView = UIStackView(arrangedSubviews: [gallery[1], gallery[2]])
            hStackView.set(axis: .horizontal, distribution: .fillProportionally, spacing: spacing)
            hStackView.heightAnchor(of: verticalSpaceToFill * 0.3)
            vStackView1.addArrangedSubview(hStackView)
            
            //secondVertical
            let vStackView2 = UIStackView(arrangedSubviews: [gallery[3], gallery[4]])
            vStackView2.set(axis: .vertical, distribution: .fill, spacing: spacing)
            
            
            //arrange all of them together in a horizontal stack view
            self.addArrangedSubview(vStackView1)
            self.addArrangedSubview(vStackView2)
        } else {
            vStackView1 = self.arrangedSubviews[0] as? UIStackView
            hStackView = vStackView1.arrangedSubviews[1] as? UIStackView
        }
        
        if images.count <= 3 {
            vStackView1.widthAnchor(of: horizontalSpaceToFill)
        } else {
            vStackView1.widthAnchor(of: horizontalSpaceToFill * 0.7)
        }
        
        if images.count == 4 {
            gallery[0].heightAnchor(of: verticalSpaceToFill * 0.7)
        } else {
            gallery[3].heightAnchor(of: verticalSpaceToFill * 0.3)
            gallery[4].heightAnchor(of: verticalSpaceToFill * 0.7)
        }
        gallery[4].isHidden = images.count == 4
        hStackView.isHidden = images.count == 1
    }
    
    private func setUchihaLayout() {
        var hStackView2: UIStackView!
        var hStackView1: UIStackView!
        
        if self.arrangedSubviews.isEmpty {
            self.set(axis: .vertical, distribution: .fill, spacing: 3)
            
            //first horizontal
            hStackView1 = UIStackView(arrangedSubviews: [gallery[0]])
            hStackView1.set(axis: .horizontal, distribution: .fillProportionally, spacing: spacing)
            
            let vStackView = UIStackView(arrangedSubviews: [gallery[1], gallery[2]])
            vStackView.set(axis: .vertical, distribution: .fillProportionally, spacing: spacing)
            hStackView1.addArrangedSubview(vStackView)
            
            //second horizontal
            hStackView2 = UIStackView(arrangedSubviews: [gallery[3], gallery[4]])
            hStackView2.set(axis: .horizontal, distribution: .fillProportionally, spacing: spacing)
            hStackView2.heightAnchor(of: verticalSpaceToFill * 0.3)
            
            //arrange all of them together in a vertical stack view
            self.addArrangedSubview(hStackView1)
            self.addArrangedSubview(hStackView2)
        } else {
            hStackView1 = self.arrangedSubviews[0] as? UIStackView
            hStackView2 = self.arrangedSubviews[1] as? UIStackView
        }
        hStackView2.isHidden = images.count <= 3
        if images.count <= 3 {
            hStackView1.heightAnchor(of: verticalSpaceToFill)
        } else {
            hStackView1.heightAnchor(of: verticalSpaceToFill * 0.7)
        }
        if images.count == 4 {
            gallery[3].widthAnchor(of: horizontalSpaceToFill)
        } else if images.count == GalleryView.MAX_SUBVIEWS {
            gallery[3].widthAnchor(of: horizontalSpaceToFill * 0.7)
        }
    }
    
    /// Returns the number of rows required to display images provided.
    static func calculateNumberOfRows(for numberOfImages: Int) -> Int {
        if numberOfImages <= 0 {
            return 1
        } else if numberOfImages % MAX_SUBVIEWS == 0 {
            return numberOfImages / MAX_SUBVIEWS
        } else {
            let nearestMultiple = numberOfImages + 1
            return calculateNumberOfRows(for: nearestMultiple)
        }
    }
}
