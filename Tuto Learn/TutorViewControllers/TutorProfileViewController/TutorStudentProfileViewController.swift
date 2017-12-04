//
//  StudentProfileViewController.swift
//  Tuto Learn
//
//  Created by Reliance Jio on 12/3/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import SideMenu
import AAPickerView

enum StudentProfileDataType:Int {
    case StudentProfileDataTypeFirstName = 1,StudentProfileDataTypeGender,StudentProfileDataTypeEmail,StudentProfileDataTypeMobile,StudentProfileDataTypeSchoolName,StudentProfileDataTypeBoardName,StudentProfileDataTypeLevel
}
class TutorStudentProfileViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var profileTableview: UITableView!
    var dataArray :NSMutableArray?
    @IBOutlet weak var tutorNavigationBar: TutorHomeNavigationBar!
    @IBOutlet weak var submitButton: UIButton!
    let thePicker = UIPickerView()
    let genderArray = ["Male","Female"]
    var genderValue: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        thePicker.delegate = self;
        thePicker.dataSource = self
        self.dataArray = NSMutableArray()
        self.profileTableview.estimatedRowHeight = 60.0
        self.profileTableview.rowHeight = UITableViewAutomaticDimension
        self.tutorNavigationBar.rightBarButton.isHidden = false
        self.tutorNavigationBar.navigationTitleLabel.text = "Your Profile"
        self.tutorNavigationBar.leftBarButton.isHidden = false
        self.setProfileData()
        self.tutorNavigationBar.leftBarButton.addTarget(self, action: #selector(backButtonAction), for:.touchUpInside)
        self.tutorNavigationBar.rightBarButton.addTarget(self, action: #selector(menuClickAction), for:.touchUpInside)
        self.submitButton.layer.cornerRadius = 5.0;
        self.setupSideMenu()

        // Do any additional setup after loading the view.
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func getProfileData() ->NSMutableDictionary {
        
        let profileNameDetails: NSMutableDictionary? = ["leftTitle":"First Name","rightTitle":"Last Name","leftValue":"","rightValue": "" ,"type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeFirstName.rawValue)]
        
        let profilegenderDetails: NSMutableDictionary? = ["leftTitle":"Gender","rightTitle":"Date of Birth","leftValue": "","rightValue":"","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeGender.rawValue)]
        
        let profileEmailDetails: NSMutableDictionary? = ["rightTitle":"Email","leftTitle":"","leftValue":"","rightValue": "","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeEmail.rawValue)]
        
        let profileMobileDetails: NSMutableDictionary? = ["leftTitle":"Mobile","rightTitle":"","leftValue": "","rightValue":"","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeMobile.rawValue)]
        
        let profileSchoolDetail: NSMutableDictionary? = ["rightTitle":"Name of School(optional)","leftTitle":"","leftValue":"","rightValue": "","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeSchoolName.rawValue)]
        
        let profileBoardDetails: NSMutableDictionary? = ["leftTitle":"Board","rightTitle":"Level","leftValue": "","rightValue":"","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeBoardName.rawValue)]

        let tempDataArray = NSMutableArray()
        tempDataArray.add(profileNameDetails ?? NSDictionary.init())
        tempDataArray.add(profilegenderDetails ?? NSDictionary.init())
        tempDataArray.add(profileEmailDetails ?? NSDictionary.init())
        tempDataArray.add(profileMobileDetails ?? NSDictionary.init())
        tempDataArray.add(profileSchoolDetail ?? NSDictionary.init())
        tempDataArray.add(profileBoardDetails ?? NSDictionary.init())

        let studentDataDictionary = NSMutableDictionary()
        studentDataDictionary.setValue(tempDataArray, forKey: "student")
        
        return studentDataDictionary
    }

    func setProfileData()  {
        
        self.dataArray?.add(self.getProfileData())
        print(self.dataArray ?? "")
        self.profileTableview.reloadData()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK :: Tableview delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.dataArray?.count)!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 205
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerview = UINib(nibName: "TutorStudentHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
        if let tempHederView = headerview as? TutorStudentHeaderView
        {
            tempHederView.closeButton.tag = section
            tempHederView.closeButton.addTarget(self, action: #selector(deleteStudentClicked(sender:)), for: .touchUpInside)
            if section == 0
            {
                tempHederView.closeButton.isHidden = true
            }else
            {
                tempHederView.closeButton.isHidden = false
            }
        }
        return headerview
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (self.dataArray?.count)!-1 == section
        {
            return 50

        }else
        {
            return 10

        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if (self.dataArray?.count)!-1 == section 
        {
            let addButton = UIButton.init(type: .custom)
            addButton.frame = CGRect(x: 10, y: 10, width: 200, height: 30)
            addButton.setTitle("Add another student", for: .normal)
            addButton.setTitleColor(UIColor.white, for: .normal)
            addButton.addTarget(self, action: #selector(addStudentClicked(sender:)), for: .touchUpInside)
            
            let footerView = UIView.init(frame: CGRect(x: 20, y: 0, width: Constants.phoneScreenWidth, height: 50))
            footerView.backgroundColor = UIColor.clear
            footerView.addSubview(addButton)
            return footerView
        }else
        {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let studentData = self.dataArray?.object(at: section) as? NSMutableDictionary
        {
            if let studentArray = studentData.value(forKey: "student") as? NSMutableArray
            {
                return studentArray.count;
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "registrationCell", for: indexPath) as? RegistrationTableViewCell
        
        if let studentData = self.dataArray?.object(at: indexPath.section) as? NSMutableDictionary
        {
            if let studentArray = studentData.value(forKey: "student") as? NSMutableArray
            {
                cell?.updateLayout(registrationData: studentArray.object(at: indexPath.row) as! NSDictionary, cellType: RegistrationCellType.RegistrationCellTypeStudentProfile)
            }
        }
        cell?.leftTextField.section = indexPath.section
        cell?.rightTextField.section = indexPath.section
        cell?.leftTextField.delegate = self
        cell?.rightTextField.delegate = self
        cell?.leftTextField.tag = indexPath.row
        cell?.rightTextField.tag = indexPath.row
        return cell!
    }
    
    @objc func addStudentClicked(sender:UIButton)  {
        
        self.setProfileData()
        
        if let studentData = self.dataArray?.object(at: (self.dataArray?.count)!-1) as? NSMutableDictionary
        {
            if let studentArray = studentData.value(forKey: "student") as? NSMutableArray
            {
                self.profileTableview.scrollToRow(at: IndexPath.init(row: studentArray.count/2 + 1, section: (self.dataArray?.count)!-1), at: .none, animated: true)
            }
        }
        
    }
    @objc func deleteStudentClicked(sender:UIButton)  {
        self.dataArray?.removeObject(at: sender.tag);
        self.profileTableview.reloadData();
    }

    @objc func backButtonAction(sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitButtonClicked()
    {
        self.view.endEditing(true)
        var isValidate:Bool
        isValidate = true
        let parameterStudent = NSMutableArray()
        
        for dataDictionary in self.dataArray! {
            if let dataSectionContent = dataDictionary as? NSMutableDictionary
            {
                if let studentArray = dataSectionContent["student"] as? NSMutableArray
                {
                    var parameterData = [String: String]()
                    
                    for dataDictionary in studentArray {
                        if let dataContent = dataDictionary as? NSMutableDictionary
                        {
                            if dataContent["type"] as? Int == StudentProfileDataType.StudentProfileDataTypeFirstName.rawValue
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
                            }else if dataContent["type"] as? Int == StudentProfileDataType.StudentProfileDataTypeGender.rawValue
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
                            }else if dataContent["type"] as? Int == StudentProfileDataType.StudentProfileDataTypeEmail.rawValue
                            {
                                let leftValue =  dataContent["rightValue"] as? NSString
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
                            else if dataContent["type"] as? Int == StudentProfileDataType.StudentProfileDataTypeMobile.rawValue
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
                                
                            }
                            else if dataContent["type"] as? Int == StudentProfileDataType.StudentProfileDataTypeSchoolName.rawValue
                            {
                                let rightValue =  dataContent["rightValue"] as? String
                                if (rightValue?.isEmpty)!
                                {
                                }else
                                {
                                    parameterData["s_occupation"] = rightValue
                                    
                                }
                            }
                           
                            else if dataContent["type"] as? Int == StudentProfileDataType.StudentProfileDataTypeBoardName.rawValue
                            {
                                let leftValue =  dataContent["leftValue"] as? String
                                if (leftValue?.isEmpty)!
                                {
                                    TutorDefaultAlertController.showAlertController(alertMessage: "Please select board name" , showController: self)
                                    isValidate = false
                                    break;
                                }else
                                {
                                    parameterData["s_boardname"] = leftValue
                                }
                                let rightValue =  dataContent["rightValue"] as? String
                                if (rightValue?.isEmpty)!
                                {
                                    TutorDefaultAlertController.showAlertController(alertMessage: "Please select level" , showController: self)
                                    isValidate = false
                                    break;
                                }else
                                {
                                    parameterData["s_level"] = rightValue
                                    
                                }
                            }
                        }
                    }
                    if isValidate == false
                    {
                        break
                    }else
                    {
                        parameterStudent.add(parameterData)
                    }
                }
            }
        }
        
        if isValidate == true
        {
            // perform API Action
            self.openGuardianPreferenceController()
        }
    }
    
    func openGuardianPreferenceController()  {
        
        let tutorHomeViewController:TutorPreferencesViewController = self.storyboard?.instantiateViewController(withIdentifier: "TutorPreferencesViewController") as! TutorPreferencesViewController
        self.navigationController?.pushViewController(tutorHomeViewController, animated: true)
    }
    
    @objc func menuClickAction(sender:UIButton!) {
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        textField.inputView = nil
        if let textFieldTemp =  textField as? CustomTextField
        {
            textFieldTemp.inputView = nil
            textFieldTemp.inputAccessoryView = nil;
            let dataSectiondictionary = self.dataArray?.object(at: textFieldTemp.section) as? NSMutableDictionary
            if let studentArray = dataSectiondictionary!["student"] as? NSMutableArray
            {
                let datadictionary = studentArray.object(at: textFieldTemp.tag) as? NSMutableDictionary

                if datadictionary?.value(forKey: "type") as? Int == StudentProfileDataType.StudentProfileDataTypeGender.rawValue && textFieldTemp.customTag == 2
                {
                    self.configureDatePicker(textField: textFieldTemp)
                }
                else if datadictionary?.value(forKey: "type") as? Int == StudentProfileDataType.StudentProfileDataTypeGender.rawValue && textFieldTemp.customTag == 1
                {
                    self.thePicker.tag = 0
                    textFieldTemp.inputView = self.thePicker
                    self.thePicker.reloadAllComponents()
                }
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldTemp =  textField as? CustomTextField
        {
            let dataSectiondictionary = self.dataArray?.object(at: textFieldTemp.section) as? NSMutableDictionary
            if let studentArray = dataSectiondictionary!["student"] as? NSMutableArray
            {
                let datadictionary = studentArray.object(at: textFieldTemp.tag) as? NSMutableDictionary
                
                if datadictionary?.value(forKey: "type") as? Int == StudentProfileDataType.StudentProfileDataTypeGender.rawValue && textFieldTemp.customTag == 1
                {
                    if (genderValue != nil)
                    {
                        datadictionary?["leftValue"] = genderValue
                    }else
                    {
                        datadictionary?["leftValue"] = genderArray[0]
                        
                    }
                    profileTableview.reloadData()
                    
                    
                }else if textFieldTemp.customTag == 1
                {
                    datadictionary?["leftValue"] = textFieldTemp.text
                }else if textFieldTemp.customTag == 2
                {
                    datadictionary?["rightValue"] = textFieldTemp.text
                }
            }
        }
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
    
    //MARK:: PickerView Delegate & Datasource
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return genderArray.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderValue = genderArray[row]
    }
}
