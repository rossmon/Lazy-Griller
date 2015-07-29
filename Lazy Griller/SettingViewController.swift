//
//  SettingViewController.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/12/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import UIKit

@objc
protocol SettingViewControllerDelegate {
    
    optional func toggleTopPanelSetting()
    optional func collapseTopPanelSetting()
    optional func changeViewSetting(menu: String)
}

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: SettingViewControllerDelegate?
    
    var deviceSettingsViewController: DeviceSettingsViewController!
    
    var items: [String] = ["Device Settings", "Alarms"]
    var images: [String] = ["TempButton2.png","TempButton2.png"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func settingsTapped(sender: AnyObject) {
        delegate?.toggleTopPanelSetting?()
    }
    
    struct TableView {
        struct CellIdentifiers {
            static let SettingCell = "SettingCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
}
extension SettingViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.SettingCell, forIndexPath: indexPath) as! SettingCell
        cell.configureForCell(items[indexPath.row],image: images[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView,willDisplayCell cell: UITableViewCell,forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            deviceSettingsViewController = UIStoryboard.deviceSettingsViewController()
            deviceSettingsViewController!.delegate = self
            
            view.addSubview(deviceSettingsViewController!.view)
        }
    }
    
}

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var forwardImage: UIImageView!
    
    func configureForCell(rowName: String, image: String) {
        imageNameLabel.text = rowName
        settingImageView.image = UIImage(named: image)
        forwardImage.image = UIImage(named: "Forward-50.png")
    }
    
}

extension SettingViewController: TopPanelViewControllerDelegate {
    func settingSelected(menu: String) {
        //Logic to change views?
        
        delegate?.collapseTopPanelSetting?()
        delegate?.changeViewSetting?(menu)
    }
}

extension SettingViewController: DeviceSettingsViewControllerDelegate {
    func backPressed() {
        if deviceSettingsViewController != nil {
            self.deviceSettingsViewController!.view.removeFromSuperview()
            self.deviceSettingsViewController = nil
        }
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func deviceSettingsViewController() -> DeviceSettingsViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("DeviceSettingsViewController") as? DeviceSettingsViewController
    }
}


