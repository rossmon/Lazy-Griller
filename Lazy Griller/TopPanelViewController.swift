//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
protocol TopPanelViewControllerDelegate {
    func settingSelected(setting: SettingTab)
}

class TopPanelViewController: UIViewController {
    
    
    @IBOutlet weak var graphButton: UIButton!
    @IBAction func graphButtonPressed(sender: AnyObject) {
    }
    
    @IBOutlet weak var tempButton: UIButton!
    @IBAction func tempButtonPressed(sender: AnyObject) {
    }
    
    @IBOutlet weak var settingButton: UIButton!
    @IBAction func settingButtonPressed(sender: AnyObject) {
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var settings: Array<SettingTab>!
    
    var delegate: TopPanelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
}

// MARK: Table View Data Source

extension TopPanelViewController: UITableViewDataSource {
    
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

extension TopPanelViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedSetting = settings[indexPath.row]
        delegate?.settingSelected(selectedSetting)
    }
    
}

