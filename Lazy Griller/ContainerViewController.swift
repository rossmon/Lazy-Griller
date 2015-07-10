//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case RightPanelExpanded
}

class ContainerViewController: UIViewController {
    
    var tempNavigationController: UINavigationController!
    var tempViewController: TempViewController!
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowFortempViewController(shouldShowShadow)
        }
    }
    var sidePanelViewController: SidePanelViewController?
    var tempPanelExpandedOffset: CGFloat =  150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tempViewController = UIStoryboard.tempViewController()
        tempViewController.delegate = self
        
        //tempPanelExpandedOffset = CGFloat(bound.width!)
        // wrap the tempViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        //tempNavigationController = UINavigationController(rootViewController: tempViewController)
        view.addSubview(tempViewController.view)
        //addChildViewController(tempNavigationController)
        
        //tempNavigationController.didMoveToParentViewController(self)
    }
    
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func sidePanelViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("SidePanelViewController") as? SidePanelViewController
    }
    
    class func tempViewController() -> TempViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TempViewController") as? TempViewController
    }
    
}
extension ContainerViewController: TempViewControllerDelegate {
    
    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = tempViewController
        
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func addRightPanelViewController() {
        if (sidePanelViewController == nil) {
            sidePanelViewController = UIStoryboard.sidePanelViewController()
            sidePanelViewController!.settings = SettingTab.menuItems()
            println(sidePanelViewController!.settings[0].title)
            println(sidePanelViewController!.settings[0].image)
            addChildSidePanelController(sidePanelViewController!)
        }
    }
    
    func animateRightPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .RightPanelExpanded
            
            animatetempPanelXPosition(targetPosition: -CGRectGetWidth(tempViewController.view.frame) + tempPanelExpandedOffset)
        } else {
            animatetempPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .BothCollapsed
                
                self.sidePanelViewController!.view.removeFromSuperview()
                self.sidePanelViewController = nil;
            }
        }
    }
    
    func animatetempPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.tempViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowFortempViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            tempViewController.view.layer.shadowOpacity = 1.0
        } else {
            tempViewController.view.layer.shadowOpacity = 0.0
        }
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .RightPanelExpanded:
            toggleRightPanel()
        default:
            break
        }
    }
    
}