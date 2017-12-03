//
//  TutorForgotPasswordViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 02/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorForgotPasswordViewController: UIViewController {

    @IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var userNameTextField:UITextField!
    @IBOutlet weak var otpTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    var isOtpSend:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
    }
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Find a Tutor"
        self.view.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.userNameTextField.attributedPlaceholder = NSAttributedString(string:self.userNameTextField.placeholder!,
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.otpTextField.attributedPlaceholder = NSAttributedString(string:self.otpTextField.placeholder!,
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:self.passwordTextField.placeholder!,
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
       self.otpTextFieldsHiddenAndShow(isValue: true )
       
    }
    @objc func backBarButtonAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender:Any)
    {
        if (userNameTextField.text?.isEmpty)! {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Email Or UserName", showController: self)
            return
        }
        if self.isOtpSend {
            if (self.otpTextField.text?.isEmpty)! {
                TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter OTP", showController: self)
                return
            }
            if (self.passwordTextField.text?.isEmpty)! {
                TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter New Password", showController: self)
                return
            }
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.setOTPforgotApiCalling()
        }else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.forgotApiCalling()
        }
    }
    // MARK:Forgot Api Implementation
    func forgotApiCalling() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.forgot_Password) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["f_username":self.userNameTextField.text ?? ""]) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let messageString = resultDictionary["message"] as? String
                    {
                        self.otpTextFieldsHiddenAndShow(isValue: false )
                        self.isOtpSend = true
                        self.userNameTextField.isEnabled = false
                        TutorDefaultAlertController.showAlertController(alertMessage: messageString, showController: self)
                    }
                }
            }
            else{
                print(info as Any)
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
            }
        }
    }
    
    // MARK:Forgot Api Implementation
    func setOTPforgotApiCalling() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.set_Forgot_Password) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["username":self.userNameTextField.text ?? "","otp":self.otpTextField.text ?? "","new_pass":self.passwordTextField.text ?? ""]) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                   print(resultDictionary)
                }
            }
            else{
                print(info as Any)
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
            }
        }
    }
    
    func otpTextFieldsHiddenAndShow(isValue:Bool) -> Void {
        self.otpTextField.isHidden = isValue
        self.passwordTextField.isHidden = isValue
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
