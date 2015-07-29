//
//  SettingViewController.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/12/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import UIKit

@objc
protocol DeviceSettingsViewControllerDelegate {
    
    optional func backPressed()
}

class DeviceSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: DeviceSettingsViewControllerDelegate?
    
    var items: [String] = ["Device Name"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backSelected(sender: AnyObject) {
        delegate?.backPressed?()
    }
    
    struct TableView {
        struct CellIdentifiers {
            static let DeviceSettingCell = "DeviceName"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        
    }
    
    
    
}
extension DeviceSettingsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.DeviceSettingCell, forIndexPath: indexPath) as! DeviceSettingCell
        cell.configureForCell(items[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView,willDisplayCell cell: UITableViewCell,forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
}

class DeviceSettingCell: UITableViewCell {
    
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var forwardImage: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    func configureForCell(rowName: String) {
        imageNameLabel.text = rowName
        forwardImage.image = UIImage(named: "Forward-50.png")
        deviceNameLabel.text = Settings.sharedInstance.getDeviceName()
    }
    
}

