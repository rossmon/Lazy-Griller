//
//  Settings.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/28/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import Foundation

class Settings {
    
    private var deviceName: String = ""
    
    class var sharedInstance : Settings {
        struct Static {
            static let instance : Settings = Settings()
        }
        return Static.instance
    }
    
    
    init(deviceName: String){
        self.deviceName = deviceName
    }
    init() {
        self.deviceName = "Default Name"
    }
    
    func getDeviceName() -> String {
        return self.deviceName
    }
    func setDeviceName(name: String) {
        self.deviceName = name
    }
}
