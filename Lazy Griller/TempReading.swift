//
//  TempReading.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/7/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import Foundation

class TempReading {
    
    
    var device: String = ""
    var probe: Int? = 0
    var temp: Double? = 0.0
    var datetime: NSDate?
    
    init(device: String, probe: Int, temp: Double, datetime: NSDate){
        self.device = device
        self.probe = probe
        self.temp = temp
        self.datetime = datetime
    }
    init() {
        self.device = ""
        self.probe = 0
        self.temp = 0.0
        self.datetime = NSDate()
    }
    
}