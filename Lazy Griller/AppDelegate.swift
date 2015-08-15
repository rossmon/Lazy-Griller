
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound |
            UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let containerViewController = ContainerViewController()
        
        window!.rootViewController = containerViewController
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(Alarms.sharedInstance.alarm1IsOn(), forKey: "probe1Alarm")
        defaults.setBool(Alarms.sharedInstance.alarm2IsOn(), forKey: "probe2Alarm")
        defaults.setInteger(Alarms.sharedInstance.getAlarm1Temp(), forKey: "probe1AlarmTemp")
        defaults.setInteger(Alarms.sharedInstance.getAlarm2Temp(), forKey: "probe2AlarmTemp")
        
        defaults.setDouble(RecentReading.sharedInstance.getLastTemp(1)!, forKey: "probe1LastTemp")
        defaults.setDouble(RecentReading.sharedInstance.getLastTemp(2)!, forKey: "probe2LastTemp")
        defaults.setObject(Settings.sharedInstance.getDeviceName(), forKey: "deviceName")

    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        let defaults = NSUserDefaults.standardUserDefaults()
        Alarms.sharedInstance.setProbe1Alarm(defaults.integerForKey("probe1AlarmTemp"))
        Alarms.sharedInstance.setProbe2Alarm(defaults.integerForKey("probe2AlarmTemp"))
        if defaults.boolForKey("probe1Alarm") {Alarms.sharedInstance.turnOnProbe1Alarm()}
        if defaults.boolForKey("probe2Alarm") {Alarms.sharedInstance.turnOnProbe2Alarm()}
        RecentReading.sharedInstance.setLastTemp(1, temp: defaults.doubleForKey("probe1LastTemp"))
        RecentReading.sharedInstance.setLastTemp(2, temp: defaults.doubleForKey("probe2LastTemp"))
        
        Settings.sharedInstance.setDeviceName(defaults.objectForKey("deviceName") as! String)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        let defaults = NSUserDefaults.standardUserDefaults()
//        Alarms.sharedInstance.setProbe1Alarm(defaults.integerForKey("probe1AlarmTemp"))
//        Alarms.sharedInstance.setProbe2Alarm(defaults.integerForKey("probe2AlarmTemp"))
//        if defaults.boolForKey("probe1Alarm") {Alarms.sharedInstance.turnOnProbe1Alarm()}
//        if defaults.boolForKey("probe2Alarm") {Alarms.sharedInstance.turnOnProbe2Alarm()}
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(Alarms.sharedInstance.alarm1IsOn(), forKey: "probe1Alarm")
        defaults.setBool(Alarms.sharedInstance.alarm2IsOn(), forKey: "probe2Alarm")
        defaults.setInteger(Alarms.sharedInstance.getAlarm1Temp(), forKey: "probe1AlarmTemp")
        defaults.setInteger(Alarms.sharedInstance.getAlarm2Temp(), forKey: "probe2AlarmTemp")
        
        defaults.setDouble(RecentReading.sharedInstance.getLastTemp(1)!, forKey: "probe1LastTemp")
        defaults.setDouble(RecentReading.sharedInstance.getLastTemp(2)!, forKey: "probe2LastTemp")
        RecentReading.sharedInstance.setLastTemp(1, temp: defaults.doubleForKey("probe1LastTemp"))
        RecentReading.sharedInstance.setLastTemp(2, temp: defaults.doubleForKey("probe2LastTemp"))
        
        defaults.setObject(Settings.sharedInstance.getDeviceName(), forKey: "deviceName")
    }
    
}

