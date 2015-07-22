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
    
    class var sharedInstance : RecentReading {
        struct Static {
            static let instance : RecentReading = RecentReading()
        }
        return Static.instance
    }
    
    
    init(probe1Readings:[TempReading],probe2Readings:[TempReading]){
        self.probe1Temps = probe1Readings
        self.probe2Temps = probe2Readings
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
            if probe1Temps.count > 0 {
                lastTemp = probe1Temps[0].temp!
            }
        }
        else if probe == 2 {
            if probe2Temps.count > 0 {
                lastTemp = probe2Temps[0].temp!
            }
        }
        return lastTemp
    }
    
    func setRecentReadings(p1Readings:[TempReading],p2Readings:[TempReading]) {
        self.probe1Temps = p1Readings
        self.probe2Temps = p2Readings
    }
    
    func setProbe1Readings(readings:[TempReading]) {
        self.probe1Temps = readings
    }
    
    func setProbe2Readings(readings:[TempReading]) {
        self.probe2Temps = readings
    }
    
}