//
//  TextEntry.swift
//  Lazy Griller
//
//  Created by Ross Montague on 8/14/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol TextEntryViewControllerDelegate {
    
    optional func backPressed()
}

class TextEntryViewController: UIViewController {

    var delegate: TextEntryViewControllerDelegate?
    
    @IBAction func backPressed(sender: AnyObject) {
        saveDeviceName()

        delegate?.backPressed?()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textEntryField: UITextField!
    
    @IBAction func tappedView(sender: AnyObject) {
        textEntryField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func saveDeviceName() {
        Settings.sharedInstance.setDeviceName(textEntryField.text)
    }
}




