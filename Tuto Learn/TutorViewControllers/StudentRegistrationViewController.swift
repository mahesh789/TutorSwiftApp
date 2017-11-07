//
//  StudentRegistrationViewController.swift
//  Tuto Learn
//
//  Created by Prashant Pandey on 07/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import Alamofire

class StudentRegistrationViewController: UIViewController {

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
        self.registrationApicall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorNavigationBar.leftBarButton.addTarget(self, action: #selector(backButtonAction), for:.touchUpInside)
    }
    
    // MARK:Login Api Implementation
    @objc func backButtonAction(sender:UIButton!) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func registrationApicall() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.studentRegister) as String
        let data = UIImagePNGRepresentation(UIImage(named: "menu")!) as NSData?
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.firstNameTextField.text, forKey: "s_name")
        dictionary.setValue(self.mobNoTextField.text, forKey: "s_mobile")
        dictionary.setValue(self.eMailTextField.text, forKey: "s_email")
        dictionary.setValue(self.passwordTextField.text, forKey: "s_password")
        dictionary.setValue(self.address1TextField.text, forKey: "s_address1")
        dictionary.setValue(self.address2TextField.text, forKey: "s_address2")
        dictionary.setValue("12", forKey: "s_city_ide")
        dictionary.setValue("a4b12c9d", forKey: "s_login_key")
        dictionary.setValue("400001", forKey: "s_pin")
        dictionary.setValue(self.lastNameTextField.text, forKey: "s_lastname")
        dictionary.setValue(self.dobTextField.text, forKey: "s_dob")
        dictionary.setValue(self.genderTextField.text, forKey: "s_gender")
        dictionary.setValue("New English School", forKey: "s_school_name")
        dictionary.setValue("9", forKey: "s_level")
        dictionary.setValue(data, forKey: "s_profile_img")
        dictionary.setValue("png", forKey: "s_extension")
        
        
        Alamofire.request(urlPath, method: .post, parameters: (dictionary as! [String:Any]), encoding: JSONEncoding.default, headers:["Content-Type":"application/json"]) .responseJSON { response in
                if response.result.isSuccess
                {
                    if let resultDictionary = response.result.value as? NSDictionary
                    {
                        if let resultParseLoginDictionary = resultDictionary.object(forKey:"Data")
                        {
                            print(resultParseLoginDictionary)
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

}
