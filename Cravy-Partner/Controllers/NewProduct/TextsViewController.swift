//
//  TextsViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 28/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Handles the display of a textfield and a textview.
class TextsViewController: NPViewController {
    @IBOutlet weak var textStackView: TextStackView!
    private var productTitle: String?
    private var productDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textStackView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Keyboard delayed to be shown for 0.5 seconds
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            self.textStackView.beginResponder = true
        }
    }
        
    override func confirmNewProductInput(confirmationHandler: (Bool) -> ()) {
        confirmationHandler(textStackView.isValid)
        guard let title = productTitle, let description = productDescription else {return}
        //Call the delegate to confirm about the input
        self.productInfoDelegate?.didConfirmProductTitle(title)
        self.productInfoDelegate?.didConfirmProductDescription(description)
    }
}

//MARK:- CravyTextDelegate
extension TextsViewController: CravyTextDelegate {
    func textDidChange(on textField: UITextField, newText: String) {
        productTitle = newText
    }
    
    func textDidChange(on textView: UITextView, newText: String) {
        productDescription = newText
    }
}
