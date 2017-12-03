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
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.forgotApiCalling()
    }
    // MARK:Forgot Api Implementation
    func forgotApiCalling() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.forgot_Password) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: nil) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let messageString = resultDictionary["message"] as? String
                    {
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
