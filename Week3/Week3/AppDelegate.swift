//
//  AppDelegate.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/4/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit
import Photos

var displayFirstTimeBanner = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        
        // TODO: If this is the first time running the app ask for permission to the photo library and camera up front
        // ------+--------------------------------------------
        // key   | value
        // ------+--------------------------------------------
        // count | increment by one each time the app launches
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var count = userDefaults.integerForKey("count")
        userDefaults.setInteger(++count, forKey: "count")
        
        if count == 1 {
            displayFirstTimeBanner = true
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

        println("applicationWillResignActive")
        NSNotificationCenter.defaultCenter().postNotificationName("sleep", object: nil, userInfo: nil)
        
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        println("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        println("applicationWillEnterForeground")
        NSNotificationCenter.defaultCenter().postNotificationName("wakeup", object: nil, userInfo: nil)
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        println("applicationDidBecomeActive")
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        println("applicationWillTerminate")
    }

}

