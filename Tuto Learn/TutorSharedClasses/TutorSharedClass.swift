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
    var loopCount:Int = 0
    var findTutorDictionary = NSMutableDictionary()
    var isLoginRemember:Bool = false
    var islogOutYes:Bool = false
    

   public class func navigateLoginViewController(window:UIWindow) -> Void {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutorLoginViewController:ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navigationController = UINavigationController(rootViewController: tutorLoginViewController)
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
    }
  
  public class func removeLoginCredentialsAndSetRootViewControllerLogin(window:UIWindow) -> Void {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.set(nil, forKey: "LoginDetails")
        TutorSharedClass.navigateLoginViewController(window: window)
    }
    
    
    public func setRootControllerAccordingtoResponse(window:UIWindow)  {
        
        if TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type == "0" {
            
            if TutorSharedClass.shared.loginTutorLoginObject?.sm_guardian == 2
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tutorHomeViewController:TutorProfileViewController = storyboard.instantiateViewController(withIdentifier: "TutorProfileViewController") as! TutorProfileViewController
                tutorHomeViewController.currentProfilType = ProfileType.ProfileTypeGuardian.rawValue
                let navigationController = UINavigationController(rootViewController: tutorHomeViewController)
                navigationController.isNavigationBarHidden = true
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }else if TutorSharedClass.shared.loginTutorLoginObject?.sm_profile == 2
            {
                self.setProfilerootViewController(window: window)
                
            }else if TutorSharedClass.shared.loginTutorLoginObject?.sm_preference == 2
            {
                self.setPreferencesrootViewController(window: window)
            }else{
               self.setrootViewControllerAfterLogin(window: window)
            }
            
        }else{
            
            if (TutorSharedClass.shared.loginTutorLoginObject?.sm_profile == 1) && (TutorSharedClass.shared.loginTutorLoginObject?.sm_preference == 1)
            {
                self.setrootViewControllerAfterLogin(window: window)
            }
            else if (TutorSharedClass.shared.loginTutorLoginObject?.sm_profile == 1) && (TutorSharedClass.shared.loginTutorLoginObject?.sm_preference == 2)
            {
                self.setPreferencesrootViewController(window: window)
            }
            else if (TutorSharedClass.shared.loginTutorLoginObject?.sm_profile == 2) && (TutorSharedClass.shared.loginTutorLoginObject?.sm_preference == 1)
            {
                self.setProfilerootViewController(window: window)
            }else
            {
                self.setProfilerootViewController(window: window)
            }
        }
        
       
    }
    
    func setrootViewControllerAfterLogin(window:UIWindow) -> Void {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tutorHomeViewController:TutorHomeViewController = storyboard.instantiateViewController(withIdentifier: "TutorHomeViewController") as! TutorHomeViewController
        let navigationController = UINavigationController(rootViewController: tutorHomeViewController)
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
    }
    
    func setProfilerootViewController(window:UIWindow) -> Void {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type == "1"
        {
            let tutorHomeViewController:TutorProfileViewController = storyboard.instantiateViewController(withIdentifier: "TutorProfileViewController") as! TutorProfileViewController
            tutorHomeViewController.currentProfilType = ProfileType.ProfileTypeGuardian.rawValue
            let navigationController = UINavigationController(rootViewController: tutorHomeViewController)
            navigationController.isNavigationBarHidden = true
            window.rootViewController = navigationController
        }else
        {
            let tutorHomeViewController:TutorStudentProfileViewController = storyboard.instantiateViewController(withIdentifier: "TutorStudentProfileViewController") as! TutorStudentProfileViewController
            tutorHomeViewController.isEditStudentProfile = true
            tutorHomeViewController.selectedStudentInfo = TutorSharedClass.shared.loginTutorLoginObject?.dictionaryRepresentation()
            let navigationController = UINavigationController(rootViewController: tutorHomeViewController)
            navigationController.isNavigationBarHidden = true
            window.rootViewController = navigationController
        }
    }
    
    func setPreferencesrootViewController(window:UIWindow) -> Void {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tutorHomeViewController:TutorPreferencesViewController = storyboard.instantiateViewController(withIdentifier: "TutorPreferencesViewController") as! TutorPreferencesViewController
        tutorHomeViewController.isfromLoginAPI = true
        let navigationController = UINavigationController(rootViewController: tutorHomeViewController)
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
    }
    
    func updateLocalValue() {
        if self.isLoginRemember == true
        {
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            let loginDictionary = TutorSharedClass.shared.loginTutorLoginObject?.dictionaryRepresentation()
            UserDefaults.standard.set(loginDictionary, forKey: "LoginDetails")
        }
        
    }
    
  public func setTimeFormat(startTime:String, endTime:String) -> String {
        
        var tempStartTime = startTime
        var tempEndTime = endTime
        if (Int(startTime)! > 12)
        {
            tempStartTime = tempStartTime + " PM"
            
        }else{
            tempStartTime = tempStartTime + " AM"
        }
        
        if (Int(endTime)! > 12)
        {
            tempEndTime = tempEndTime + " PM"
            
        }else{
            tempEndTime = tempEndTime + " AM"
        }
        return "\(tempStartTime) " + "-\(tempEndTime)"
    }
    
  public func scaleUIImageToSize(image: UIImage, size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.init(), size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

extension Int{
    static prefix func ++(x: inout Int) -> Int {
        x += 1
        return x
    }
    
    static postfix func ++(x: inout  Int) -> Int {
        defer {x += 1}
        return x
    }
    
    static prefix func --(x: inout Int) -> Int {
        x -= 1
        return x
    }
    
    static postfix func --(x: inout Int) -> Int {
        defer {x -= 1}
        return x
    }
    
    
  
    
}
