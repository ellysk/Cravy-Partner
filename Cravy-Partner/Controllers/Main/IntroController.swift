//
//  IntroController.swift
//  Cravy-Partner
//
//  Created by Cravy on 16/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Displays two UILabels in a vertical stack view where the title label and detail label are arranged respectively.
class IntroController: UIViewController {
    private var detailStackView: UIStackView!
    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    private var introTitle: String
    private var introDetail: String
    
    init(title: String, detail: String) {
        self.introTitle = title
        self.introDetail = detail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIntroControllerLayout()
    }
    
    private func setIntroControllerLayout() {
        setTitleLabel(title: introTitle)
        setDetailLabel(detail: introDetail)
        arrangeLabels()
    }
    
    
    private func setTitleLabel(title: String) {
        titleLabel = UILabel()
        titleLabel.text = introTitle
        titleLabel.font = UIFont.heavy.large
        titleLabel.underline()
        titleLabel.textAlignment = .center
        titleLabel.textColor = K.Color.light
    }
    
    private func setDetailLabel(detail: String) {
        detailLabel = UILabel()
        detailLabel.text = introDetail
        detailLabel.font = UIFont.medium.medium
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.textColor = K.Color.light
    }
    
    private func arrangeLabels() {
        if detailStackView == nil {
            detailStackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
            detailStackView.set(axis: .vertical, distribution: .fill)
            
            self.view.addSubview(detailStackView)
            detailStackView.translatesAutoresizingMaskIntoConstraints = false
            detailStackView.centerYAnchor(to: self.view)
            detailStackView.HConstraint(to: self.view)
        }
    }
}
