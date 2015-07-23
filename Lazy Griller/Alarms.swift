//
//  Alarms.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/20/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import Foundation

class Alarms {
    
    private var probe1Alarm: Int = 135
    private var probe2Alarm: Int = 200
    private var probe1AlarmOn: Bool = false
    private var probe2AlarmOn: Bool = false
    
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
        
    }
    
    func getAlarm1Temp()->Int {
        return probe1Alarm
    }
    func getAlarm2Temp()->Int {
        return probe2Alarm
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
    
    func toggleProbe1Alarm() {
        if self.probe1AlarmOn {
            self.probe1AlarmOn = false
        }
        else {
            self.probe1AlarmOn = true
        }
    }
    func toggleProbe2Alarm() {
        if self.probe2AlarmOn {
            self.probe2AlarmOn = false
        }
        else {
            self.probe2AlarmOn = true
        }
    }
    func alarm1IsOn()->Bool {
        return probe1AlarmOn
    }
    func alarm2IsOn()->Bool {
        return probe2AlarmOn
    }
    
    func turnOnProbe1Alarm() {
        probe1AlarmOn = true
    }
    func turnOnProbe2Alarm() {
        probe2AlarmOn = true
    }
    func turnOffProbe1Alarm() {
        probe1AlarmOn = false
    }
    func turnOffProbe2Alarm() {
        probe2AlarmOn = false
    }
    
}