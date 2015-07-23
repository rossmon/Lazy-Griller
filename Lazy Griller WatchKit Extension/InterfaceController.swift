//
//  InterfaceController.swift
//  Lazy Griller WatchKit Extension
//
//  Created by Ross Montague on 7/22/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var probe1Label: WKInterfaceButton!
    @IBOutlet weak var probe2Label: WKInterfaceButton!
    @IBAction func probe1Pressed() {
        refresh()
    }
    
    @IBAction func probe2Pressed() {
        refresh()
    }
    
    var updating = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        refresh()
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        refresh()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        refresh()
    }
    
    private func refresh() {
        let defaults = NSUserDefaults(suiteName: "group.LazyDefaults")
        
        updateProbeTemp(1, temp: defaults!.doubleForKey("probe1LastTemp"))
        updateProbeTemp(2, temp: defaults!.doubleForKey("probe2LastTemp"))
    }
    
    private func updateProbeTemp(probe: Int, temp: Double?) {
        
        if probe == 1 {
            if let value = temp {
                if probe1Label != nil {
                    if value == 0 { probe1Label.setTitle("")}
                    else { probe1Label.setTitle(String(Int(round(value)))) }
                }
            }
        }
        else {
            if let value = temp {
                if probe2Label != nil {
                    if value == 0 { probe2Label.setTitle("")}
                    else { probe2Label.setTitle(String(Int(round(value)))) }
                }
            }
        }
    }
    
}
