//
//  AppDelegate.swift
//  My Ideas
//
//  Created by Julia Schwarz on 11/13/15.
//  Copyright (c) 2015 Julia Schwarz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // Initial development is done on the sandbox service
        // When you want to connect to production, just pass "nil" for "optionalHost"
        let SANDBOX_HOST = ENSessionHostSandbox
        
        let APIKeyData = loadEvernoteAPIKey().componentsSeparatedByString("\n")
        
        // Fill in the consumer key and secret with the values that you received from Evernote
        // To get an API key, visit http://dev.evernote.com/documentation/cloud/
        let CONSUMER_KEY = APIKeyData[0];
        let CONSUMER_SECRET = APIKeyData[1];
        
        ENSession.setSharedSessionConsumerKey(CONSUMER_KEY, consumerSecret: CONSUMER_SECRET, optionalHost: SANDBOX_HOST)
        return true
    }
    
    func loadEvernoteAPIKey() -> String {
        let evernoteKeyFilePath = NSBundle.mainBundle().pathForResource("evernote_key", ofType: "txt")
        let fileData: String?
        do {
            fileData = try String(contentsOfFile: evernoteKeyFilePath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            fatalError("couldn't find My Ideas/evernote_key.txt")
        }
        return fileData!
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

