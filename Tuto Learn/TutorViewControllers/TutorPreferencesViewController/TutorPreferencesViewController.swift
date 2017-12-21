//
//  TutorPreferencesViewController.swift
//  Tuto Learn

import UIKit
import SideMenu
import Alamofire

enum PreferencesDataType:Int {
    case PreferencesDataTypeContact = 1, PreferencesDataTypeTimeOfContact
}

class TutorPreferencesViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate
{
    
    @IBOutlet weak var tutorNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var preferencesTableview: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var dataArray :NSMutableArray?
    
    var thePicker = UIPickerView()
    var preferenceData :NSDictionary?
    
    var preferenceTimeOfContact = ["Anytime","9:00 AM to 12:00 PM","12:00 PM to 3:00 PM","3:00 PM to 6:00 PM","6:00 PM to 9:00 PM"]
    var preferenceModeOfContact = ["Email","Phone","Both Email and Phone","Do not Disturb"]
    var preferenceTutionType = ["One-on-One","Group"]
    var preferenceTutorGender = ["Male","Female","Any"]
    
    var genderValue: String!
    var timeOfContactValue: String!
    var modeOfContactValue: String!
    var tutionTypeValue: String!
    var isfromLoginAPI: Bool = false

    var isfromMyAccount: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.thePicker.delegate = self
        self.thePicker.dataSource = self
        self.setHeaderView()
        self.setFooterView()
        self.setupSideMenu()
        self.setPreferencesData()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getpreferenceData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuWidth = (Constants.phoneScreenWidth-120)
        // Set up a cool background image for demo purposes
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
    }
    func setPreferencesData()
    {
        let contactDetails: NSMutableDictionary? = ["leftTitle":"Time of Contact","rightTitle":"Mode of Contact","leftValue":self.preferenceData?.value(forKey: "sp_contact_time") as? String ?? "","rightValue":self.preferenceData?.value(forKey: "sp_contact_mode") as? String ?? "","type":NSNumber.init(value: PreferencesDataType.PreferencesDataTypeTimeOfContact.rawValue)]
        
        let tutorDetails: NSMutableDictionary? = ["leftTitle":"Tution Type","rightTitle":"Preferred Tutor Gender","leftValue":self.preferenceData?.value(forKey: "sp_tution_type") as? String ?? "","rightValue":self.preferenceData?.value(forKey: "sp_prefer_gender") as? String ?? "","type":NSNumber.init(value: PreferencesDataType.PreferencesDataTypeContact.rawValue)]

        
        dataArray = NSMutableArray()
        dataArray?.add(contactDetails ?? NSDictionary.init())
        dataArray?.add(tutorDetails ?? NSDictionary.init())
        
        self.preferencesTableview.estimatedRowHeight = 60.0
        self.preferencesTableview.rowHeight = UITableViewAutomaticDimension
        if isfromLoginAPI == true
        {
            self.tutorNavigationBar.leftBarButton.isHidden = true

        }else
        {
            self.tutorNavigationBar.leftBarButton.isHidden = false
        }
        self.tutorNavigationBar.rightBarButton.isHidden = false
        self.tutorNavigationBar.navigationTitleLabel.text = "Your Profile"
        self.tutorNavigationBar.leftBarButton.addTarget(self, action: #selector(backButtonAction), for:.touchUpInside)
        self.tutorNavigationBar.rightBarButton.addTarget(self, action: #selector(menuClickAction), for:.touchUpInside)
        self.preferencesTableview.reloadData()

        if isfromMyAccount == true
        {
            self.tutorNavigationBar.leftBarButton.isHidden = false
            self.tutorNavigationBar.rightBarButton.isHidden = true
        }

    }
    
    func setHeaderView()  {
        self.titleLabel.text = "Preferences"
    }
    
    func setFooterView()  {
        self.submitButton.layer.cornerRadius = 5.0;
    }

    //MARK :: Tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "registrationCell", for: indexPath) as? RegistrationTableViewCell
        cell?.updateLayout(registrationData: self.dataArray?.object(at: indexPath.row) as! NSDictionary, cellType: RegistrationCellType.RegistrationCellTypPreference)
        cell?.leftTextField.delegate = self
        cell?.rightTextField.delegate = self
        cell?.leftTextField.tag = indexPath.row
        cell?.rightTextField.tag = indexPath.row
        return cell!
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
            if datadictionary?.value(forKey: "type") as? Int == PreferencesDataType.PreferencesDataTypeTimeOfContact.rawValue && textFieldTemp.customTag == 1
            {
                self.thePicker = UIPickerView()
                self.thePicker.delegate = self
                self.thePicker.dataSource = self
                self.thePicker.tag = 101
                textFieldTemp.inputView = self.thePicker
                self.thePicker.reloadAllComponents()
                timeOfContactValue = preferenceTimeOfContact[0]
            }
            else if datadictionary?.value(forKey: "type") as? Int == PreferencesDataType.PreferencesDataTypeTimeOfContact.rawValue && textFieldTemp.customTag == 2
            {
                self.thePicker = UIPickerView()
                self.thePicker.delegate = self
                self.thePicker.dataSource = self
                self.thePicker.tag = 102
                textFieldTemp.inputView = self.thePicker
                self.thePicker.reloadAllComponents()
                modeOfContactValue = preferenceModeOfContact[0]

            }else if datadictionary?.value(forKey: "type") as? Int == PreferencesDataType.PreferencesDataTypeContact.rawValue && textFieldTemp.customTag == 1
            {
                self.thePicker = UIPickerView()
                self.thePicker.delegate = self
                self.thePicker.dataSource = self
                self.thePicker.tag = 103
                textFieldTemp.inputView = self.thePicker
                self.thePicker.reloadAllComponents()
                tutionTypeValue = preferenceTutionType[0]

            }else if datadictionary?.value(forKey: "type") as? Int == PreferencesDataType.PreferencesDataTypeContact.rawValue && textFieldTemp.customTag == 2
            {
                self.thePicker = UIPickerView()
                self.thePicker.delegate = self
                self.thePicker.dataSource = self
                self.thePicker.tag = 104
                textFieldTemp.inputView = self.thePicker
                self.thePicker.reloadAllComponents()
                genderValue = preferenceTutorGender[0]

            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let textFieldTemp =  textField as? CustomTextField
        {
            let datadictionary = self.dataArray?.object(at: textField.tag) as? NSMutableDictionary
            if datadictionary?.value(forKey: "type") as? Int == PreferencesDataType.PreferencesDataTypeTimeOfContact.rawValue && textFieldTemp.customTag == 1
            {
                if (timeOfContactValue != nil)
                {
                    datadictionary?["leftValue"] = timeOfContactValue
                }else
                {
                    datadictionary?["leftValue"] = preferenceTimeOfContact[0]
                    
                }
                preferencesTableview.reloadData()
            }
            else if datadictionary?.value(forKey: "type") as? Int == PreferencesDataType.PreferencesDataTypeTimeOfContact.rawValue && textFieldTemp.customTag == 2
            {
                if (modeOfContactValue != nil)
                {
                    datadictionary?["rightValue"] = modeOfContactValue
                }else
                {
                    datadictionary?["rightValue"] = preferenceModeOfContact[0]
                }
                preferencesTableview.reloadData()
                
            }else if datadictionary?.value(forKey: "type") as? Int == PreferencesDataType.PreferencesDataTypeContact.rawValue && textFieldTemp.customTag == 1
            {
                if (tutionTypeValue != nil)
                {
                    datadictionary?["leftValue"] = tutionTypeValue
                }else
                {
                    datadictionary?["leftValue"] = preferenceTutionType[0]
                    
                }
                preferencesTableview.reloadData()
            }else if datadictionary?.value(forKey: "type") as? Int == PreferencesDataType.PreferencesDataTypeContact.rawValue && textFieldTemp.customTag == 2
            {
                if (genderValue != nil)
                {
                    datadictionary?["rightValue"] = genderValue
                }else
                {
                    datadictionary?["rightValue"] = preferenceTutorGender[0]
                    
                }
                preferencesTableview.reloadData()
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
        if pickerView.tag == 101
        {
            return preferenceTimeOfContact.count
        }else if pickerView.tag == 102
        {
            return preferenceModeOfContact.count
        }else if pickerView.tag == 103
        {
            return preferenceTutionType.count
        }else if pickerView.tag == 104
        {
            return preferenceTutorGender.count
        }else
        {
            return 0
        }
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 101
        {
            return preferenceTimeOfContact[row]
        }else if pickerView.tag == 102
        {
            return preferenceModeOfContact[row]
        }else if pickerView.tag == 103
        {
            return preferenceTutionType[row]
        }else if pickerView.tag == 104
        {
            return preferenceTutorGender[row]
        }else
        {
            return ""
        }
    }
    
    // When user selects an option, this function will set the text of the text field to reflect the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 101
        {
            timeOfContactValue = preferenceTimeOfContact[row]
        }else if pickerView.tag == 102
        {
            modeOfContactValue = preferenceModeOfContact[row]
        }else if pickerView.tag == 103
        {
            tutionTypeValue = preferenceTutionType[row]
        }else if pickerView.tag == 104
        {
            genderValue = preferenceTutorGender[row]
        }
    }
    
    //Mark:: Save Button Click
    @IBAction func submitButtonClicked(sender: AnyObject)
    {
        self.view.endEditing(true)
        var isValidate:Bool
        isValidate = true
        var parameterData = [String: String]()
        
        for dataDictionary in self.dataArray! {
            if let dataContent = dataDictionary as? NSMutableDictionary
            {
                if dataContent["type"] as? Int == PreferencesDataType.PreferencesDataTypeTimeOfContact.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please select time of contact" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["contact_time"] = leftValue
                    }
                    let rightValue =  dataContent["rightValue"] as? String
                    if (rightValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please select mode of contact" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["conact_mode"] = rightValue
                        
                    }
                }else if dataContent["type"] as? Int == PreferencesDataType.PreferencesDataTypeContact.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please select tution type" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["tution_type"] = leftValue
                    }
                    let rightValue =  dataContent["rightValue"] as? String
                    if (rightValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please select preferred tutor gender" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["tutor_gender"] = rightValue
                    }
                }
            }
        }
        
        if isValidate == true
        {
            // perform API Action
            parameterData["student_id"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_id
            MBProgressHUD.showAdded(to: self.view, animated: true)

            self.callUpdatePreferenceDetails(parameterData: parameterData)
        }
    }
    
    @objc func backButtonAction(sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func menuClickAction(sender:UIButton!) {
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    
    func getpreferenceData() {
        
        var parameterData = [String: String]()
        parameterData["user_id"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_id
        parameterData["register_type"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type
        
         print(parameterData);
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.preferenceDetails) as String
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
                        if let resultParseLoginDictionary = resultDictionary.object(forKey: "data") as? NSDictionary
                        {
                            self.preferenceData = resultParseLoginDictionary
                            self.setPreferencesData()

                        }
                        
                    }
                    else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.getpreferenceData()
                            }
                            else {
                                print(token as Any)
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        })
                    }else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.getpreferenceData()
                            }
                            else {
                                print(token as Any)
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        })
                    }
                    else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                      //  TutorDefaultAlertController.showAlertController(alertMessage: resultDictionary["message"] as? String, showController: self)
                    }
                }
            }
            else if response.result.isFailure {
                MBProgressHUD.hide(for: self.view, animated: true)
                print(response.result.error as Any)
            }
        }
    }
    
    func callUpdatePreferenceDetails(parameterData:Dictionary<String, String>)  {
        
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.updatePreference) as String
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
                        self.showAlertController(alertMessage: resultDictionary["message"] as? String)
                    }
                    else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.callUpdatePreferenceDetails(parameterData: parameterData)
                            }
                            else {
                                print(token as Any)
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        })
                    }else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.callUpdatePreferenceDetails(parameterData: parameterData)
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
    
    func showAlertController(alertMessage:String?) -> Void {
        let alert = UIAlertController(title: "", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ action -> Void in
            TutorSharedClass.shared.loginTutorLoginObject?.sm_preference = 1
            TutorSharedClass.shared.loginTutorLoginObject?.sm_profile = 1

            TutorSharedClass.shared.updateLocalValue()
            TutorSharedClass.shared.setrootViewControllerAfterLogin(window: UIApplication.shared.keyWindow!)
        })
        self.present(alert, animated: true, completion: nil)
    }
}
