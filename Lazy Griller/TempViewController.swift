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
    
    func checkForNewTemps()
    {
        RecentReading.sharedInstance.checkForNewTemps()
        
        updateDisplay()
        
        checkAlarms()
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
        Updates the temperature labels.
    
        @param readings An array of TempReading.
    */
    func updateDisplay(){
        
        var probe1reading = Int(round(RecentReading.sharedInstance.getLastTemp(1)!))
        var probe1readingString = String(probe1reading)
        if var label = probe1Label {
            label.setTitle(probe1readingString, forState: .Normal)
        }
        
        var probe2reading = Int(round(RecentReading.sharedInstance.getLastTemp(2)!))
        var probe2readingString = String(probe2reading)
        if var label = probe2Label {
            label.setTitle(probe2readingString, forState: .Normal)
        }
    }
    
    func checkAlarms(){
        
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
        
        if Alarms.sharedInstance.alarm2IsOn() {
            if let recReading = RecentReading.sharedInstance.getLastTemp(2) {
                if recReading >= Double(Alarms.sharedInstance.getAlarm2Temp()) {
                    if !alertOpen {
                        //PLAY THAT FUNKY MUSIC
                        println("Notification scheduled")
                        
                        
                        let filePath = NSBundle.mainBundle().pathForResource("Loud-Alarm", ofType: "mp3")
                        let fileURL = NSURL(fileURLWithPath: filePath!)
                        
                        AudioServicesCreateSystemSoundID(fileURL, &soundID)
                        AudioServicesPlaySystemSound(soundID)
                        
                        let alertController = UIAlertController(title: "Probe 2 Alarm", message:
                            "Temperature is over " + "\(Alarms.sharedInstance.getAlarm2Temp()) °F", preferredStyle: UIAlertControllerStyle.Alert)
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