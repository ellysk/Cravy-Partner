//
//  TextInputController.swift
//  Cravy-Partner
//
//  Created by Cravy on 26/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

class TextInputController: NPViewController {
    @IBOutlet weak var textStackView: TextStackView!
    private var productTitle: String?
    private var productDescription: String?
    
    init() {
        super.init(nibName: "TextInputController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
extension TextInputController: CravyTextDelegate {
    func textDidChange(on textField: UITextField, newText: String) {
        productTitle = newText
    }
    
    func textDidChange(on textView: UITextView, newText: String) {
        productDescription = newText
    }
}
