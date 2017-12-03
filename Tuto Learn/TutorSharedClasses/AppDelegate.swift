//
//  AppDelegate.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 27/10/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Google
import GoogleSignIn
import IQKeyboardManagerSwift

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {

   public var window: UIWindow?


    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
           self.callFirstTimeLoginToken()
            if let loginDictionary = UserDefaults.standard.object(forKey: "LoginDetails") {
                TutorSharedClass.shared.loginTutorLoginObject  = TutorLoginModel.init(dictionary: loginDictionary as! NSDictionary)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tutorHomeViewController:TutorHomeViewController = storyboard.instantiateViewController(withIdentifier: "TutorHomeViewController") as! TutorHomeViewController
            let navigationController = UINavigationController(rootViewController: tutorHomeViewController)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tutorLoginViewController:ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let navigationController = UINavigationController(rootViewController: tutorLoginViewController)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func callFirstTimeLoginToken() -> Void {
        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
            if Constants.Status.StatusOK.rawValue == status
            {
                TutorSharedClass.shared.token = token
            }
        })
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        if LISDKCallbackHandler.shouldHandle(url)
        {
            return LISDKCallbackHandler.application(application, open:url, sourceApplication:sourceApplication ,annotation:annotation)
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    

    public func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        FBSDKAppEvents.activateApp()
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

