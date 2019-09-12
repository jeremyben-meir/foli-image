//
//  AppDelegate.swift
//  foli-image
//
//  Created by Jeremy Ben-Meir on 7/1/19.
//  Copyright © 2019 Jeremy Ben-Meir. All rights reserved.
//

import UIKit
import GoogleSignIn
import SnapKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate:  UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GIDSignIn.sharedInstance().clientID = "681390020164-tu8k10gkeluncbj3236ocf8711bgi28a.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        GMSServices.provideAPIKey("AIzaSyANVgwUJFNUpIszq7kiDqy9OzjopxFICNE")
        GMSPlacesClient.provideAPIKey("AIzaSyANVgwUJFNUpIszq7kiDqy9OzjopxFICNE")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle:nil).instantiateInitialViewController() ?? UIViewController()
        //window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        window?.rootViewController = SignInViewController()
        
        return true
    }
    
    func getUsername(email: String) -> String {
        let components = email.components(separatedBy: "@")
        return components[0]
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        let email = user.profile.email
        let firstName = user.profile.givenName
        let lastName = user.profile.familyName
        window?.rootViewController = TabBarController(email: email!, firstName: firstName!, lastName: lastName!)
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

