//
//  RecentReadings.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/12/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import Foundation

class RecentReading {
    
    private var probe1Temps: [TempReading]
    private var probe2Temps: [TempReading]
    private var probe1LastTemp: Double?
    private var probe2LastTemp: Double?
    
    class var sharedInstance : RecentReading {
        struct Static {
            static let instance : RecentReading = RecentReading()
        }
        return Static.instance
    }
    
    
    init(probe1Readings:[TempReading],probe2Readings:[TempReading]){
        self.probe1Temps = probe1Readings
        self.probe2Temps = probe2Readings
        self.probe1LastTemp = probe1Readings[0].temp
        self.probe2LastTemp = probe2Readings[0].temp
    }
    init() {
        probe1Temps = [TempReading]()
        probe2Temps = [TempReading]()
    }
    
    func getRecentReadings()->([TempReading],[TempReading]) {
        return (probe1Temps,probe2Temps)
    }
    
    func getLastTemp(probe: Int) -> Double? {
        
        var lastTemp = Double()
        if probe == 1 {
            if let value = self.probe1LastTemp {
                lastTemp = value
            }
        }
        else if probe == 2 {
            if let value = self.probe2LastTemp {
                lastTemp = value
            }
        }
        return lastTemp
    }
    
    func setRecentReadings(p1Readings:[TempReading],p2Readings:[TempReading]) {
        self.probe1Temps = p1Readings
        self.probe2Temps = p2Readings
        
        if p1Readings.count > 0 {
            self.probe1LastTemp = p1Readings[0].temp
        }
        if p2Readings.count > 0 {
            self.probe2LastTemp = p2Readings[0].temp
        }
    }
    
    func setProbe1Readings(readings:[TempReading]) {
        self.probe1Temps = readings
        self.probe1LastTemp = readings[0].temp
    }
    
    func setProbe2Readings(readings:[TempReading]) {
        self.probe2Temps = readings
        self.probe2LastTemp = readings[0].temp
    }
    
    func setLastTemp(probe: Int, temp: Double) {
        if probe == 1 {
            self.probe1LastTemp = temp
        }
        else if probe == 2 {
            self.probe2LastTemp = temp
        }
    }
    
}