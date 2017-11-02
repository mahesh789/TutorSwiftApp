//
//  ViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 27/10/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import Google
import GoogleSignIn
import Alamofire
class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var linkedInLoginButton: UIButton!
    @IBOutlet weak var googlePlusLoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Mahesh
        self.setLayoutAndSetTexts()
        self.setUpForGoogleSignIn()
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.userNameTextField.placeholder = "Email or Username"
        self.passwordTextField.placeholder = "Password"
        self.signInButton.setTitle("Sign In", for:UIControlState.normal)
        self.fbLoginButton.setTitle("FB LoginIn", for:UIControlState.normal)
        self.linkedInLoginButton.setTitle("Linked In", for:UIControlState.normal)
        self.googlePlusLoginButton.setTitle("Google Plus", for:UIControlState.normal)
        fbLoginButton.addTarget(self, action: #selector(self.facebookLoginButtonClicked), for: .touchUpInside)
    }
    //MARK:SignIn Button Action
    @IBAction func signInButtonAction(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
       self.loginApicall()
    }
    // MARK:Login Api Implementation
    func loginApicall() -> Void {
        
        let urlPath = "http://tutoruber.000webhostapp.com/auth/public/tutor_login"
        Alamofire.request(urlPath, method: .post, parameters: (["username":"sntftgnt@tgfyt.fgtdfg","password":"12345"] as [String:Any]), encoding: JSONEncoding.default, headers:["Content-Type":"application/json"])
                    .responseJSON { response in
                       if response.result.isSuccess
                       {
//                        if let result11 = response.result.value as? NSArray
//                        {
                            print(response.result.value as Any)
                       // }
                        
                       }else if response.result.isFailure
                       {
                        print(response.result.error as Any)
                       }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
    }
    
    // MARK: -Facebook Login
    @objc func facebookLoginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _,  _,  _):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                   // self.dict = result as! [String : AnyObject]
                    print(result!)
                    //print(self.dict)
                }
            })
        }
    }
    
    // MARK: - Google login
    @IBAction func googleSignIn(sender:Any)
    {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func setUpForGoogleSignIn() -> Void {
        var error : NSError?
        //setting the error
        GGLContext.sharedInstance().configureWithError(&error)
        //if any error stop execution and print error
        if error != nil{
            print(error ?? "google error")
            return
        }
        //adding the delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    //when the signin complets
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //if any error stop and print the error
        if error != nil{
            print(error ?? "google error")
            return
        }
        //if success display the email on label
        print(user.profile.email)
    }
    
    // MARK: -LinkedIn Login-
    @IBAction func linkedInLoginAction(_ sender: Any) {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (success) in
            let url = "https://api.linkedin.com/v1/people/~"
            if (LISDKSessionManager.hasValidSession())
            {
                LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response) in
                    if let dataFromString = response?.data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                        let result = try? JSONSerialization.jsonObject(with: dataFromString)
                        print(result ?? "")
                            LISDKSessionManager.clearSession()
                        }
                }, error: { (error) in
                    print(error!)
                })
            }
        }) { (error) in
            print(error!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

