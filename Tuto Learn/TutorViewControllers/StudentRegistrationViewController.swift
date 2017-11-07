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

    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.registrationApicall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:Login Api Implementation
    func registrationApicall() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.tutorLogin) as String
        let data = UIImagePNGRepresentation(UIImage(named: "menu")!) as NSData?
        let parameters = ["s_name":self.firstNameTextField.text ?? "","s_mobile":self.mobNoTextField.text ?? "","s_email":self.eMailTextField.text ?? "","s_password":self.passwordTextField.text ?? "","s_address1":self.address1TextField.text ?? "","s_address2":self.address2TextField.text ?? "","s_city_id":"12","s_login_key":"a4b12c9d","s_pin":"400001","s_lastname":self.lastNameTextField.text ?? "","s_dob":self.dobTextField.text ?? "","s_gender":self.genderTextField.text ?? "","s_school_name":"New English School","s_level":"9","s_profile_img":data,"s_extension":"png"] as [String : AnyObject]
        
        Alamofire.request(urlPath, method: .post, parameters: (parameters as [String:Any]), encoding: JSONEncoding.default, headers:["Content-Type":"application/json"]) .responseJSON { response in
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
