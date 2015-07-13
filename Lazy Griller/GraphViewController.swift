//
//  GraphViewController.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/12/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import UIKit

@objc
protocol GraphViewControllerDelegate {
    
    optional func toggleTopPanelGraph()
    optional func collapseTopPanelGraph()
    optional func changeViewGraph(menu: String)
}

class GraphViewController: UIViewController {
    
    var delegate: GraphViewControllerDelegate?
    
    var probe1Readings: [TempReading] = [TempReading]()
    var probe2Readings: [TempReading] = [TempReading]()
    var p1Temp: Double?
    var p2Temp: Double?
    var p1Time: NSDate?
    var p2Time: NSDate?
    
    @IBAction func settingsTapped(sender: AnyObject) {
        delegate?.toggleTopPanelGraph?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (probe1Readings,probe2Readings) = RecentReading.sharedInstance.getRecentReadings()
        
        setupGraph();

    }
    
    @IBOutlet weak var graphViewP1: GraphView!
    @IBOutlet weak var graphViewP2: GraphView!
    
    @IBOutlet weak var probe1LastTemp: UILabel!
    @IBOutlet weak var probe1LastTempTime: UILabel!
    @IBOutlet weak var probe2LastTemp: UILabel!
    @IBOutlet weak var probe2LastTempTime: UILabel!
    
    @IBOutlet weak var p1MaxTemp: UILabel!
    @IBOutlet weak var p1MinTemp: UILabel!
    @IBOutlet weak var p2MaxTemp: UILabel!
    @IBOutlet weak var p2MinTemp: UILabel!
    
    
    func setupGraph() {
        if probe1Readings.count > 1 {
            graphViewP1?.setPoints(sortTempsByAscendingTime(probe1Readings))
        }
        println(probe2Readings.count)
        if probe2Readings.count > 1 {
            graphViewP2?.setPoints(sortTempsByAscendingTime(probe2Readings))
        }
        
        if let value = graphViewP1 {
            if p1MaxTemp != nil {
                p1MaxTemp.text = "\(maxElement(value.probeTempPoints))"
            }
            if p1MinTemp != nil {
                p1MinTemp.text = "\(minElement(value.probeTempPoints))"
            }
        }
        if let value = graphViewP2 {
            if p2MaxTemp != nil {
                p2MaxTemp.text = "\(maxElement(value.probeTempPoints))"
            }
            if p2MinTemp != nil {
                p2MinTemp.text = "\(minElement(value.probeTempPoints))"
            }
        }
        
        self.p1Temp = probe1Readings.first?.temp
        self.p1Time = probe1Readings.first?.datetime
        self.p2Temp = probe2Readings.first?.temp
        self.p2Time = probe2Readings.first?.datetime
        
        if self.p1Time != nil
        {
            setTempTimes(1, date: self.p1Time!)
            
        }
        if self.p2Time != nil
        {
            setTempTimes(2, date: self.p2Time!)
            
        }
        
        setTempValues(self.p1Temp,probe2Temp:self.p2Temp)
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
    Sets the graphs latest times
    
    @param probe Probe NUmber.
    @param date Date the reading was read.
    */
    func setTempTimes(probe: Int, date: NSDate)
    {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        //println(NSTimeZone.localTimeZone())
        
        if probe == 1
        {
            if var label = probe1LastTempTime {
                label.text = dateFormatter.stringFromDate(date)
            }
        }
        else if probe == 2
        {
            if var label = probe2LastTempTime {
                label.text = dateFormatter.stringFromDate(date)
            }
        }
        
    }
    
    /**
    Sets the graphs latest temps
    
    @param probe1Temp Probe 1 Temperature
    @param probe1Temp Probe 2 Temperature
    */
    func setTempValues(probe1Temp: Double?, probe2Temp: Double?)
    {
        if probe1Temp != nil{
            var probe1reading = Int(round(probe1Temp!))

            if var label = probe1LastTemp {
                label.text = "\(probe1reading)"
            }
        }
        
        if probe2Temp != nil{
            var probe2reading = Int(round(probe2Temp!))

            if var label = probe2LastTemp {
                label.text = "\(probe2reading)"
            }
        }
    }
    
}



extension GraphViewController: TopPanelViewControllerDelegate {
    func settingSelected(menu: String) {
        //Logic to change views?
        
        delegate?.collapseTopPanelGraph?()
        delegate?.changeViewGraph?(menu)
    }
}


