//
//  SettingsController.swift
//  Cravy-Partner
//
//  Created by Cravy on 21/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Handles the display of the application available settings.
class SettingsController: UIViewController {
    @IBOutlet weak var noticeView: RoundView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var policyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        additionalLayoutSetup()
        settingsTableView.register(BasicTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.basicCell)
    }
    
    private func additionalLayoutSetup() {
        noticeView.castShadow = true
        noticeLabel.text = K.UIConstant.settingsAlertMessage
        policyButton.titleLabel?.text = K.UIConstant.termsAndAgreement
        policyButton.titleLabel?.underline()
    }
}

//MARK: - UITableView DataSource
extension SettingsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return K.Collections.settingsTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.basicCell, for: indexPath) as! BasicTableCell
        cell.setBasicCell(image: K.Collections.settingsImages[indexPath.row], title: K.Collections.settingsTitles[indexPath.row])
        
        return cell
    }
}

//MARK:- UITableView Delegate
extension SettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
