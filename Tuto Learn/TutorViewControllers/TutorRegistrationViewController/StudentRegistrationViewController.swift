//
//  StudentRegistrationViewController.swift
//  Tuto Learn
//
//  Created by Prashant Pandey on 07/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import Alamofire
import AAPickerView

class StudentRegistrationViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dobTextField: AAPickerView!
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
    @IBOutlet weak var agreeTCButton: UIButton!
    
    var dataArray :NSMutableArray?
    
    
    let gender = ["Male","Female"]
    let thePicker = UIPickerView()
    var cityArray = Array<Any>()
    var regiterTypeString : String?
    var genderTypeString : String?
    var cityIdString : String?

    // MARK:: View Life Cycle Methods

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
        
        self.regiterTypeString = "guardian"
        self.guardianButton.backgroundColor = UIColor.orange
        self.studentButton.backgroundColor = UIColor.white
        
        self.genderTextField.inputView = self.thePicker
        self.districtTextField.inputView = self.thePicker
        
        
        let registrationNameDetails: NSMutableDictionary? = ["First Name":"leftTitle","Last Name":"rightTitle","":"leftValue","":"rightValue","1":"type"]
        
        let registrationgenderDetails: NSMutableDictionary? = ["Gender":"leftTitle","Date of Birth":"rightTitle","":"leftValue","":"rightValue","2":"type"]

        let registrationEmailDetails: NSMutableDictionary? = ["Email":"leftTitle","Mobile":"rightTitle","":"leftValue","":"rightValue","3":"type"]
        
        let registrationNRICDetails: NSMutableDictionary? = ["NRIC/FIN":"leftTitle","":"rightTitle","":"leftValue","":"rightValue","4":"type"]
        
        let registrationPassDetails: NSMutableDictionary? = ["Password":"leftTitle","Confirm Password":"rightTitle","":"leftValue","":"rightValue","5":"type","Password should be minimum 8 character s with at least one special character and one capital letter and one number":"bottomValue"]
        
        let registrationAddress1Details: NSMutableDictionary? = ["Address line 1":"leftTitle","":"rightTitle","":"leftValue","":"rightValue","6":"type"]
        
        let registrationAddress2Details: NSMutableDictionary? = ["Address line 2":"leftTitle","":"rightTitle","":"leftValue","":"rightValue","7":"type"]


        let registrationDistrictDetails: NSMutableDictionary? = ["District":"leftTitle","":"rightTitle","":"leftValue","":"rightValue","8":"type"]
        
        let registrationPincodeDetails: NSMutableDictionary? = ["Pincode":"leftTitle","":"rightTitle","":"leftValue","":"rightValue","9":"type"]


        dataArray = NSMutableArray()
        dataArray?.add(registrationNameDetails ?? NSDictionary.init())
        dataArray?.add(registrationgenderDetails ?? NSDictionary.init())
        dataArray?.add(registrationEmailDetails ?? NSDictionary.init())
        dataArray?.add(registrationNRICDetails ?? NSDictionary.init())
        dataArray?.add(registrationPassDetails ?? NSDictionary.init())
        dataArray?.add(registrationAddress1Details ?? NSDictionary.init())
        dataArray?.add(registrationAddress2Details ?? NSDictionary.init())
        dataArray?.add(registrationDistrictDetails ?? NSDictionary.init())
        dataArray?.add(registrationPincodeDetails ?? NSDictionary.init())

        
    }
    
    // MARK:: Button Action
    @IBAction func registerTypeButtonClicked(_ sender: Any) {
        switch (sender as AnyObject).tag
        {
        case 0:      //when guardian isclicked...
            self.regiterTypeString = "guardian"
            self.guardianButton.backgroundColor = UIColor.orange
            self.studentButton.backgroundColor = UIColor.white
            break
        case 1:      //when student is clicked...
            self.regiterTypeString = "student"
            self.studentButton.backgroundColor = UIColor.orange
            self.guardianButton.backgroundColor = UIColor.white
            
            break
        default: print("Other...")
        }
    }
    @IBAction func agreeTnCButtonClicked(_ sender: Any) {
        if(self.agreeTCButton.isSelected) {
            self.agreeTCButton.isSelected = false
        }
        else {
            self.agreeTCButton.isSelected = true
        }
        
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        guard  !(self.firstNameTextField.text?.isEmpty)!  else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter First Name" , showController: self)
            return
        }
        guard !(self.lastNameTextField.text?.isEmpty)! else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Last Name" , showController: self)
            return
        }
        guard !(self.genderTextField.text?.isEmpty)! else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Gender" , showController: self)
            return
        }
        guard !(self.dobTextField.text?.isEmpty)! else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Date of Birth" , showController: self)
            return
        }
        guard (self.eMailTextField.text! as NSString).isValidEmail() else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Email" , showController: self)
            return
        }
        guard !(self.mobNoTextField.text?.isEmpty)! else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Mobile No" , showController: self)
            return
        }
        guard !(self.passwordTextField.text?.isEmpty)! else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Password" , showController: self)
            return
        }
        guard !(self.address1TextField.text?.isEmpty)! else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Address 1 Field" , showController: self)
            return
        }
        guard !(self.address2TextField.text?.isEmpty)! else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Address 2 Field" , showController: self)
            return
        }
        guard !(self.districtTextField.text?.isEmpty)! else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter District" , showController: self)
            return
        }
        guard !(self.pinCodeTextField.text?.isEmpty)! else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Pin Code" , showController: self)
            return
        }
        guard !(self.cnfPassTextField.text?.isEmpty)! else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Cofirm Password" , showController: self)
            return
        }
        guard (self.passwordTextField.text == self.cnfPassTextField.text) else {
            TutorDefaultAlertController.showAlertController(alertMessage: "Confirmed password not matched please try again." , showController: self)
            return
        }
//        guard (self.agreeTCButton.isSelected) else {
//            TutorDefaultAlertController.showAlertController(alertMessage: "Please select Terms and Conditions", showController: self)
//            return
//        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.registrationApicall()
    }
    
    @IBAction func canelButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonAction(sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:: Registration Api Implementation

    func registrationApicall() -> Void {
        
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.studentRegister) as String
        
        var dictionary = [String: String]()
    
        dictionary["register_type"] = self.regiterTypeString
        dictionary["s_name"] = self.firstNameTextField.text
        dictionary["s_lastname"] = self.lastNameTextField.text
        dictionary["s_mobile"] = self.mobNoTextField.text
        dictionary["s_email"] = self.eMailTextField.text
        dictionary["s_password"] = self.passwordTextField.text
        dictionary["s_dob"] = self.dobTextField.text
        dictionary["s_gender"] = self.genderTextField.text
        dictionary["s_address1"] = self.address1TextField.text
        dictionary["s_address2"] = self.address2TextField.text
        dictionary["s_pin"] = "400001"
        dictionary["s_nric"] = "L6783452H"
        dictionary["s_oauth"] = "Mobile"
        dictionary["s_city_id"] = self.cityIdString



//        dictionary.setValue(self.regiterTypeString, forKey: "register_type")
//        dictionary.setValue(self.firstNameTextField.text, forKey: "s_name")
//        dictionary.setValue(self.lastNameTextField.text, forKey: "s_lastname")
//        dictionary.setValue(self.mobNoTextField.text, forKey: "s_mobile")
//        dictionary.setValue(self.eMailTextField.text, forKey: "s_email")
//        dictionary.setValue(self.passwordTextField.text, forKey: "s_password")
//        dictionary.setValue(self.dobTextField.text, forKey: "s_dob")
//        dictionary.setValue(self.genderTextField.text, forKey: "s_gender")
//        dictionary.setValue(self.address1TextField.text, forKey: "s_address1")
//        dictionary.setValue(self.address2TextField.text, forKey: "s_address2")
//        dictionary.setValue("400001", forKey: "s_pin")
//        dictionary.setValue("L6783452H", forKey: "s_nric")
//        dictionary.setValue("Mobile", forKey: "s_oauth")
//        dictionary.setValue(self.cityIdString, forKey: "s_city_id")

        Alamofire.request(urlPath, method: .post, parameters: dictionary , encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
            if response.result.isSuccess
            {
                if let resultDictionary = response.result.value as? NSDictionary
                {
                    if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.StatusOK.rawValue
                    {
                        print(resultDictionary)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if let dataDictionary = resultDictionary["data"] as? [String : AnyObject] {
                            TutorSharedClass.shared.studentId = dataDictionary["s_id"] as? String
                        }
                        self.showAlertController(alertMessage: resultDictionary["message"] as? String)
                    }
                    else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenInvalid.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.cityListApiCall()
                            }
                            else {
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
    
    func cityListApiCall() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.cityList) as String
        Alamofire.request(urlPath, method: .post, parameters: nil, encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
            if response.result.isSuccess
            {
                if let resultDictionary = response.result.value as? NSDictionary
                {
                    if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.StatusOK.rawValue
                    {
                        print(resultDictionary)
                        if let resultParseLoginDictionary = resultDictionary["Data"] as? NSArray {
                            print(resultParseLoginDictionary)
                            self.cityArray = resultParseLoginDictionary as! [Any]
                            self.thePicker.reloadAllComponents()
                        }
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenInvalid.rawValue
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

    //MARK: Default AlertViewController
    func showAlertController(alertMessage:String?) -> Void {
        let alert = UIAlertController(title: "", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ action -> Void in
            // Put your code here
            let profilControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "TutorGuardianProfileViewController") as? TutorGuardianProfileViewController
            self.navigationController?.pushViewController(profilControllerObj!, animated: true)
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureDatePicker() -> Void {
        self.dobTextField.pickerType = .DatePicker
        self.dobTextField.datePicker?.datePickerMode = .date
        self.dobTextField.dateFormatter.dateFormat = "YYYY/MM/dd"
        self.dobTextField.dateDidChange = { date in
            print("selectedDate ", date )
            self.dobTextField.text = self.dobTextField.dateFormatter.string(from: date)
        }
    }
    
    //MARK:: TextField Delegate & Datasource

    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        if textField == self.genderTextField {
            return false; //do not show keyboard nor cursor
        }
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
        else if textField == self.dobTextField {
            self.configureDatePicker()
        }
        return true
    }
    
    //MARK:: PickerView Delegate & Datasource

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
            self.districtTextField.text = postDictionary?["city_name"]
            return postDictionary?["city_name"]
        }
        self.genderTypeString = gender[row]
        self.genderTextField.text = self.genderTypeString
        return gender[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            let postDictionary = cityArray[row] as? Dictionary<String,String>
            districtTextField.text = postDictionary?["city_name"]
            return
        }
        genderTextField.text = gender[row]
    }

}
