//
//  Helper.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

func availableFonts() {
    let fontFamilyNames = UIFont.familyNames

    for familyName in fontFamilyNames {

        print("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName)
        print("Font Names = [\(names)]")
    }
}
