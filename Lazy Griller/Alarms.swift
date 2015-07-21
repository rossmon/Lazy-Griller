//
//  Alarms.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/20/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import Foundation

class Alarms {
    
    private var probe1Alarm: Int
    private var probe2Alarm: Int
    
    class var sharedInstance : Alarms {
        struct Static {
            static let instance : Alarms = Alarms()
        }
        return Static.instance
    }
    
    
    init(probe1AlarmTemp: Int,probe2AlarmTemp: Int){
        self.probe1Alarm = probe1AlarmTemp
        self.probe2Alarm = probe2AlarmTemp
    }
    init() {
        probe1Alarm = Int()
        probe2Alarm = Int()
    }
    
    func getAlarmTemps()->(Int,Int) {
        return (probe1Alarm,probe2Alarm)
    }
    
    func setAlarmTemps(probe1AlarmTemp: Int,probe2AlarmTemp: Int) {
        self.probe1Alarm = probe1AlarmTemp
        self.probe2Alarm = probe2AlarmTemp
    }
    
    func setProbe1Alarm(probe1AlarmTemp: Int) {
        self.probe1Alarm = probe1AlarmTemp
    }
    
    func setProbe2Alarm(probe2AlarmTemp: Int) {
        self.probe2Alarm = probe2AlarmTemp
    }
    
}