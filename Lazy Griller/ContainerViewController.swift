//
//  ContainerViewController.swift
//  Lazy Griller
//
//  Created by Ross Montague on 7/12/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//


import UIKit
import QuartzCore

enum SlideOutState {
    case TopPanelExpanded
    case TopPanelCollapsed
}

enum CurrentView {
    case Temperatures
    case Graphs
    case Settings
}

class ContainerViewController: UIViewController {
    
    var tempViewController: TempViewController!
    var topPanelViewController: TopPanelViewController?
    var graphViewController: GraphViewController!
    var settingViewController: SettingViewController!
    
    var currentState: SlideOutState = .TopPanelCollapsed {
        didSet {
            let shouldShowShadow = currentState != .TopPanelCollapsed
            if currentView == .Temperatures {
                showShadowForTempViewController(shouldShowShadow)
            }
            else if currentView == .Graphs {
                showShadowForGraphViewController(shouldShowShadow)
            }
            else if currentView == .Settings {
                showShadowForSettingViewController(shouldShowShadow)
            }
        }
    }
    
    var currentView: CurrentView = .Temperatures
    
    
    
    var tempPanelExpandedOffset: CGFloat =  150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempViewController = UIStoryboard.tempViewController()
        tempViewController.delegate = self
        
        view.addSubview(tempViewController.view)
        
        currentView = .Temperatures
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func topPanelViewController() -> TopPanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TopPanelViewController") as? TopPanelViewController
    }
    
    class func tempViewController() -> TempViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TempViewController") as? TempViewController
    }
    
    class func graphViewController() -> GraphViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("GraphViewController") as? GraphViewController
    }
    class func settingViewController() -> SettingViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("SettingViewController") as? SettingViewController
    }
    
}
extension ContainerViewController: UIGestureRecognizerDelegate {
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromToptoBottom = (recognizer.velocityInView(view).y > 0)
        let gestureIsDraggingFromBottomtoTop = (recognizer.velocityInView(view).y < 0)
        
        switch(recognizer.state) {
        case .Began:
            if (currentState == .TopPanelCollapsed) {
                if (gestureIsDraggingFromToptoBottom) {
                    if currentView == .Temperatures {
                        addTopPanelViewControllerTemps()
                        showShadowForTempViewController(true)
                    }
                    else if currentView == .Graphs {
                        addTopPanelViewControllerGraph()
                        showShadowForGraphViewController(true)
                    }
                    else if currentView == .Settings {
                        addTopPanelViewControllerSetting()
                        showShadowForSettingViewController(true)
                    }
                }
            }
            else if (currentState == .TopPanelExpanded) {
                if (gestureIsDraggingFromBottomtoTop) {
                    if currentView == .Temperatures {
                        animateTopPanelTemps(shouldExpand: false)
                    }
                    else if currentView == .Graphs {
                        animateTopPanelGraph(shouldExpand: false)
                    }
                    else if currentView == .Settings {
                        animateTopPanelSetting(shouldExpand: false)
                    }
                }
            }
            
        case .Changed:
            if gestureIsDraggingFromToptoBottom {
                if currentView == .Temperatures {
                    if recognizer.translationInView(view).y < 150 {
                        tempViewController.view.center.y = tempViewController.view.center.y + recognizer.translationInView(view).y
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                    else {
                        tempViewController.view.center.y = tempViewController.view.center.y + 150
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                }
                else if currentView == .Graphs {
                    if recognizer.translationInView(view).y < 150 {
                        graphViewController.view.center.y = tempViewController.view.center.y + recognizer.translationInView(view).y
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                    else {
                        graphViewController.view.center.y = tempViewController.view.center.y + 150
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                }
                else if currentView == .Settings {
                    if recognizer.translationInView(view).y < 150 {
                        settingViewController.view.center.y = tempViewController.view.center.y + recognizer.translationInView(view).y
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                    else {
                        settingViewController.view.center.y = tempViewController.view.center.y + 150
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                }
            }
            else if gestureIsDraggingFromBottomtoTop {
                if currentView == .Temperatures {
                    if recognizer.translationInView(view).y < 150 {
                        tempViewController.view.center.y = tempViewController.view.center.y - recognizer.translationInView(view).y
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                    else {
                        tempViewController.view.center.y = tempViewController.view.center.y - 150
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                }
                else if currentView == .Graphs {
                    if recognizer.translationInView(view).y < 150 {
                        graphViewController.view.center.y = tempViewController.view.center.y - recognizer.translationInView(view).y
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                    else {
                        graphViewController.view.center.y = tempViewController.view.center.y - 150
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                }
                else if currentView == .Settings {
                    if recognizer.translationInView(view).y < 150 {
                        settingViewController.view.center.y = tempViewController.view.center.y - recognizer.translationInView(view).y
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                    else {
                        settingViewController.view.center.y = tempViewController.view.center.y - 150
                        recognizer.setTranslation(CGPointZero, inView: view)
                    }
                }
            }

            
        case .Ended:
            if gestureIsDraggingFromToptoBottom {
                if (tempViewController != nil) {
                    // animate the side panel open or closed based on whether the view has moved more or less than halfway
                    let hasMovedGreaterThanHalfway = recognizer.view!.center.y > 0 //view.bounds.size.height
                    animateTopPanelTemps(shouldExpand: hasMovedGreaterThanHalfway)
                } else if (graphViewController != nil) {
                    let hasMovedGreaterThanHalfway = recognizer.view!.center.y < 0
                    animateTopPanelGraph(shouldExpand: hasMovedGreaterThanHalfway)
                } else if (settingViewController != nil) {
                    let hasMovedGreaterThanHalfway = recognizer.view!.center.y < 0
                    animateTopPanelSetting(shouldExpand: hasMovedGreaterThanHalfway)
                }
            }
            else if gestureIsDraggingFromBottomtoTop {
                if (tempViewController != nil) && (topPanelViewController != nil){
                    animateTopPanelTemps(shouldExpand: false)
                } else if (graphViewController != nil) && (topPanelViewController != nil) {
                    animateTopPanelGraph(shouldExpand: false)
                } else if (settingViewController != nil) && (topPanelViewController != nil) {
                    animateTopPanelSetting(shouldExpand: false)
                }
            }
            
        default:
            break
        }
    }
    
}
extension ContainerViewController: TempViewControllerDelegate {
    
    func toggleTopPanelTemps() {
        let notAlreadyExpanded = (currentState != .TopPanelExpanded)
        
        if notAlreadyExpanded {
            addTopPanelViewControllerTemps()
        }
        
        animateTopPanelTemps(shouldExpand: notAlreadyExpanded)
    }
    
    func addChildTopPanelControllerTemps(topPanelController: TopPanelViewController) {
        topPanelController.delegate = tempViewController
        
        view.insertSubview(topPanelController.view, atIndex: 0)
        
        addChildViewController(topPanelController)
        topPanelController.didMoveToParentViewController(self)
    }
    
    func addTopPanelViewControllerTemps() {
        if (topPanelViewController == nil) {
            topPanelViewController = UIStoryboard.topPanelViewController()
            addChildTopPanelControllerTemps(topPanelViewController!)
        }
    }
    
    func animateTopPanelTemps(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .TopPanelExpanded
 
            animatetempPanelYPositionTemps(targetPosition: /*CGRectGetHeight(tempViewController.view.frame)*/ tempPanelExpandedOffset)
            
        } else {
            animatetempPanelYPositionTemps(targetPosition: 0) { _ in
                self.currentState = .TopPanelCollapsed
                
                if self.topPanelViewController != nil {
                    self.topPanelViewController!.view.removeFromSuperview()
                    self.topPanelViewController = nil
                }
                
            }
        }
    }
    
    func animatetempPanelXPositionTemps(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.tempViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animatetempPanelYPositionTemps(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.tempViewController.view.frame.origin.y = targetPosition
            }, completion: completion)
    }
    
    func showShadowForTempViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            tempViewController.view.layer.shadowOpacity = 1.0
        } else {
            tempViewController.view.layer.shadowOpacity = 0.0
        }
    }
    
    
    func collapseTopPanelTemps() {
        switch (currentState) {
        case .TopPanelExpanded:
            toggleTopPanelTemps()
        default:
            break
        }
    }
    
    func changeViewTemps(menu: String) {
        
        if menu == "temps" {
            if currentView != .Temperatures {
                tempViewController = UIStoryboard.tempViewController()
                tempViewController.delegate = self
                
                if graphViewController != nil {
                    self.graphViewController!.view.removeFromSuperview()
                    self.graphViewController = nil
                }
                if settingViewController != nil {
                    self.settingViewController!.view.removeFromSuperview()
                    self.settingViewController = nil
                }
                view.addSubview(tempViewController.view)
                
                currentView = .Temperatures
            }
        }
        else if menu == "graphs" {
            if currentView != .Graphs {
                graphViewController = UIStoryboard.graphViewController()
                graphViewController.delegate = self
            
                if tempViewController != nil {
                    self.tempViewController!.view.removeFromSuperview()
                    self.tempViewController = nil
                }
                if settingViewController != nil {
                    self.settingViewController!.view.removeFromSuperview()
                    self.settingViewController = nil
                }
                
                view.addSubview(graphViewController.view)
                
                currentView = .Graphs
            }
        }
        else if menu == "settings" {
            if currentView != .Settings {
                settingViewController = UIStoryboard.settingViewController()
                settingViewController.delegate = self
                
                if tempViewController != nil {
                    self.tempViewController!.view.removeFromSuperview()
                    self.tempViewController = nil
                }
                if graphViewController != nil {
                    self.graphViewController!.view.removeFromSuperview()
                    self.graphViewController = nil
                }
                
                view.addSubview(settingViewController.view)
                
                currentView = .Settings
            }
        }
    }
}

extension ContainerViewController: GraphViewControllerDelegate {
    func toggleTopPanelGraph() {
        let notAlreadyExpanded = (currentState != .TopPanelExpanded)
        
        if notAlreadyExpanded {
            addTopPanelViewControllerGraph()
        }
        
        animateTopPanelGraph(shouldExpand: notAlreadyExpanded)
    }
    
    func addChildTopPanelControllerGraph(topPanelController: TopPanelViewController) {
        topPanelController.delegate = graphViewController
        
        view.insertSubview(topPanelController.view, atIndex: 0)
        
        addChildViewController(topPanelController)
        topPanelController.didMoveToParentViewController(self)
    }
    
    func addTopPanelViewControllerGraph() {
        if (topPanelViewController == nil) {
            topPanelViewController = UIStoryboard.topPanelViewController()
            addChildTopPanelControllerGraph(topPanelViewController!)
        }
    }
    
    func animateTopPanelGraph(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .TopPanelExpanded
            
            animatetempPanelYPositionGraph(targetPosition: /*CGRectGetHeight(tempViewController.view.frame)*/ tempPanelExpandedOffset)
            
        } else {
            animatetempPanelYPositionGraph(targetPosition: 0) { _ in
                self.currentState = .TopPanelCollapsed
                
                if self.topPanelViewController != nil {
                    self.topPanelViewController!.view.removeFromSuperview()
                    self.topPanelViewController = nil
                }
            }
        }
    }
    
    func animatetempPanelXPositionGraph(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.graphViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animatetempPanelYPositionGraph(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.graphViewController.view.frame.origin.y = targetPosition
            }, completion: completion)
    }
    
    func showShadowForGraphViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            graphViewController.view.layer.shadowOpacity = 1.0
        } else {
            graphViewController.view.layer.shadowOpacity = 0.0
        }
    }
    
    
    func collapseTopPanelGraph() {
        switch (currentState) {
        case .TopPanelExpanded:
            toggleTopPanelGraph()
        default:
            break
        }
    }
    
    func changeViewGraph(menu: String) {
        if menu == "temps" {
            if currentView != .Temperatures {
                tempViewController = UIStoryboard.tempViewController()
                tempViewController.delegate = self
                
                if graphViewController != nil {
                    self.graphViewController!.view.removeFromSuperview()
                    self.graphViewController = nil
                }
                if settingViewController != nil {
                    self.settingViewController!.view.removeFromSuperview()
                    self.settingViewController = nil
                }
                view.addSubview(tempViewController.view)
                
                currentView = .Temperatures
            }
        }
        else if menu == "graphs" {
            if currentView != .Graphs {
                graphViewController = UIStoryboard.graphViewController()
                graphViewController.delegate = self
                
                if tempViewController != nil {
                    self.tempViewController!.view.removeFromSuperview()
                    self.tempViewController = nil
                }
                if settingViewController != nil {
                    self.settingViewController!.view.removeFromSuperview()
                    self.settingViewController = nil
                }
                
                view.addSubview(graphViewController.view)
                
                currentView = .Graphs
            }
        }
        else if menu == "settings" {
            if currentView != .Settings {
                settingViewController = UIStoryboard.settingViewController()
                settingViewController.delegate = self
                
                if tempViewController != nil {
                    self.tempViewController!.view.removeFromSuperview()
                    self.tempViewController = nil
                }
                if graphViewController != nil {
                    self.graphViewController!.view.removeFromSuperview()
                    self.graphViewController = nil
                }
                
                view.addSubview(settingViewController.view)
                
                currentView = .Settings
            }
        }

    }
}

extension ContainerViewController: SettingViewControllerDelegate {
    
    func toggleTopPanelSetting() {
        let notAlreadyExpanded = (currentState != .TopPanelExpanded)
        
        if notAlreadyExpanded {
            addTopPanelViewControllerSetting()
        }
        
        animateTopPanelSetting(shouldExpand: notAlreadyExpanded)
    }
    
    func addChildTopPanelControllerSetting(topPanelController: TopPanelViewController) {
        topPanelController.delegate = settingViewController
        
        view.insertSubview(topPanelController.view, atIndex: 0)
        
        addChildViewController(topPanelController)
        topPanelController.didMoveToParentViewController(self)
    }
    
    func addTopPanelViewControllerSetting() {
        if (topPanelViewController == nil) {
            topPanelViewController = UIStoryboard.topPanelViewController()
            addChildTopPanelControllerSetting(topPanelViewController!)
        }
    }
    
    func animateTopPanelSetting(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .TopPanelExpanded
            
            animatetempPanelYPositionSetting(targetPosition: /*CGRectGetHeight(tempViewController.view.frame)*/ tempPanelExpandedOffset)
            
        } else {
            animatetempPanelYPositionSetting(targetPosition: 0) { _ in
                self.currentState = .TopPanelCollapsed
                
                if self.topPanelViewController != nil {
                    self.topPanelViewController!.view.removeFromSuperview()
                    self.topPanelViewController = nil
                }
            }
        }
    }
    
    func animatetempPanelXPositionSetting(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.settingViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animatetempPanelYPositionSetting(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.settingViewController.view.frame.origin.y = targetPosition
            }, completion: completion)
    }
    
    func showShadowForSettingViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            settingViewController.view.layer.shadowOpacity = 1.0
        } else {
            settingViewController.view.layer.shadowOpacity = 0.0
        }
    }
    
    
    func collapseTopPanelSetting() {
        switch (currentState) {
        case .TopPanelExpanded:
            toggleTopPanelSetting()
        default:
            break
        }
    }
    
    func changeViewSetting(menu: String) {
        if menu == "temps" {
            if currentView != .Temperatures {
                tempViewController = UIStoryboard.tempViewController()
                tempViewController.delegate = self
                
                if graphViewController != nil {
                    self.graphViewController!.view.removeFromSuperview()
                    self.graphViewController = nil
                }
                if settingViewController != nil {
                    self.settingViewController!.view.removeFromSuperview()
                    self.settingViewController = nil
                }
                view.addSubview(tempViewController.view)
                
                currentView = .Temperatures
            }
        }
        else if menu == "graphs" {
            if currentView != .Graphs {
                graphViewController = UIStoryboard.graphViewController()
                graphViewController.delegate = self
                
                if tempViewController != nil {
                    self.tempViewController!.view.removeFromSuperview()
                    self.tempViewController = nil
                }
                if settingViewController != nil {
                    self.settingViewController!.view.removeFromSuperview()
                    self.settingViewController = nil
                }
                
                view.addSubview(graphViewController.view)
                
                currentView = .Graphs
            }
        }
        else if menu == "settings" {
            if currentView != .Settings {
                settingViewController = UIStoryboard.settingViewController()
                settingViewController.delegate = self
                
                if tempViewController != nil {
                    self.tempViewController!.view.removeFromSuperview()
                    self.tempViewController = nil
                }
                if graphViewController != nil {
                    self.graphViewController!.view.removeFromSuperview()
                    self.graphViewController = nil
                }
                
                view.addSubview(settingViewController.view)
                
                currentView = .Settings
            }
        }
    }
}
