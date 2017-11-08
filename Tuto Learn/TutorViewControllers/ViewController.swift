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
        
        //temporary
        self.userNameTextField.text = "ankita@test.com"
        self.passwordTextField.text = "12345"
    }
    
    //MARK:SignIn Button Action
    @IBAction func signInButtonAction(_ sender: Any) {
        
        guard  !(self.userNameTextField.text?.isEmpty)!  else {
            self.showAlertController(alertMessage: "Please Enter Email")
            return
        }
        guard (self.userNameTextField.text! as NSString).isValidEmail() else {
             self.showAlertController(alertMessage: "Please Enter Valid Email")
            return
        }
        guard !(self.passwordTextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter Password")
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
       self.loginApicall()
    }
    // MARK:Login Api Implementation
    func loginApicall() -> Void {
        
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.studentLogin) as String
        Alamofire.request(urlPath, method: .post, parameters: (["username":self.userNameTextField.text ?? "","password":self.passwordTextField.text ?? ""] as [String:Any]), encoding: JSONEncoding.default, headers:["Content-Type":"application/json"])
            .responseJSON { response in
                if response.result.isSuccess
                {
                    if let resultDictionary = response.result.value as? NSDictionary
                    {
                        
                        if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.StatusOK.rawValue
                        {
                            if let resultParseLoginDictionary = resultDictionary.object(forKey: "Data")
                            {
                                print(resultParseLoginDictionary)
                                let loginModelArray = TutorLoginModel.modelsFromDictionaryArray(array: [resultParseLoginDictionary])
                                if (loginModelArray.first != nil)
                                {
                                    TutorSharedClass.shared.loginTutorLoginObject = loginModelArray.first
                                    self.showAlertController(alertMessage: "Login Successfull")
                                }
                            }
                        }else{
                            self.showAlertController(alertMessage: resultDictionary["message"] as? String)
                        }
                       
                    }
                }else if response.result.isFailure
                {
                    print(response.result.error as Any)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    //MARK: Default AlertViewController
    func showAlertController(alertMessage:String?) -> Void {
        let alert = UIAlertController(title: "", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonAction(_ sender: Any)
    {
        let commonChangeEmailController:StudentRegistrationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudentRegistrationViewController") as! StudentRegistrationViewController
        self.navigationController?.pushViewController(commonChangeEmailController, animated: true)
    }
    
    func generateTokenApiCalling(paramsDictionary:NSDictionary) -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.token) as String
        Alamofire.request(urlPath, method: .post, parameters:nil, encoding: JSONEncoding.default, headers:["Content-Type":"application/json"])
            .responseJSON { response in
                if response.result.isSuccess
                {
                    if let resultDictionary = response.result.value as? NSDictionary
                    {
                       let tokenId = resultDictionary["token"] as? String
                        self.loginSocialNetworkingApiCall(parametersDictionary: paramsDictionary as NSDictionary, token:tokenId)
                    }else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }else if response.result.isFailure
                {
                    print(response.result.error as Any)
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
        }
    }
    //MARK: -Login API Call For Social Networking
    func loginSocialNetworkingApiCall(parametersDictionary:NSDictionary,token:String?) -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.socialStudentRegister) as String
        Alamofire.request(urlPath, method: .post, parameters: (parametersDictionary as! [String:Any]), encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",token ?? "")])
            .responseJSON { response in
                if response.result.isSuccess
                {
                    if let resultDictionary = response.result.value as? NSDictionary
                    {
                        if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.StatusOK.rawValue
                        {
                            if let resultParseLoginDictionary = resultDictionary.object(forKey: "Data")
                            {
                                print(resultParseLoginDictionary)
                                let loginModelArray = TutorLoginModel.modelsFromDictionaryArray(array: [resultParseLoginDictionary])
                                if (loginModelArray.first != nil)
                                {
                                    TutorSharedClass.shared.loginTutorLoginObject = loginModelArray.first
                                    self.showAlertController(alertMessage: "Login Successfull")
                                }
                            }
                        }else{
                            self.showAlertController(alertMessage: resultDictionary["message"] as? String)
                        }
                    }
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
                    if let responseDictionary = result as? [String : Any]
                    {
                    var profileUrlPicture = ""
                    if  let profilePicture = responseDictionary["picture"] as? [String: Any], let profileData = profilePicture["data"] as? [String: Any],let profileUrl = profileData["url"]
                     {
                        profileUrlPicture = profileUrl as! String
                     }
                        let paramDictionary = ["ac_type":"facebook","id":responseDictionary["id"] ?? "","first_name":responseDictionary["name"] ?? "","last_name": "dfdfd","email":responseDictionary["email"] ?? "","address":"mumbai","url":profileUrlPicture ,"oauth_token":FBSDKAccessToken.current().tokenString]
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        self.generateTokenApiCalling(paramsDictionary: paramDictionary as NSDictionary)
                    }
                   
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
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
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
        var profileUrl = ""
        if (GIDSignIn.sharedInstance().currentUser.profile.hasImage)
        {
            let dimension = round(100 * UIScreen.main.scale);
            let picUrl = user.profile.imageURL(withDimension: UInt(dimension))
            profileUrl = String(format:"%@",(picUrl?.absoluteString)!)
        }
         let paramDictionary = ["ac_type":"gmail","id":user.userID,"first_name":user.profile.name,"last_name": "dfdfd","email":user.profile.email,"address":"mumbai","url":profileUrl ,"oauth_token":user.authentication.accessToken]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.generateTokenApiCalling(paramsDictionary: paramDictionary as NSDictionary)
    }
    
    // MARK: -LinkedIn Login-
    @IBAction func linkedInLoginAction(_ sender: Any) {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (success) in
            let url = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,email-address,location:(name),public-profile-url,picture-url)"
            if (LISDKSessionManager.hasValidSession())
            {
                LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response) in
                    if let dataFromString = response?.data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                        if let result = try? JSONSerialization.jsonObject(with: dataFromString) as! [String:Any]
                        {
                            print(result)
                            DispatchQueue.main.async {
                                let paramDictionary = NSMutableDictionary()
                                paramDictionary.setValue("linkedin", forKey: "ac_type")
                                paramDictionary.setValue(result["id"] as? String, forKey: "id")
                                paramDictionary.setValue(result["firstName"] as? String, forKey: "first_name")
                                paramDictionary.setValue(result["lastName"] as? String, forKey: "last_name")
                                paramDictionary.setValue(result["emailAddress"] as? String, forKey: "email")
                                if let location = result["location"] as? [String:Any],let name = location["name"]
                                {
                                    paramDictionary.setValue(name, forKey: "address")
                                }else{
                                    paramDictionary.setValue("", forKey: "address")
                                }
                                paramDictionary.setValue(result["pictureUrl"] as? String, forKey: "url")
                                paramDictionary.setValue("", forKey: "oauth_token")
                                MBProgressHUD.showAdded(to: self.view, animated: true)
                                self.generateTokenApiCalling(paramsDictionary: paramDictionary as NSDictionary)
                                LISDKSessionManager.clearSession()
                            }
                        }
                        
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

