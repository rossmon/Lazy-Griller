//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
protocol SidePanelViewControllerDelegate {
    func settingSelected(setting: SettingTab)
}

class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var settings: Array<SettingTab>!
    
    var delegate: SidePanelViewControllerDelegate?
    
    struct TableView {
        struct CellIdentifiers {
            static let SettingCell = "SettingCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.SettingCell, forIndexPath: indexPath) as! SettingCell
        cell.configureForSetting(settings[indexPath.row])
        return cell
    }
    
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedSetting = settings[indexPath.row]
        delegate?.settingSelected(selectedSetting)
    }
    
}

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var imageCreatorLabel: UILabel!
    
    func configureForSetting(setting: SettingTab) {
        settingImageView.image = setting.image
        imageNameLabel.text = setting.title
        imageCreatorLabel.text = setting.creator
    }
    
}