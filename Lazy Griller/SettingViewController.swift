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

class SettingViewController: UIViewController {
    
    var delegate: SettingViewControllerDelegate?
    
    @IBAction func settingsTapped(sender: AnyObject) {
        delegate?.toggleTopPanelSetting?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension SettingViewController: TopPanelViewControllerDelegate {
    func settingSelected(menu: String) {
        //Logic to change views?
        
        delegate?.collapseTopPanelSetting?()
        delegate?.changeViewSetting?(menu)
    }
}


