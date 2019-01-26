//
//  AppDelegate.swift
//  Dots
//
//  Created by Bjarte Sjursen on 29.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var containerViewController : ContainerViewController!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        screenSize = UIScreen.main.bounds.size
        if(screenSize.width < 568.0){
            isIphone4ScreenSize = true
        }
        
        //Check if it is the first time the app is being used
        let firstUse = UserDefaults.standard.object(forKey: isAppUsedString)
        if firstUse == nil {
            UserDefaults.standard.set(0, forKey: myScoreString)
            UserDefaults.standard.set(true, forKey: isAppUsedString)
            UserDefaults.standard.set(true, forKey: isMusicOnString)
            UserDefaults.standard.set(false, forKey: hasLoginKeyString)
            UserDefaults.standard.set(0, forKey: numberOfTimesPlayedString)
            UserDefaults.standard.synchronize()
        }
        
        if Reachability.isConnectedToNetwork() {
            //See if the user has a loginkey
            let hasLoginKey = UserDefaults.standard.bool(forKey: hasLoginKeyString)
            if hasLoginKey == true {
                let username = UserDefaults.standard.string(forKey: usernameString)!
                let password = KeychainWrapper().myObject(forKey: "v_Data") as! String
                NetworkManager.login(username, password: password, completionHandler: loginHandler)
            }
        }

    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        if containerViewController.mainMenuViewController.gameViewController.scene.activeGame && !containerViewController.mainMenuViewController.gameViewController.scene.isPaused {
            containerViewController.mainMenuViewController.gameViewController.pause()
        }
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if containerViewController != nil {
            if containerViewController.mainMenuViewController.gameViewController.scene.activeGame || !containerViewController.mainMenuViewController.gameViewController.stopButton.isHidden {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "stayPausedNotification"), object:nil)
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func loginHandler(_ data : Data?, response : URLResponse?, error : NSError?){
        if error == nil && data != nil {
            do {
                var json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                token = json["token"] as! String
            } catch {
                print("Error while logging in")
            }
        }
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        
        
        if containerViewController.gameViewController.interstitial != nil {
            containerViewController.gameViewController.dismiss(animated: true, completion: {})
            containerViewController.gameViewController.interstitial = nil
        }
        
        
    }
    
    



}

