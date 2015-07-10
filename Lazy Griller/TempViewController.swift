//
//  CenterViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
protocol TempViewControllerDelegate {
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class TempViewController: UIViewController {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    var delegate: TempViewControllerDelegate?
    
    // MARK: Button actions
    
    @IBAction func settingsTapped(sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }
    
}

extension TempViewController: SidePanelViewControllerDelegate {
    func settingSelected(setting: SettingTab) {
        imageView.image = setting.image
        titleLabel.text = setting.title
        
        delegate?.collapseSidePanels?()
    }
}