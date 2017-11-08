//
//  StudentRegistrationViewController.swift
//  Tuto Learn
//
//  Created by Prashant Pandey on 07/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import Alamofire

class StudentRegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var mobNoTextField: UITextField!
    @IBOutlet weak var finTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cnfPassTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var pinCodeTextField: UITextField!

    @IBOutlet weak var tutorNavigationBar: TutorHomeNavigationBar!
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.setLayoutAndSetTexts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorNavigationBar.leftBarButton.addTarget(self, action: #selector(backButtonAction), for:.touchUpInside)
        self.tutorNavigationBar.rightBarButton.isHidden = true
        self.tutorNavigationBar.navigationTitleLabel.text = "Registration"
    }
    
    // MARK:Login Api Implementation
    @objc func backButtonAction(sender:UIButton!) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        guard  !(self.firstNameTextField.text?.isEmpty)!  else {
            self.showAlertController(alertMessage: "Please Enter First Name")
            return
        }
        guard !(self.lastNameTextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter Last Name")
            return
        }
        guard !(self.genderTextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter Gender")
            return
        }
        guard !(self.dobTextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter Date of Birth")
            return
        }
        guard (self.eMailTextField.text! as NSString).isValidEmail() else {
            self.showAlertController(alertMessage: "Please Enter Email")
            return
        }
        guard !(self.mobNoTextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter Mobile No")
            return
        }
        guard !(self.passwordTextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter Password")
            return
        }
        guard !(self.address1TextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter Address 1 Field")
            return
        }
        guard !(self.address2TextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter Address 2 Field")
            return
        }
        guard !(self.districtTextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter District")
            return
        }
        guard !(self.pinCodeTextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter Pin Code")
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.registrationApicall()
    }
    
    @IBAction func canelButtonClicked(_ sender: Any) {
    }
    
    func registrationApicall() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.studentRegister) as String
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue("student", forKey: "register_type")
        dictionary.setValue(self.firstNameTextField.text, forKey: "s_name")
        dictionary.setValue(self.lastNameTextField.text, forKey: "s_lastname")
        dictionary.setValue(self.mobNoTextField.text, forKey: "s_mobile")
        dictionary.setValue(self.eMailTextField.text, forKey: "s_email")
        dictionary.setValue(self.passwordTextField.text, forKey: "s_password")
        dictionary.setValue(self.dobTextField.text, forKey: "s_dob")
        dictionary.setValue(self.genderTextField.text, forKey: "s_gender")
        dictionary.setValue(self.address1TextField.text, forKey: "s_address1")
        dictionary.setValue(self.address2TextField.text, forKey: "s_address2")
        dictionary.setValue("400001", forKey: "s_pin")
        dictionary.setValue("L6783452H", forKey: "s_nric")
        dictionary.setValue("Mobile", forKey: "s_oauth")
        dictionary.setValue("12", forKey: "s_city_ide")

        Alamofire.request(urlPath, method: .post, parameters: (dictionary as! [String:Any]), encoding: JSONEncoding.default, headers:["Content-Type":"application/json"]) .responseJSON { response in
                if response.result.isSuccess
                {
                    if let resultDictionary = response.result.value as? NSDictionary
                    {
                        self.showAlertController(alertMessage: resultDictionary["message"] as? String)
                    }
                }
                else if response.result.isFailure {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }

}
