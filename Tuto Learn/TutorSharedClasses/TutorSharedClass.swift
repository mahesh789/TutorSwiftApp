//
//  TutorSharedClass.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 05/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit


// MARK: - Singleton
public class TutorSharedClass:NSObject {
    
    // Can't init is singleton
     override init() { }
    
    // MARK: Shared Instance
    static let shared = TutorSharedClass()
    
    // MARK: Local Variables
    var loginTutorLoginObject:TutorLoginModel?
    
    // MARK: Local Variables
    var token:String?
    var studentId:String?

   public class func navigateLoginViewController() -> Void {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutorLoginViewController:ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navigationController = UINavigationController(rootViewController: tutorLoginViewController)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navigationController

    }
    public class func navigateLoadingViewController() -> Void {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutorLoadingViewController:TutorLoadingViewController = storyboard.instantiateViewController(withIdentifier: "TutorLoadingViewController") as! TutorLoadingViewController
        let navigationController = UINavigationController(rootViewController: tutorLoadingViewController)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
    
  public class func removeLoginCredentialsAndSetRootViewControllerLogin() -> Void {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.set(nil, forKey: "userName")
        UserDefaults.standard.set(nil, forKey: "passWord")
        TutorSharedClass.navigateLoginViewController()
    }
     
}

