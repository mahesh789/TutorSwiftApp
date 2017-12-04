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

enum RegistrationDataType:Int {
    case RegistrationDataTypeFirstName = 1,RegistrationDataTypeGender,RegistrationDataTypeEmail,RegistrationDataTypeMobile,RegistrationDataTypePassword,RegistrationDataTypeAddress1,RegistrationDataTypeAddress2,RegistrationDataTypeDistrict,RegistrationDataTypePincode
}

enum RegistrationCellType:Int {
    case RegistrationCellTypeRegistration = 1,RegistrationCellTypeGuardianProfile,RegistrationCellTypeFindTutor,RegistrationCellTypeStudentProfile
}

class StudentRegistrationViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var registrationTableview: UITableView!
    @IBOutlet weak var gaurdianButton: UIButton!
    @IBOutlet weak var studentButton: UIButton!
    @IBOutlet weak var registrationFooterView: RegistrationFooterView!
    var genderValue: String!
    var districtValue: NSDictionary!
    
    
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
    //@IBOutlet weak var studentButton: UIButton!
    // @IBOutlet weak var guardianButton: UIButton!
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
        //  self.contentView.backgroundColor = UIColor.tutorAppBackgroungColor()
        
        self.regiterTypeString = "guardian"
        //        self.guardianButton.backgroundColor = UIColor.orange
        //        self.studentButton.backgroundColor = UIColor.white
        //
        //        self.genderTextField.inputView = self.thePicker
        //        self.districtTextField.inputView = self.thePicker
        
        
        let registrationNameDetails: NSMutableDictionary? = ["leftTitle":"First Name","rightTitle":"Last Name","leftValue":"","rightValue":"","type":NSNumber.init(value: RegistrationDataType.RegistrationDataTypeFirstName.rawValue) ]
        
        let registrationgenderDetails: NSMutableDictionary? = ["leftTitle":"Gender","rightTitle":"Date of Birth","leftValue":"","rightValue":"","type":NSNumber.init(value: RegistrationDataType.RegistrationDataTypeGender.rawValue)]
        
        let registrationEmailDetails: NSMutableDictionary? = ["leftTitle":"Email","rightTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: RegistrationDataType.RegistrationDataTypeEmail.rawValue)]
        
        let registrationNRICDetails: NSMutableDictionary? = ["leftTitle":"Mobile","rightTitle":"NRIC/FIN","leftValue":"","rightValue":"","type":NSNumber.init(value: RegistrationDataType.RegistrationDataTypeMobile.rawValue)]
        
        let registrationPassDetails: NSMutableDictionary? = ["leftTitle":"Password","rightTitle":"Confirm Password","leftValue":"","rightValue":"","type":NSNumber.init(value: RegistrationDataType.RegistrationDataTypePassword.rawValue),"bottomValue":"Password should be minimum 8 character s with at least one special character and one capital letter and one number"]
        
        let registrationAddress1Details: NSMutableDictionary? = ["rightTitle":"Address line 1","leftTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: RegistrationDataType.RegistrationDataTypeAddress1.rawValue)]
        
        let registrationAddress2Details: NSMutableDictionary? = ["rightTitle":"Address line 2","leftTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: RegistrationDataType.RegistrationDataTypeAddress2.rawValue)]
        
        
        let registrationDistrictDetails: NSMutableDictionary? = ["leftTitle":"District","rightTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: RegistrationDataType.RegistrationDataTypeDistrict.rawValue)]
        
        let registrationPincodeDetails: NSMutableDictionary? = ["leftTitle":"Pincode","rightTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: RegistrationDataType.RegistrationDataTypePincode.rawValue)]
        
        
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
        
        self.registrationTableview.estimatedRowHeight = 60.0
        self.registrationTableview.rowHeight = UITableViewAutomaticDimension
        
        self.gaurdianButton.isSelected = true
        self.studentButton.isSelected = false
        self.registrationFooterView.updateViewLayout();
        
    }
    
    //MARK :: Tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "registrationCell", for: indexPath) as? RegistrationTableViewCell
        cell?.updateLayout(registrationData: self.dataArray?.object(at: indexPath.row) as! NSDictionary, cellType: RegistrationCellType.RegistrationCellTypeRegistration)
        cell?.leftTextField.delegate = self
        cell?.rightTextField.delegate = self
        cell?.leftTextField.tag = indexPath.row
        cell?.rightTextField.tag = indexPath.row
        return cell!
    }
    
    
    // MARK:: Header Button Action
    @IBAction func headerButtonClicked(_ sender: UIButton)
    {
        if sender.tag == 101
        {
            self.gaurdianButton.isSelected = true
            self.studentButton.isSelected = false
        }else
        {
            self.gaurdianButton.isSelected = false
            self.studentButton.isSelected = true
        }
    }
    
    
    
    
    
    // MARK:: Button Action
    @IBAction func registerTypeButtonClicked(_ sender: Any) {
        switch (sender as AnyObject).tag
        {
        case 0:      //when guardian isclicked...
            self.regiterTypeString = "guardian"
            //  self.guardianButton.backgroundColor = UIColor.orange
            self.studentButton.backgroundColor = UIColor.white
            break
        case 1:      //when student is clicked...
            self.regiterTypeString = "student"
            self.studentButton.backgroundColor = UIColor.orange
            //self.guardianButton.backgroundColor = UIColor.white
            
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
    
   
    //MARK: Default AlertViewController
    func showAlertController(alertMessage:String?) -> Void {
        let alert = UIAlertController(title: "", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ action -> Void in
            // Put your code here
//            let profilControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "TutorGuardianProfileViewController") as? TutorGuardianProfileViewController
            self.navigationController?.popViewController(animated: true)
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureDatePicker(textField:AAPickerView) -> Void {
        textField.pickerType = .DatePicker
        textField.datePicker?.datePickerMode = .date
        textField.dateFormatter.dateFormat = Constants.dateFormatValue
        textField.dateDidChange = { date in
            print("selectedDate ", date )
            textField.text = textField.dateFormatter.string(from: date)
        }
    }
    
    //MARK:: TextField Delegate & Datasource
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
     
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        if let textFieldTemp =  textField as? CustomTextField
        {
            textFieldTemp.inputView = nil
            textFieldTemp.inputAccessoryView = nil;
            let datadictionary = self.dataArray?.object(at: textField.tag) as? NSMutableDictionary
            if datadictionary?.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeGender.rawValue && textFieldTemp.customTag == 2
            {
                self.configureDatePicker(textField: textFieldTemp)
            }
            else if datadictionary?.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeDistrict.rawValue && textFieldTemp.customTag == 1
            {
                textFieldTemp.inputView = self.thePicker
                self.thePicker.tag = 1
                if self.cityArray.isEmpty == true {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    self.cityListApiCall(districTextField: textFieldTemp)
                }
            }
            else if datadictionary?.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeGender.rawValue && textFieldTemp.customTag == 1
            {
                self.thePicker.tag = 0
                textFieldTemp.inputView = self.thePicker
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldTemp =  textField as? CustomTextField
        {
            let datadictionary = self.dataArray?.object(at: textField.tag) as? NSMutableDictionary
            if datadictionary?.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeDistrict.rawValue && textFieldTemp.customTag == 1
            {
                if (districtValue != nil)
                {
                    datadictionary?["leftValue"] = districtValue?["city_name"]
                }else
                {
                    if cityArray.isEmpty == false
                    {
                        let districtData = cityArray[0] as? NSDictionary
                        datadictionary?["leftValue"] = districtData?["city_name"]
                        districtValue = districtData
                    }
                }
                registrationTableview.reloadData()

            }
            else if datadictionary?.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeGender.rawValue && textFieldTemp.customTag == 1
            {
                if (genderValue != nil)
                {
                    datadictionary?["leftValue"] = genderValue
                }else
                {
                    datadictionary?["leftValue"] = gender[0]

                }
                registrationTableview.reloadData()

                
            }else if textFieldTemp.customTag == 1
            {
                datadictionary?["leftValue"] = textFieldTemp.text
            }else if textFieldTemp.customTag == 2
            {
                datadictionary?["rightValue"] = textFieldTemp.text
            }
        }
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
            //  self.districtTextField.text = postDictionary?["city_name"]
            return postDictionary?["city_name"]
        }
        self.genderTypeString = gender[row]
        //  self.genderTextField.text = self.genderTypeString
        return gender[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            if cityArray.isEmpty == false
            {
                let postDictionary = cityArray[row] as? NSDictionary
                districtValue = postDictionary
                return
            }
        }
        genderValue = gender[row]
    }
    
    
    
    
    //MARK:: Registration Button Action and API Call
    
    @IBAction func submitButtonClicked(_ sender: Any) {
   
        self.view.endEditing(true)
        var isValidate:Bool
        isValidate = true
        var parameterData = [String: String]()

        for dataDictionary in self.dataArray! {
            if let dataContent = dataDictionary as? NSMutableDictionary
            {
                if dataContent["type"] as? Int == RegistrationDataType.RegistrationDataTypeFirstName.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter first name" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["s_name"] = leftValue
                    }
                    let rightValue =  dataContent["rightValue"] as? String
                    if (rightValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter last name" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["s_lastname"] = rightValue
                        
                    }
                }else if dataContent["type"] as? Int == RegistrationDataType.RegistrationDataTypeGender.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please select gender" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["s_gender"] = leftValue
                    }
                    let rightValue =  dataContent["rightValue"] as? String
                    if (rightValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please select date of birth" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        let dateFormatterValue = DateFormatter()
                        dateFormatterValue.dateFormat = Constants.dateFormatValue
                        let date = dateFormatterValue.date(from: rightValue!)!
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
                        let myDOB = Calendar.current.date(from: components)!
                       
                        if gaurdianButton.isSelected == true
                        {
                            if myDOB.age < 18
                            {
                                TutorDefaultAlertController.showAlertController(alertMessage: "Minimum 18 years required to register as guardian" , showController: self)
                                isValidate = false
                                break;
                            }else
                            {
                                parameterData["s_dob"] = rightValue

                            }
                            
                        }else
                        {
                            if myDOB.age < 3
                            {
                                TutorDefaultAlertController.showAlertController(alertMessage: "Minimum 3 years required to register as student" , showController: self)
                                isValidate = false
                                break;
                            }else
                            {
                                parameterData["s_dob"] = rightValue

                            }
                        }
                        
                    }
                }else if dataContent["type"] as? Int == RegistrationDataType.RegistrationDataTypeEmail.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? NSString
                    if leftValue?.length == 0
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter email address" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        if leftValue?.isValidEmail() == true
                        {
                            parameterData["s_email"] = leftValue as String?
                        }else
                        {
                            TutorDefaultAlertController.showAlertController(alertMessage: "Please enter valid email address" , showController: self)
                            isValidate = false
                            break;
                        }
                        
                    }
                 
                }
                else if dataContent["type"] as? Int == RegistrationDataType.RegistrationDataTypeMobile.rawValue
                {
                    
                    let rightValue =  dataContent["leftValue"] as? String
                    if (rightValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter mobile no" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        if (rightValue?.count)!<10
                        {
                            TutorDefaultAlertController.showAlertController(alertMessage: "The Mobile Number must be at least 10 characters in length" , showController: self)
                            isValidate = false
                            break;
                        }else
                        {
                            parameterData["s_mobile"] = rightValue
                        }
                        
                    }
                    
                    let leftValue =  dataContent["rightValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter NRIC/FIN" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["s_nric"] = leftValue
                        
                    }
                    
                }else if dataContent["type"] as? Int == RegistrationDataType.RegistrationDataTypePassword.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? NSString
                    if leftValue?.length == 0
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter password" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["s_password"] = leftValue! as String
                        
                    }
                    let rightValue =  dataContent["rightValue"] as? String
                    if (rightValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter confirm password" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        if  leftValue?.isEqual(to: rightValue!) == false
                        {
                            TutorDefaultAlertController.showAlertController(alertMessage: "Password and confirm password does not match" , showController: self)
                            isValidate = false
                            break;
                        }else if leftValue?.isValidPassword() == false
                        {
                            TutorDefaultAlertController.showAlertController(alertMessage: dataContent["bottomValue"] as? String , showController: self)
                            isValidate = false
                        }
                    }
                }
                else if dataContent["type"] as? Int == RegistrationDataType.RegistrationDataTypeAddress1.rawValue
                {
                    let rightValue =  dataContent["rightValue"] as? String
                    if (rightValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter address 1 field" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["s_address1"] = rightValue
                        
                    }
                }
                else if dataContent["type"] as? Int == RegistrationDataType.RegistrationDataTypeAddress2.rawValue
                {
                    let rightValue =  dataContent["rightValue"] as? String
                    if (rightValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter address 2 field" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["s_address2"] = rightValue
                        
                    }
                }
                else if dataContent["type"] as? Int == RegistrationDataType.RegistrationDataTypeDistrict.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please select district" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        if (districtValue != nil)
                        {
                            parameterData["s_city_id"] = districtValue["city_id"] as? String
                        }
                        
                    }
                }else if dataContent["type"] as? Int == RegistrationDataType.RegistrationDataTypePincode.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter pincode" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["s_pin"] = leftValue
                        
                    }
                }
            }
        }
        
        if isValidate == true
        {
            if registrationFooterView.checkBoxButton.isSelected == true
            {
                if gaurdianButton.isSelected == true
                {
                    parameterData["register_type"] = "guardian"
                }else
                {
                    parameterData["register_type"] = "student"
                }
                parameterData["s_oauth"] = "Mobile"
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.registrationApicall(parameterData: parameterData)
            }else
            {
                TutorDefaultAlertController.showAlertController(alertMessage: "Please accept terms and condition" , showController: self)

            }
        }
        
        
        
       
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBoxButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @objc func backButtonAction(sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:: Registration Api Implementation
    
    func registrationApicall(parameterData:Dictionary<String, String>) -> Void {
        
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.studentRegister) as String
        print(parameterData)
        Alamofire.request(urlPath, method: .post, parameters:parameterData , encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
            if response.result.isSuccess
            {
                if let resultDictionary = response.result.value as? NSDictionary
                {
                    print(resultDictionary)

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
                                //self.cityListApiCall()
                            }
                            else {
                                print(token as Any)
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        })
                    }
                    else{
                        MBProgressHUD.hide(for: self.view, animated: true)

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
    
    func cityListApiCall(districTextField:AAPickerView) -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.cityList) as String
        Alamofire.request(urlPath, method: .post, parameters: nil, encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
            if response.result.isSuccess
            {
                if let resultDictionary = response.result.value as? NSDictionary
                {
                    let statusCode:Int
                    
                    if let statusValue = resultDictionary["status"] as? NSString
                    {
                        statusCode = statusValue.integerValue
                    }else
                    {
                       statusCode = Int(truncating: resultDictionary["status"] as! NSNumber)
                    }
                    
                    
                    if statusCode == Constants.Status.StatusOK.rawValue
                    {
                        print(resultDictionary)
                        if let resultParseLoginDictionary = resultDictionary["data"] as? NSArray {
                            print(resultParseLoginDictionary)
                            self.cityArray = resultParseLoginDictionary as! [Any]
                            self.thePicker.reloadAllComponents()
                        }
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    else if statusCode == Constants.Status.TokenInvalid.rawValue || statusCode == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue
                            {
                                self.cityListApiCall(districTextField: districTextField)
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
    
}
