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
    
    var textEntryViewController: TextEntryViewController!
    
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

extension DeviceSettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            textEntryViewController = UIStoryboard.textEntryViewController()
            textEntryViewController!.delegate = self
            
            view.addSubview(textEntryViewController!.view)
            
            textEntryViewController!.titleLabel.text = "Device Name"
            textEntryViewController!.textEntryField.text = Settings.sharedInstance.getDeviceName()
        }
        else if indexPath.row == 1 {
            textEntryViewController = UIStoryboard.textEntryViewController()
            textEntryViewController!.delegate = self
            
            view.addSubview(textEntryViewController!.view)
            
            textEntryViewController!.titleLabel.text = "Device Name"
        }
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
    
    func setDeviceName(name: String) {
        deviceNameLabel.text = name
    }
    
}

extension DeviceSettingsViewController: TextEntryViewControllerDelegate {
    func backPressed() {
        if textEntryViewController != nil {
            self.textEntryViewController!.view.removeFromSuperview()
            self.textEntryViewController = nil
        }
        
        self.tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.DeviceSettingCell, forIndexPath: NSIndexPath(forRow: 0, inSection: 0)).setDeviceName(Settings.sharedInstance.getDeviceName())
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func textEntryViewController() -> TextEntryViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TextEntryViewController") as? TextEntryViewController
    }
}

