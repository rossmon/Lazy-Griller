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
    
    
    
    var tempPanelExpandedOffset: CGFloat =  125
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempViewController = UIStoryboard.tempViewController()
        tempViewController.delegate = self
        
        view.addSubview(tempViewController.view)
        
        currentView = .Temperatures
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
            //topPanelViewController!.settings = SettingTab.menuItems()
            //println(topPanelViewController!.settings[0].title)
            //println(topPanelViewController!.settings[0].image)
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
                
                self.topPanelViewController!.view.removeFromSuperview()
                self.topPanelViewController = nil
            }
        }
    }
    
    func animatetempPanelXPositionTemps(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.tempViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animatetempPanelYPositionTemps(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
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
            //topPanelViewController!.settings = SettingTab.menuItems()
            //println(topPanelViewController!.settings[0].title)
            //println(topPanelViewController!.settings[0].image)
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
                
                self.topPanelViewController!.view.removeFromSuperview()
                self.topPanelViewController = nil
            }
        }
    }
    
    func animatetempPanelXPositionGraph(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.graphViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animatetempPanelYPositionGraph(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
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
            //topPanelViewController!.settings = SettingTab.menuItems()
            //println(topPanelViewController!.settings[0].title)
            //println(topPanelViewController!.settings[0].image)
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
                
                self.topPanelViewController!.view.removeFromSuperview()
                self.topPanelViewController = nil
            }
        }
    }
    
    func animatetempPanelXPositionSetting(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.settingViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animatetempPanelYPositionSetting(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
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
