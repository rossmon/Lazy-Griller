//
//  TempViewController.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/12/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//


import UIKit
import AVFoundation

@objc
protocol TempViewControllerDelegate {
    
    optional func toggleTopPanelTemps()
    optional func collapseTopPanelTemps()
    optional func changeViewTemps(menu: String)
    optional func handlePanGesture(recognizer: UIPanGestureRecognizer)
}

extension NSData {
    var htmlData2String:String {
        return NSAttributedString(data: self, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding], documentAttributes: nil, error: nil)!.string
    }
}

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate?) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare!) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare : NSDate?) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare!) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func addDays(daysToAdd : Int) -> NSDate
    {
        var secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        var dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd : Int) -> NSDate
    {
        var secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        var dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    func addMinutes(minutesToAdd : Int) -> NSDate
    {
        var secondsInMinutes : NSTimeInterval = Double(minutesToAdd) * 60
        var dateWithMinutesAdded : NSDate = self.dateByAddingTimeInterval(secondsInMinutes)
        
        //Return Result
        return dateWithMinutesAdded
    }
}


class TempViewController: UIViewController {
    
    var delegate: TempViewControllerDelegate?
    
    @IBAction func settingsTapped(sender: AnyObject) {
        
        delegate?.toggleTopPanelTemps?()
    }
    
    @IBAction func panHandle(sender: UIPanGestureRecognizer) {
        delegate?.handlePanGesture?(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        checkForNewTemps()
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("checkForNewTemps"), userInfo: nil, repeats: true)
    }
    
    //Struct for program variables. Should this be a class?
    struct MyVariables {
        static var htmldata = ""
        static var myDevice = "Device1"
        static var graphTimeHistory = 3
        static var url = NSURL(string: "http://wifi-grill.herokuapp.com/temps")
    }
    
    //Variables for the most recent times and temperatures
    var p1Temp: Double?
    var p2Temp: Double?
    var p1Time: NSDate?
    var p2Time: NSDate?
    
    var probeSelected: Int = 1
    var defaultAlarmTemp = 200
    
    var audioPlayer = AVAudioPlayer()
    var soundID:SystemSoundID = 0
    var alertOpen = false
    
    var alarmViewController: AlarmViewController!
    
    @IBAction func probe1ButtonPressed(sender: AnyObject) {
        
        if probeSelected != 1 {
            probeSelected = 1
        }
        alarmViewController = UIStoryboard.alarmViewController()
        alarmViewController!.delegate = self
        
        view.addSubview(alarmViewController!.view)
        
        if alarmViewController != nil{
            alarmViewController.alarmLabel.text = "Probe 1 Alarm Temperature"
            //INSERT ASSIGNMENT OF MOST RECENT READING
            var probe1reading = Int(round(RecentReading.sharedInstance.getLastTemp(1)!))
            var probe1String = String(probe1reading)
            alarmViewController.currentTemp.text = probe1String + " °F"
        }
    }
    
    @IBAction func probe2ButtonPressed(sender: AnyObject) {
        if probeSelected != 2 {
            probeSelected = 2
        }
        
        alarmViewController = UIStoryboard.alarmViewController()
        alarmViewController!.delegate = self
        
        view.addSubview(alarmViewController!.view)
        
        if alarmViewController != nil{
            alarmViewController.alarmLabel.text = "Probe 2 Alarm Temperature"
            var probe2reading = Int(round(RecentReading.sharedInstance.getLastTemp(2)!))
            var probe2String = String(probe2reading)
            alarmViewController.currentTemp.text = probe2String + " °F"
        }
    }
    
    
    @IBOutlet weak var probe1Label: UIButton!
    @IBOutlet weak var probe2Label: UIButton!
    
    
    /**
        Grabs temperature readings from the server located at the url addess.
    */
    func get_temps(){
        let htmldata = ""
        let task = NSURLSession.sharedSession().dataTaskWithURL(MyVariables.url!)
            {
                data, response, error in
                if data != nil {
                    let htmldata = NSString(data: data, encoding:  NSUTF8StringEncoding)
                    MyVariables.htmldata = htmldata! as String
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
            if readings[index].device == MyVariables.myDevice
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
        Prints the readings from an array of TempReading to the log.
    
        @param readings An array of TempReading.
    */
    func printReadings(readings:[TempReading]) {
        for index in 0..<readings.count {
            print(readings[index].device)
            print(" - ")
            print(readings[index].probe)
            print(" - ")
            print(readings[index].temp)
            print(" - ")
            println(readings[index].datetime)
        }
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
    
    /**
        Updates the temperature labels.
    
        @param readings An array of TempReading.
    */
    func updateDisplay(temperatureTable: [TempReading]){
        
        var (probe1Readings,probe2Readings) = separateProbe1andProbe2Readings(sortTempsByDescendingTime(getDeviceTemps(MyVariables.myDevice, readings: temperatureTable)))
        
        self.p1Temp = probe1Readings.first?.temp
        self.p1Time = probe1Readings.first?.datetime
        
        self.p2Temp = probe2Readings.first?.temp
        self.p2Time = probe2Readings.first?.datetime
        
        setTempValues(self.p1Temp,probe2Temp:self.p2Temp)
    }
    
    /**
        Sets the temperature values for the labels.
    
        @param prob1Temp The temperature for probe 1.
        @param prob2Temp The temperature for probe 2.
    */
    func setTempValues(probe1Temp: Double?, probe2Temp: Double?)
    {
        if probe1Temp != nil{
            var probe1reading = Int(round(probe1Temp!))
            var probe1readingString = String(probe1reading)
            if var label = probe1Label {
                label.setTitle(probe1readingString, forState: .Normal)
            }
        }
        
        if probe2Temp != nil{
            var probe2reading = Int(round(probe2Temp!))
            var probe2readingString:String = String(probe2reading)
            if var label = probe2Label {
                label.setTitle(probe2readingString, forState: .Normal)
            }
        }
    }
    
    func checkForNewTemps(){
        get_temps()
        
        let components = MyVariables.htmldata.componentsSeparatedByString("<td>")
        
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
        
        updateDisplay(temperatureTable)
        
        let (probe1GraphReadings,probe2GraphReadings) = getRecentReadings(temperatureTable)
        
        RecentReading.sharedInstance.setRecentReadings(probe1GraphReadings, p2Readings: probe2GraphReadings)
        

        if let lastTemp = RecentReading.sharedInstance.getLastTemp(probeNumSelected()) {
            if alarmViewController != nil {
                //alarmViewController.currentTemp.text = "\(lastTemp)"
                var probereading = Int(round(lastTemp))
                var probeString = String(probereading)
                alarmViewController.currentTemp.text = probeString + " °F"
            }
        }

        
        if Alarms.sharedInstance.alarm1IsOn() {
            if let recReading = RecentReading.sharedInstance.getLastTemp(1) {
                if recReading >= Double(Alarms.sharedInstance.getAlarm1Temp()) {
                    if !alertOpen {
                        //PLAY THAT FUNKY MUSIC
                        println("Notification scheduled")
                        
                        
                        let filePath = NSBundle.mainBundle().pathForResource("Loud-Alarm", ofType: "mp3")
                        let fileURL = NSURL(fileURLWithPath: filePath!)
                        
                        AudioServicesCreateSystemSoundID(fileURL, &soundID)
                        AudioServicesPlaySystemSound(soundID)
                        
                        let alertController = UIAlertController(title: "Probe 1 Alarm", message:
                            "Temperature is over " + "\(Alarms.sharedInstance.getAlarm1Temp()) °F", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: handler))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        alertOpen = true

                    }
                }
            }
        }
    }
    
    func handler(act:UIAlertAction!) {
        AudioServicesDisposeSystemSoundID(soundID)
        println("User tapped \(act.title)")
        alertOpen = false
    }
    
    
    /**
        Returns two TempReading arrays for the most recent of each probe 1 and probe 2 readings. The time history is set by graphTimeHistory.
    
        @param readings An array of TempReading.
        @return A tuple of TempReading arrays for probe 1 and probe 2 respectively.
    */
    func getRecentReadings(tempTable: [TempReading]) -> ([TempReading],[TempReading])
    {
        var (probe1Readings,probe2Readings) = separateProbe1andProbe2Readings(sortTempsByDescendingTime(getDeviceTemps(MyVariables.myDevice, readings: tempTable)))
        var mostRecentTime: NSDate? = probe1Readings.first?.datetime
        
        if let p2mostRecentTime = probe2Readings.first?.datetime {
            if (mostRecentTime!.isLessThanDate(p2mostRecentTime))
            {
                mostRecentTime = p2mostRecentTime
            }
        }
        
        var cutOffTime = mostRecentTime?.addHours(-1*MyVariables.graphTimeHistory)
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
    
}


extension TempViewController: TopPanelViewControllerDelegate {
    func settingSelected(menu: String) {
        //Logic to change views?
        
        delegate?.collapseTopPanelTemps?()
        delegate?.changeViewTemps?(menu)
    }
}

extension TempViewController: AlarmViewControllerDelegate {
    func backSelected() {
        if alarmViewController != nil {
            self.alarmViewController!.view.removeFromSuperview()
            self.alarmViewController = nil
        }
    }
    
    func probeNumSelected() -> Int {
        return probeSelected
        
    }
    
    
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func alarmViewController() -> AlarmViewController? {
            return mainStoryboard().instantiateViewControllerWithIdentifier("AlarmViewController") as? AlarmViewController
    }
}