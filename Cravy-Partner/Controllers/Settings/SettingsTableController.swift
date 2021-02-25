//
//  SettingsTableController.swift
//  Cravy-Partner
//
//  Created by Cravy on 21/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A structure representing a particular setting in the application.
struct Setting {
    var title: String
    var detail: String?
    
    enum SETTING: String {
        case account = "Account"
        case notifications = "Notifications"
        case privacyAndSecurity = "Privacy & Security"
        case helpAndSupport = "Help & Support"
        case about = "About"
    }
}

/// Handles the display of notification settings or privacy and security settings depending on the setting type provided.
class SettingsTableController: UITableViewController {
    private var settings: [String : [Setting]]!
    private var settingsSections: [String]!
    /// Determines the type of settings displayed.
    var setting: Setting.SETTING {
        set {
            if newValue == .notifications {
                settingsSections = K.Collections.notificationSectionTitles
                settings = [settingsSections[0]: K.Collections.notificationSettings, settingsSections[1] : K.Collections.notificationSettings]
            } else if newValue == .privacyAndSecurity {
                settingsSections = [K.UIConstant.twoFactorAuth]
                settings = [settingsSections[0] : K.Collections.twoFactorAuthenticationSettings]
            }
        }
        
        get {
            if settingsSections == K.Collections.notificationSectionTitles {
                return .notifications
            } else {
                return .privacyAndSecurity
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = setting.rawValue
        self.tableView.register(ToggleTableCell.self, forCellReuseIdentifier: K.Identifier.TableViewCell.toggleCell)
    }

    // MARK: - DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[settingsSections[section]]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.TableViewCell.toggleCell, for: indexPath) as! ToggleTableCell
        
        let settingTitle = settings[settingsSections[indexPath.section]]![indexPath.item].title
        let settingDetail = settings[settingsSections[indexPath.section]]![indexPath.item].detail
        
        if cell.detailTextLabel == nil {
            cell = ToggleTableCell(style: .subtitle, reuseIdentifier: K.Identifier.TableViewCell.toggleCell)
        }
        
        cell.setToggleCell(title: settingTitle, detail: settingDetail)

        return cell
    }
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.sectionWithToggle(title: settingsSections[section])
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
