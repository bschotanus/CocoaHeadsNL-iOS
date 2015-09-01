//
//  AppDelegate.swift
//  CocoaHeadsNL
//
//  Created by Bart Hoffman on 07/03/15.
//  Copyright (c) 2015 Stichting CocoaheadsNL. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coreLocationController:CoreLocationController?

    struct ParseConfiguration {
        let applicationId: String
        let clientKey: String
    }

    func loadParseConfiguration() -> ParseConfiguration {
        if let path = NSBundle.mainBundle().pathForResource("ParseConfig", ofType: "plist"),
               dict = NSDictionary(contentsOfFile: path),
               applicationId = dict.objectForKey("applicationId") as? String,
               clientKey = dict.objectForKey("clientKey") as? String {
            return ParseConfiguration(applicationId: applicationId, clientKey: clientKey)
        }
        fatalError("Parse credentials not configured. Please see README.md.")
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.coreLocationController = CoreLocationController()
                
        ParseCrashReporting.enable()

        let config = loadParseConfiguration()
        Parse.setApplicationId(config.applicationId, clientKey: config.clientKey)

        PFUser.enableRevocableSessionInBackground()
        if let user = PFUser.currentUser() where PFAnonymousUtils.isLinkedWithUser(user) {
            PFUser.logOut()
        }

        PFConfig.getConfigInBackground()

        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)

        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        if let locationManager = self.coreLocationController?.locationManager {
            locationManager.startUpdatingLocation()
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        if let locationManager = self.coreLocationController?.locationManager {
            locationManager.stopUpdatingLocation()
        }
    }
}
