
//
//  AppDelegate.swift
//  AuctionApp
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.setApplicationId("<your app id>", clientKey: "<your client key>")
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        

        let frame = UIScreen.mainScreen().bounds
        window = UIWindow(frame: frame)
        
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            let itemVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as? UINavigationController
            window?.rootViewController=itemVC
        } else {
            //Prompt User to Login
            let loginVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
            window?.rootViewController=loginVC
        }
        
        UITextField.appearance().tintColor = UIColor.orangeColor()

    
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 177/255, green: 23/255, blue: 50/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        UISearchBar.appearance().barTintColor = UIColor(red: 177/255, green: 23/255, blue: 50/255, alpha: 1.0)
        
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstalation = PFInstallation.currentInstallation()
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for var i = 0; i < deviceToken.length; i++ {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        println("tokenString: \(tokenString)")
        
        currentInstalation.setDeviceTokenFromData(deviceToken)
        currentInstalation.saveInBackgroundWithBlock(nil)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        NSNotificationCenter.defaultCenter().postNotificationName("pushRecieved", object: userInfo)
//        println("Push! \(userInfo)")
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
}



