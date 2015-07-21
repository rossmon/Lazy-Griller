//
//  AlarmViewController.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/12/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//


import UIKit

@objc
protocol AlarmViewControllerDelegate {
    func backSelected()
}

class AlarmViewController: UIViewController {
    
    var delegate: AlarmViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setLabel(text: String) {
        println(text)
        alarmLabel.text = text
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        delegate?.backSelected()
    }
    @IBOutlet weak var alarmLabel: UILabel!
}


