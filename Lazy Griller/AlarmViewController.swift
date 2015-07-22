//
//  AlarmViewController.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/12/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//


import UIKit

@objc
protocol AlarmViewControllerDelegate {
    func backSelected()
    func probeNumSelected() -> Int
}

class AlarmViewController: UIViewController {
    
    var delegate: AlarmViewControllerDelegate?
    var isAlarmViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if delegate?.probeNumSelected() == 1 {
            if Alarms.sharedInstance.alarm1IsOn() {
                if !isAlarmViewShowing {
                    UIView.transitionFromView(noAlarmView,
                        toView: alarmView,
                        duration: 0.0,
                        options: UIViewAnimationOptions.ShowHideTransitionViews,
                        completion:nil)
                    
                    isAlarmViewShowing = true
                }
                alarmTemp.text = "\(Alarms.sharedInstance.getAlarm1Temp())"
            }
        }
        else
        {
            if Alarms.sharedInstance.alarm2IsOn() {
                if !isAlarmViewShowing {
                    UIView.transitionFromView(noAlarmView,
                        toView: alarmView,
                        duration: 0.0,
                        options: UIViewAnimationOptions.ShowHideTransitionViews,
                        completion:nil)
                    
                    isAlarmViewShowing = true
                }
                
                alarmTemp.text = "\(Alarms.sharedInstance.getAlarm2Temp())"

            }


        }
        
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        delegate?.backSelected()
    }
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var alarmTemp: UILabel!
    
    @IBOutlet weak var currentTemp: UILabel!
    
    @IBOutlet weak var noAlarmView: UIView!
    @IBOutlet weak var alarmView: UIView!
    
    @IBAction func counterViewTap(gesture:UITapGestureRecognizer?) {
        if (isAlarmViewShowing) {
            alarmTemp.text = "\(Alarms.sharedInstance.getAlarm1Temp())"
            //hide alarmView
            UIView.transitionFromView(alarmView,
                toView: noAlarmView,
                duration: 0.2,
                options: UIViewAnimationOptions.TransitionFlipFromLeft
                    | UIViewAnimationOptions.ShowHideTransitionViews,
                completion:nil)
            
            Alarms.sharedInstance.toggleProbe1Alarm()
        } else {
            alarmTemp.text = "\(Alarms.sharedInstance.getAlarm2Temp())"
            //show alarmView
            UIView.transitionFromView(noAlarmView,
                toView: alarmView,
                duration: 0.2,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews,
                completion: nil)
        }
        isAlarmViewShowing = !isAlarmViewShowing
        Alarms.sharedInstance.toggleProbe2Alarm()
    }
}


