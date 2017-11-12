//
//  StudentRegistrationViewController.swift
//  Tuto Learn
//
//  Created by Prashant Pandey on 07/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import Alamofire

class StudentRegistrationViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
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
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var studentButton: UIButton!
    @IBOutlet weak var guardianButton: UIButton!
    let gender = ["Male","Female"]
    let thePicker = UIPickerView()
    var cityArray = Array<Any>()
    var regiterTypeString : String?
    var genderTypeString : String?
    var cityIdString : String?


    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.setLayoutAndSetTexts()
        thePicker.delegate = self ;
        thePicker.dataSource = self ;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorNavigationBar.leftBarButton.addTarget(self, action: #selector(backButtonAction), for:.touchUpInside)
        self.tutorNavigationBar.rightBarButton.isHidden = true
        self.tutorNavigationBar.navigationTitleLabel.text = "Registration"
        self.view.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.contentView.backgroundColor = UIColor.tutorAppBackgroungColor()
        
        self.regiterTypeString = "Guardian"
        self.guardianButton.backgroundColor = UIColor.orange
        self.studentButton.backgroundColor = UIColor.white
        
        self.genderTextField.inputView = self.thePicker
        self.districtTextField.inputView = self.thePicker

    }
    
    // MARK:Login Api Implementation
    @objc func backButtonAction(sender:UIButton!) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerTypeButtonClicked(_ sender: Any) {
        switch (sender as AnyObject).tag
        {
        case 0:      //when guardian isclicked...
            self.regiterTypeString = "Guardian"
            self.guardianButton.backgroundColor = UIColor.orange
            self.studentButton.backgroundColor = UIColor.white
            break
        case 1:      //when student is clicked...
            self.regiterTypeString = "Student"
            self.studentButton.backgroundColor = UIColor.orange
            self.guardianButton.backgroundColor = UIColor.white

            break
        default: print("Other...")
        }
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
        guard !(self.cnfPassTextField.text?.isEmpty)! else {
            self.showAlertController(alertMessage: "Please Enter Cofirm Password")
            return
        }
        guard (self.passwordTextField.text != self.cnfPassTextField.text) else {
            self.showAlertController(alertMessage: "Confirmed password not matched please try again.")
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
        dictionary.setValue(self.regiterTypeString, forKey: "register_type")
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
        dictionary.setValue(self.cityIdString, forKey: "s_city_ide")

        Alamofire.request(urlPath, method: .post, parameters: (dictionary as! [String:Any]), encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
                if response.result.isSuccess
                {
                    if let resultDictionary = response.result.value as? NSDictionary
                    {
                        if Int(resultDictionary["status"] as! String) == Constants.Status.StatusOK.rawValue
                        {
                            print(resultDictionary)
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }else if Int(resultDictionary["status"] as! String) == Constants.Status.TokenInvalid.rawValue
                        {
                            TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                                if status == Constants.Status.StatusOK.rawValue
                                {
                                    self.registrationApicall()
                                }else{
                                    print(token as Any)
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                }
                            })
                        }else{
                            TutorDefaultAlertController.showAlertController(alertMessage: resultDictionary["message"] as? String, showController: self)
                        }
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
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ action -> Void in
            // Put your code here
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.genderTextField {
            thePicker.tag = 0
        }
        else if textField == self.districtTextField {
            self.thePicker.tag = 1
            if self.cityArray.isEmpty == true {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.cityListApiCall()
            }
        }
        return true
    }
    
    func cityListApiCall() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.cityList) as String
        Alamofire.request(urlPath, method: .post, parameters: nil, encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
            if response.result.isSuccess
            {
                if let resultDictionary = response.result.value as? NSDictionary
                {
                    if let status = resultDictionary["status"] as? NSNumber
                    {
                        print(resultDictionary)
                        if let resultParseLoginDictionary = resultDictionary["Data"] as? NSArray {
                            print(resultParseLoginDictionary)

                            self.cityArray = resultParseLoginDictionary as! [Any]
                            self.thePicker.reloadAllComponents()
                        }
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    else if Int(resultDictionary["status"] as! String) == Constants.Status.TokenInvalid.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue
                            {
                                self.cityListApiCall()
                            }else{
                                print(token as Any)
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        })
                    }
                    else{
                        TutorDefaultAlertController.showAlertController(alertMessage: resultDictionary["message"] as? String, showController: self)
                    }
                }
            }
            else if response.result.isFailure {
                print(response.result.error as Any)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return cityArray.count
        }
        return gender.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            let postDictionary = cityArray[row] as? Dictionary<String,String>
            self.cityIdString = postDictionary?["city_id"]
            return postDictionary?["city_name"]
        }
        self.genderTypeString = gender[row]
        return gender[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            let postDictionary = cityArray[row] as? Dictionary<String,String>
            districtTextField.text = postDictionary?["city_name"]
            return
        }
        genderTextField.text = gender[row]
    }

}
