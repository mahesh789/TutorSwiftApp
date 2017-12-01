//
//  TutorLoadingViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 30/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorLoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let loader =  MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.label.text = "Login In"
        self.callLoginApiCallWithToken()
    }
    
    func callLoginApiCallWithToken() -> Void {
        
        TutorNetworkManager.performRequestWithUrl(baseUrl: Constants.baseUrl + Constants.token, parametersDictionary:nil) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDict = info as? Dictionary<String,Any>
                {
                    if let token = resultDict["token"] as? String
                    {
                        UserDefaults.standard.set(token, forKey: "loginToken")
                        TutorSharedClass.shared.token = token
                        self.loginApicall()
                    }else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        TutorSharedClass.removeLoginCredentialsAndSetRootViewControllerLogin()
                    }
                }else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    TutorSharedClass.removeLoginCredentialsAndSetRootViewControllerLogin()
                }
            }else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
                TutorSharedClass.removeLoginCredentialsAndSetRootViewControllerLogin()
            }
        }
    }
    
    // MARK:Login Api Implementation
    func loginApicall() -> Void {
        TutorNetworkManager.performRequestWithUrl(baseUrl: Constants.baseUrl + Constants.studentLogin, parametersDictionary:(["username":UserDefaults.standard.string(forKey: "userName") ?? "","password":UserDefaults.standard.string(forKey: "passWord") ?? ""] as [String:Any])) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDict = info as? Dictionary<String,Any>
                {
                    if let resultParseLoginDictionary = resultDict["Data"]
                    {
                        print(resultParseLoginDictionary)
                        let loginModelArray = TutorLoginModel.modelsFromDictionaryArray(array: [resultParseLoginDictionary])
                        if (loginModelArray.first != nil)
                        {
                            TutorSharedClass.shared.loginTutorLoginObject = loginModelArray.first
                             self.setrootViewControllerAfterLogin()
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        }
                    }
                }
            }else
            {
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
               TutorSharedClass.removeLoginCredentialsAndSetRootViewControllerLogin()
            }
        }
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func setrootViewControllerAfterLogin() -> Void {
        let tutorHomeViewController:TutorHomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "TutorHomeViewController") as! TutorHomeViewController
        let navigationController = UINavigationController(rootViewController: tutorHomeViewController)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
