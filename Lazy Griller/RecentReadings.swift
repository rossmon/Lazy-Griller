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
    private var htmldata = ""
    private var myDevice = "Device1"
    private var graphTimeHistory = 3
    private var url = NSURL(string: "http://wifi-grill.herokuapp.com/temps")
    
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
    
    
    
    
    
    /**
    Grabs temperature readings from the server located at the url addess.
    */
    func get_temps(){
        let htmldata = ""
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!)
            {
                data, response, error in
                if data != nil {
                    let htmldata = NSString(data: data, encoding:  NSUTF8StringEncoding)
                    self.htmldata = htmldata! as String
                }
        }
        task.resume()
    }
    
    /**
    Gets the readings from an array of TempReading that match the given device id.
    
    @param device The device ID.
    @param readings An array of TempReading.
    @return An array of TempReading that match the device ID.
    */
    func getDeviceTemps(device:String,readings:[TempReading]) -> [TempReading] {
        
        var deviceReadings = [TempReading]()
        
        for index in stride(from: 0, to: readings.count, by: 1) {
            if readings[index].device == myDevice
            {
                deviceReadings.append(readings[index])
            }
        }
        return deviceReadings
    }
    
    /**
    Sorts the readings from an array of TempReading by descending measurement time.
    
    @param readings An array of TempReading.
    @return An array of TempReading sorted by descending time.
    */
    func sortTempsByDescendingTime(readings:[TempReading]) -> [TempReading]
    {
        var readings2 = readings
        readings2.sort({$0.datetime!.isGreaterThanDate($1.datetime)  == true})
        return readings2;
    }
    
    /**
    Sorts the readings from an array of TempReading by ascending measurement time.
    
    @param readings An array of TempReading.
    @return An array of TempReading sorted by ascending time.
    */
    func sortTempsByAscendingTime(readings:[TempReading]) -> [TempReading]
    {
        var readings2 = readings
        readings2.sort({$0.datetime!.isLessThanDate($1.datetime)  == true})
        return readings2;
    }
    
    /**
    Returns two TempReading arrays for each probe 1 and probe 2 readings.
    
    @param readings An array of TempReading.
    @return A tuple of TempReading arrays for probe 1 and probe 2 respectively.
    */
    func separateProbe1andProbe2Readings(readings: [TempReading]) -> ([TempReading],[TempReading])
    {
        var probe1Readings = [TempReading]()
        var probe2Readings = [TempReading]()
        
        for index in stride(from: 0, to: readings.count, by: 1) {
            if readings[index].probe == 1
            {
                probe1Readings.append(readings[index])
            }
            if readings[index].probe == 2
            {
                probe2Readings.append(readings[index])
            }
        }
        return (probe1Readings,probe2Readings)
    }


    func updateGroupData() {
        var defaults = NSUserDefaults(suiteName: "group.LazyDefaults")
        defaults!.setBool(Alarms.sharedInstance.alarm1IsOn(), forKey: "probe1Alarm")
        defaults!.setBool(Alarms.sharedInstance.alarm2IsOn(), forKey: "probe2Alarm")
        defaults!.setInteger(Alarms.sharedInstance.getAlarm1Temp(), forKey: "probe1AlarmTemp")
        defaults!.setInteger(Alarms.sharedInstance.getAlarm2Temp(), forKey: "probe2AlarmTemp")
        
        defaults!.setDouble(RecentReading.sharedInstance.getLastTemp(1)!, forKey: "probe1LastTemp")
        defaults!.setDouble(RecentReading.sharedInstance.getLastTemp(2)!, forKey: "probe2LastTemp")
        defaults?.synchronize()
    }
    
    /**
    Returns two TempReading arrays for the most recent of each probe 1 and probe 2 readings. The time history is set by graphTimeHistory.
    
    @param readings An array of TempReading.
    @return A tuple of TempReading arrays for probe 1 and probe 2 respectively.
    */
    func getRecentReadings(tempTable: [TempReading]) -> ([TempReading],[TempReading])
    {
        var (probe1Readings,probe2Readings) = separateProbe1andProbe2Readings(sortTempsByDescendingTime(getDeviceTemps(myDevice, readings: tempTable)))
        var mostRecentTime: NSDate? = probe1Readings.first?.datetime
        
        if let p2mostRecentTime = probe2Readings.first?.datetime {
            if (mostRecentTime!.isLessThanDate(p2mostRecentTime))
            {
                mostRecentTime = p2mostRecentTime
            }
        }
        
        var cutOffTime = mostRecentTime?.addHours(-1*graphTimeHistory)
        var probe1GraphReadings: [TempReading] = [TempReading]()
        var probe2GraphReadings: [TempReading] = [TempReading]()
        
        for index in stride(from: 0, to: probe1Readings.count, by: 1) {
            if(probe1Readings[index].datetime!.isGreaterThanDate(cutOffTime!))
            {
                probe1GraphReadings.append(probe1Readings[index])
            }
        }
        for index in stride(from: 0, to: probe2Readings.count, by: 1) {
            if(probe2Readings[index].datetime!.isGreaterThanDate(cutOffTime!))
            {
                probe2GraphReadings.append(probe2Readings[index])
            }
        }
        
        return (probe1GraphReadings,probe2GraphReadings)
    }
    
    func checkForNewTemps(){
        get_temps()
        
        let components = htmldata.componentsSeparatedByString("<td>")
        
        var tempTable = [String](count:components.count, repeatedValue:"")
        for index in 0..<components.count {
            let newstring = components[index].stringByReplacingOccurrencesOfString("</td>", withString: "").stringByReplacingOccurrencesOfString("<tr>", withString: "").stringByReplacingOccurrencesOfString("</tr>", withString: "")
            let newstring2=(newstring as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            tempTable[index]=(newstring as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        var temperatureTable = [TempReading]()
        let periodComponents = NSDateComponents()
        periodComponents.hour = -5
        
        for index in stride(from: 1, to: tempTable.count, by: 4) {
            
            let device: String
            if (tempTable[index] == "")
            {
                device = "EMPTY"
            }
            else {device = tempTable[index]}
            
            let probe: Int
            if (tempTable[index+1] == "")
            {
                probe = 0
            }
            else {probe = tempTable[index+1].toInt()!}
            
            let temperature: Double
            if (tempTable[index+2] == "")
            {
                temperature = 0.0
            }
            else {temperature = tempTable[index+2].toDouble()!}
            
            let dateFormatter = NSDateFormatter()
            let date: NSDate
            if (tempTable[index+3] == "")
            {
                date = dateFormatter.dateFromString("")!
            }
            else {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                var index1 = advance(tempTable[index+3].endIndex, -4)
                date = dateFormatter.dateFromString(tempTable[index+3].substringToIndex(index1))!.dateByAddingTimeInterval(-18000)
            }
            
            let eachTempReading = TempReading(device:device,probe:probe,temp:temperature,datetime:date)
            temperatureTable.append(eachTempReading)
        }
        
        let (probe1GraphReadings,probe2GraphReadings) = getRecentReadings(temperatureTable)
        
        setRecentReadings(probe1GraphReadings, p2Readings: probe2GraphReadings)

        updateGroupData()
    }
    
}