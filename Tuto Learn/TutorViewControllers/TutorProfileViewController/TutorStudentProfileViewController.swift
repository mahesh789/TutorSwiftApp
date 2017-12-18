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
import Alamofire
import Kingfisher

enum StudentProfileDataType:Int {
    case StudentProfileDataTypeFirstName = 1,StudentProfileDataTypeGender,StudentProfileDataTypeEmail,StudentProfileDataTypeMobile,StudentProfileDataTypeSchoolName,StudentProfileDataTypeBoardName,StudentProfileDataTypeLevel
}
class TutorStudentProfileViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var profileTableview: UITableView!
    var dataArray :NSMutableArray?
    @IBOutlet weak var tutorNavigationBar: TutorHomeNavigationBar!
    @IBOutlet weak var submitButton: UIButton!
    var thePicker = CustomPickerView()
    let genderArray = ["Male","Female"]
    var genderValue: String!
    var isEditStudentProfile: Bool = false
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var selectedStudentInfo: NSDictionary?
    var isImageChange: Bool = false
    var selectedProfileImage = NSMutableDictionary()
    var levelBoardData: NSDictionary?
    var selectedLevel = NSMutableDictionary()
    var selectedBoard = NSMutableDictionary()
    var requestParameterData = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
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

        if self.isEditStudentProfile == true
        {
            self.tutorNavigationBar.leftBarButton.isHidden = true
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.getStudentDetails()
        }
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
        
        let tempDataArray = NSMutableArray()

        if self.isEditStudentProfile == true
        {
            let profileNameDetails: NSMutableDictionary? = ["leftTitle":"First Name","rightTitle":"Last Name","leftValue":selectedStudentInfo?.value(forKey: "sm_name") ?? "","rightValue": selectedStudentInfo?.value(forKey: "sm_last") ?? "" ,"type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeFirstName.rawValue)]
            
            let profilegenderDetails: NSMutableDictionary? = ["leftTitle":"Gender","rightTitle":"Date of Birth","leftValue": selectedStudentInfo?.value(forKey: "sm_gender") ?? "","rightValue":selectedStudentInfo?.value(forKey: "sm_dob") ?? "","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeGender.rawValue)]
            
            let profileEmailDetails: NSMutableDictionary? = ["rightTitle":"Email","leftTitle":"","leftValue":"","rightValue": selectedStudentInfo?.value(forKey: "sm_email") ?? "","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeEmail.rawValue)]
            
            let profileMobileDetails: NSMutableDictionary? = ["leftTitle":"Mobile","rightTitle":"","leftValue": selectedStudentInfo?.value(forKey: "sm_mobile") ?? "","rightValue":"","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeMobile.rawValue)]
            
            let profileSchoolDetail: NSMutableDictionary? = ["rightTitle":"Name of School(optional)","leftTitle":"","leftValue":"","rightValue": selectedStudentInfo?.value(forKey: "sm_school_name") ?? "","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeSchoolName.rawValue)]
            
            let profileBoardDetails: NSMutableDictionary? = ["leftTitle":"Board","rightTitle":"Level","leftValue": selectedStudentInfo?.value(forKey: "sm_board") ?? "","rightValue":selectedStudentInfo?.value(forKey: "sm_level") ?? "","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeBoardName.rawValue),"boardData":NSDictionary.init(),"levelData":NSDictionary.init()]
            
            tempDataArray.add(profileNameDetails ?? NSDictionary.init())
            tempDataArray.add(profilegenderDetails ?? NSDictionary.init())
            tempDataArray.add(profileEmailDetails ?? NSDictionary.init())
            tempDataArray.add(profileMobileDetails ?? NSDictionary.init())
            tempDataArray.add(profileSchoolDetail ?? NSDictionary.init())
            tempDataArray.add(profileBoardDetails ?? NSDictionary.init())
        }else
        {
            let profileNameDetails: NSMutableDictionary? = ["leftTitle":"First Name","rightTitle":"Last Name","leftValue":"","rightValue": "" ,"type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeFirstName.rawValue)]
            
            let profilegenderDetails: NSMutableDictionary? = ["leftTitle":"Gender","rightTitle":"Date of Birth","leftValue": "","rightValue":"","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeGender.rawValue)]
            
            let profileEmailDetails: NSMutableDictionary? = ["rightTitle":"Email","leftTitle":"","leftValue":"","rightValue": "","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeEmail.rawValue)]
            
            let profileMobileDetails: NSMutableDictionary? = ["leftTitle":"Mobile","rightTitle":"","leftValue": "","rightValue":"","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeMobile.rawValue)]
            
            let profileSchoolDetail: NSMutableDictionary? = ["rightTitle":"Name of School(optional)","leftTitle":"","leftValue":"","rightValue": "","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeSchoolName.rawValue)]
            
            let profileBoardDetails: NSMutableDictionary? = ["leftTitle":"Board","rightTitle":"Level","leftValue": "","rightValue":"","type":NSNumber.init(value: StudentProfileDataType.StudentProfileDataTypeBoardName.rawValue)]
            
            tempDataArray.add(profileNameDetails ?? NSDictionary.init())
            tempDataArray.add(profilegenderDetails ?? NSDictionary.init())
            tempDataArray.add(profileEmailDetails ?? NSDictionary.init())
            tempDataArray.add(profileMobileDetails ?? NSDictionary.init())
            tempDataArray.add(profileSchoolDetail ?? NSDictionary.init())
            tempDataArray.add(profileBoardDetails ?? NSDictionary.init())
        }

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
            tempHederView.uploadButton.layer.cornerRadius = 5.0;
            tempHederView.uploadButton.layer.borderColor = UIColor.init(red: 73, green: 167, blue: 169).cgColor
            tempHederView.uploadButton.layer.masksToBounds = true
            tempHederView.uploadButton.layer.borderWidth = 1.0
            tempHederView.uploadButton.tag = section
            tempHederView.closeButton.tag = section
            tempHederView.profileImageView.layer.cornerRadius = tempHederView.profileImageView.frame.size.height/2
            tempHederView.profileImageView.layer.masksToBounds = true
            tempHederView.closeButton.addTarget(self, action: #selector(deleteStudentClicked(sender:)), for: .touchUpInside)
            tempHederView.uploadButton.addTarget(self, action: #selector(uploadPhotoButtonClick(sender:)), for: .touchUpInside)
            if section == 0
            {
                tempHederView.closeButton.isHidden = true
            }else
            {
                tempHederView.closeButton.isHidden = false
            }
            if let profileImage = selectedProfileImage.value(forKey: String(section)) as? UIImage
            {
                tempHederView.uploadButton.setTitle("Edit Photo", for: .normal)
              tempHederView.profileImageView.image = profileImage
            }else if self.isEditStudentProfile == true
            {
                if let profileUrl = selectedStudentInfo?.value(forKey: "sm_profile_image")
                {
                    tempHederView.uploadButton.setTitle("Edit Photo", for: .normal)
                    tempHederView.profileImageView.kf.setImage(with: URL.init(string: profileUrl as! String) , placeholder: UIImage.init(named: "dummyPhoto"), options: nil, progressBlock: nil, completionHandler:{
                        (image, error, cacheType, imageUrl) in
                        if (image != nil)
                        {

                        }
                    })
                }else if let profileUrl = selectedStudentInfo?.value(forKey: "sm_profile_img_url")
                {
                    tempHederView.uploadButton.setTitle("Edit Photo", for: .normal)
                    tempHederView.profileImageView.kf.setImage(with: URL.init(string: profileUrl as! String) , placeholder: UIImage.init(named: "dummyPhoto"), options: nil, progressBlock: nil, completionHandler:{
                        (image, error, cacheType, imageUrl) in
                        if (image != nil)
                        {
                        }
                    })
                }else
                {
                    tempHederView.uploadButton.setTitle("Upload Photo", for: .normal)
                }
            }else
            {
                tempHederView.uploadButton.setTitle("Upload Photo", for: .normal)
            }
            
        }
        return headerview
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
        if isEditStudentProfile == true
        {
            return 10
        }
        if (self.dataArray?.count)!-1 == section
        {
            return 50

        }else
        {
            return 10

        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if isEditStudentProfile == true
        {
            return nil
        }
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
        var index :Int = 0
        
        for dataDictionary in self.dataArray! {
            if let dataSectionContent = dataDictionary as? NSMutableDictionary
            {
                if let studentArray = dataSectionContent["student"] as? NSMutableArray
                {
                    var parameterData = [String: String]()
                    
                    parameterData["tempID"] = String(index)
                    index = index + 1
                    
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
                                    if self.isEditStudentProfile == true
                                    {
                                        parameterData["first_name"] = leftValue
                                    }else
                                    {
                                        parameterData["s_name"] = leftValue
                                    }
                                }
                                let rightValue =  dataContent["rightValue"] as? String
                                if (rightValue?.isEmpty)!
                                {
                                    TutorDefaultAlertController.showAlertController(alertMessage: "Please enter last name" , showController: self)
                                    isValidate = false
                                    break;
                                }else
                                {
                                    if self.isEditStudentProfile == true
                                    {
                                        parameterData["last_name"] = rightValue
                                    }else
                                    {
                                        parameterData["s_lastname"] = leftValue
                                    }
                                    
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
                                    if self.isEditStudentProfile == true
                                    {
                                        parameterData["gender"] = leftValue
                                    }else
                                    {
                                        parameterData["s_gender"] = leftValue
                                    }
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
                                        if self.isEditStudentProfile == true
                                        {
                                            parameterData["dob"] = rightValue
                                        }else
                                        {
                                            parameterData["s_dob"] = leftValue
                                        }
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
                                        if self.isEditStudentProfile == true
                                        {
                                            parameterData["email"] = leftValue as String?
                                        }else
                                        {
                                            parameterData["s_email"] = leftValue as String?
                                        }
                                    }else
                                    {
                                        TutorDefaultAlertController.showAlertController(alertMessage: "Please enter valid email address" , showController: self)
                                        isValidate = false
                                        break;
                                    }
                                    
                                }
                                
                            }else if dataContent["type"] as? Int == StudentProfileDataType.StudentProfileDataTypeSchoolName.rawValue
                            {
                                let leftValue =  dataContent["rightValue"] as? NSString

                                if self.isEditStudentProfile == true
                                {
                                    parameterData["school_name"] = leftValue as String?
                                }else
                                {
                                    parameterData["name_of_school"] = leftValue as String?
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
                                        if self.isEditStudentProfile == true
                                        {
                                            parameterData["mobile"] = rightValue
                                        }else
                                        {
                                            parameterData["s_mobile"] = rightValue
                                        }
                                    }
                                    
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
                                    if let boardData =  dataContent["boardData"] as? NSDictionary
                                    {
                                        parameterData["board"] = boardData.value(forKey:"bid" ) as? String
                                    }
                                }
                                let rightValue =  dataContent["rightValue"] as? String
                                if (rightValue?.isEmpty)!
                                {
                                    TutorDefaultAlertController.showAlertController(alertMessage: "Please select level" , showController: self)
                                    isValidate = false
                                    break;
                                }else
                                {
                                    if let boardData =  dataContent["levelData"] as? NSDictionary
                                    {
                                        parameterData["level"] = boardData.value(forKey:"level_id" ) as? String
                                    }
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
            if self.isEditStudentProfile == true
            {
                MBProgressHUD.showAdded(to: self.view, animated: true)

                var parameterData = parameterStudent.lastObject as! Dictionary<String, String>
                parameterData["register_type"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type
                parameterData["login_id"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_id
                if let profileImageChange = selectedProfileImage.value(forKey: String(0)) as? UIImage
                {
                    let imageData: NSData = UIImageJPEGRepresentation(profileImageChange, 0.5)! as NSData
                    let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
                    parameterData["img_base"] = strBase64
                    parameterData["img_ext"] = "jpeg"
                }else
                {
                    parameterData["img_base"] = ""
                    parameterData["img_ext"] = ""
                }
                
                parameterData["page_name"] = "0"
              
                self.callUpdateGuardianProfileDetails(parameterData: parameterData)
                
            }else
            {
                if selectedProfileImage.allKeys.count != parameterStudent.count
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: "Please select profile image" , showController: self)

                }else
                {
                    if parameterStudent.count>0
                    {
                        if self.requestParameterData.count<=0
                        {
                            requestParameterData.addObjects(from: parameterStudent as! [Any])
                        }else
                        {
                            let mutableArray = NSMutableArray()
                            for datacontent in requestParameterData
                            {
                                if let tempdataContetnt = datacontent as? Dictionary<String, String>
                                {
                                    let tempId = tempdataContetnt["tempID"]
                                    if tempId?.isEmpty == false
                                    {
                                        let predicate = NSPredicate(format: "tempID == %@",tempId!)
                                        let filterArray = parameterStudent.filtered(using: predicate)
                                        if filterArray.isEmpty == false
                                        {
                                            mutableArray.add(filterArray.last ?? "")
                                        }
                                    }
                                }
                            }
                            requestParameterData = mutableArray
                        }
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        let parameterData = requestParameterData.firstObject as! Dictionary<String, String>
                        let index = parameterStudent.index(of: parameterData)
                        self.setAndCallAddStudentData(parameterData: parameterData, andParameterData: parameterStudent,index: index)
                    }
                }
            }
        }
    }
    
    func setAndCallAddStudentData(parameterData:Dictionary<String, String>,andParameterData:NSMutableArray,index:Int)
    {
        var parameterData = parameterData
        parameterData["register_type"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type
        parameterData["login_id"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_id
        if let profileImageChange = selectedProfileImage.value(forKey: String(index)) as? UIImage
        {
            let imageData: NSData = UIImageJPEGRepresentation(profileImageChange, 0.5)! as NSData
            let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
            parameterData["img_base"] = strBase64
            parameterData["img_ext"] = "jpeg"
        }else
        {
            parameterData["img_base"] = ""
            parameterData["img_ext"] = ""
        }
        parameterData["s_oauth"] = "Mobile"
        parameterData.removeValue(forKey: "tempID")
        self.callAddStudentUnderGuardian(parameterData: parameterData,allParameterData: andParameterData,index: index)
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

                if (datadictionary?.value(forKey: "type") as? Int == StudentProfileDataType.StudentProfileDataTypeEmail.rawValue ) && self.isEditStudentProfile == true
                {
                    if textField.text?.isEmpty == false
                    {
                        
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please contact administrator to update the info" , showController: self)
                        
                        return false
                    }
                    
                }
                
                if datadictionary?.value(forKey: "type") as? Int == StudentProfileDataType.StudentProfileDataTypeGender.rawValue && textFieldTemp.customTag == 2
                {
                    self.configureDatePicker(textField: textFieldTemp)
                }
                else if datadictionary?.value(forKey: "type") as? Int == StudentProfileDataType.StudentProfileDataTypeGender.rawValue && textFieldTemp.customTag == 1
                {
                    self.thePicker = CustomPickerView()
                    self.thePicker.delegate = self
                    self.thePicker.dataSource = self
                    self.thePicker.tag = 0
                    thePicker.section = textFieldTemp.section
                    genderValue = genderArray[0]
                    textFieldTemp.inputView = self.thePicker
                    self.thePicker.reloadAllComponents()
                }else if datadictionary?.value(forKey: "type") as? Int == StudentProfileDataType.StudentProfileDataTypeBoardName.rawValue && textFieldTemp.customTag == 1
                {
                    self.thePicker = CustomPickerView()
                    self.thePicker.delegate = self
                    self.thePicker.dataSource = self
                    textFieldTemp.inputView = self.thePicker
                    self.thePicker.tag = 101
                    thePicker.section = textFieldTemp.section
                    if self.levelBoardData == nil {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        self.getLevelBoardData()
                    }else
                    {
                        if let boardArray = self.levelBoardData?.value(forKey: "boards") as? NSArray
                        {
                            selectedBoard.setValue(boardArray[0], forKey: String(textFieldTemp.section))
                        }
                        
                    }
                    
                }else if datadictionary?.value(forKey: "type") as? Int == StudentProfileDataType.StudentProfileDataTypeBoardName.rawValue && textFieldTemp.customTag == 2
                {
                    self.thePicker = CustomPickerView()
                    self.thePicker.delegate = self
                    self.thePicker.dataSource = self
                    textFieldTemp.inputView = self.thePicker
                    self.thePicker.tag = 102
                    thePicker.section = textFieldTemp.section
                    if self.levelBoardData == nil {
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        self.getLevelBoardData()
                    }else
                    {
                        if let boardArray = self.levelBoardData?.value(forKey: "level") as? NSArray
                        {
                            selectedLevel.setValue(boardArray[0], forKey: String(textFieldTemp.section))
                        }
                    }
                    
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
                    
                }else if datadictionary?.value(forKey: "type") as? Int == StudentProfileDataType.StudentProfileDataTypeBoardName.rawValue && textFieldTemp.customTag == 1
                {
                    print(selectedBoard)
                    if let selectedBoardtemp = selectedBoard.value(forKey: String(textFieldTemp.section)) as? NSDictionary
                    {
                        datadictionary?["boardData"] = selectedBoardtemp
                        datadictionary?["leftValue"] = selectedBoardtemp["bname"]

                    }else if levelBoardData != nil
                    {
                        if let boardArray = self.levelBoardData?.value(forKey: "boards") as? NSArray
                        {
                            datadictionary?["boardData"] = boardArray[0]
                            if let boardname = boardArray[0] as? NSDictionary
                            {
                                datadictionary?["leftValue"] = boardname["bname"]
                            }

                        }
                    }
                    profileTableview.reloadData()
                    
                }
                else if datadictionary?.value(forKey: "type") as? Int == StudentProfileDataType.StudentProfileDataTypeBoardName.rawValue && textFieldTemp.customTag == 2
                {
                    if let selectedBoardtemp = selectedLevel.value(forKey: String(textFieldTemp.section)) as? NSDictionary
                    {
                        datadictionary?["levelData"] = selectedBoardtemp
                        datadictionary?["rightValue"] = selectedBoardtemp["l_name"]

                    }else if levelBoardData != nil
                    {
                        if let boardArray = self.levelBoardData?.value(forKey: "level") as? NSArray
                        {
                            datadictionary?["levelData"] = boardArray[0]
                            if let boardname = boardArray[0] as? NSDictionary
                            {
                                datadictionary?["rightValue"] = boardname["l_name"]
                            }
                        }
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
        textField.datePicker?.maximumDate = Date.init()
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
        if pickerView.tag == 101
        {
            if let boardArray = self.levelBoardData?.value(forKey: "boards") as? NSArray
            {
                return boardArray.count
            }
        }else if pickerView.tag == 102
        {
            if let levelArray = self.levelBoardData?.value(forKey: "level") as? NSArray
            {
                return levelArray.count
            }
        }else
        {
            return genderArray.count
        }
        return 0
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 101
        {
            if let boardArray = self.levelBoardData?.value(forKey: "boards") as? NSArray
            {
                if let boardname = boardArray[row] as? NSDictionary
                {
                    return boardname["bname"] as? String
                }
            }
        }else if pickerView.tag == 102
        {
            if let levelArray = self.levelBoardData?.value(forKey: "level") as? NSArray
            {
                if let boardname = levelArray[row] as? NSDictionary
                {
                    return boardname["l_name"] as? String
                }
                
            }
        }else
        {
            return genderArray[row]
        }
        return ""
    }
    
    // When user selects an option, this function will set the text of the text field to reflect the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 101
        {
            if let boardArray = self.levelBoardData?.value(forKey: "boards") as? NSArray
            {
                if let customPicker =  pickerView as? CustomPickerView
                {
                    selectedBoard.setValue(boardArray[row], forKey: String(customPicker.section))
                }
            }
        }else if pickerView.tag == 102
        {
            if let levelArray = self.levelBoardData?.value(forKey: "level") as? NSArray
            {
                if let customPicker =  pickerView as? CustomPickerView
                {
                    selectedLevel.setValue(levelArray[row], forKey: String(customPicker.section))
                }
            }
        }else
        {
            genderValue = genderArray[row]

        }
    }
    
    
    func callUpdateGuardianProfileDetails(parameterData:Dictionary<String, String>)  {
        
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.updateGuardianDetails) as String
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
                                self.callUpdateGuardianProfileDetails(parameterData: parameterData)
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
            self.openGuardianPreferenceController();
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getStudentDetails() {
        
        var parameterData = [String: String]()
        parameterData["user_id"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_id
        parameterData["register_type"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type
        
        // print(parameterData);
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.profileDetails) as String
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
                            let loginModelArray = TutorLoginModel.modelsFromDictionaryArray(array: [resultParseLoginDictionary])
                            if (loginModelArray.first != nil)
                            {
                                TutorSharedClass.shared.loginTutorLoginObject?.updateModelObject(modelObject: loginModelArray.first!)
                                self.selectedStudentInfo = TutorSharedClass.shared.loginTutorLoginObject?.dictionaryRepresentation()
                                if TutorSharedClass.shared.isLoginRemember
                                {
                                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                                    let loginDictionary = TutorSharedClass.shared.loginTutorLoginObject?.dictionaryRepresentation()
                                    UserDefaults.standard.set(loginDictionary, forKey: "LoginDetails")
                                }
                                self.dataArray?.removeAllObjects()
                                self.setProfileData()
                            }
                        }
                        
                    }
                    else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.getStudentDetails()
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
                                self.getStudentDetails()
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
                MBProgressHUD.hide(for: self.view, animated: true)
                print(response.result.error as Any)
            }
        }
    }
    
   
    //MARK:: Upload Action Photo
   @objc func uploadPhotoButtonClick(sender:UIButton)
    {
        let alertController = UIAlertController(title: "Choose Option", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let somethingAction = UIAlertAction(title: "Photo Library", style: .default, handler: {(alert: UIAlertAction!) in
            self.openPhotoLibrary(tag: sender.tag)
            
        })
        
        let somethingActionCamera = UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) in
            self.openCameraLibrary(tag: sender.tag)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(somethingAction)
        alertController.addAction(somethingActionCamera)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
        
        
    }
    
    func openPhotoLibrary(tag:Int)  {
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.view.tag = tag
        present(self.imagePicker, animated: true, completion: nil)
    }
    func openCameraLibrary(tag:Int)  {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            present(self.imagePicker, animated: true, completion: nil)
            self.imagePicker.view.tag = tag
        }
    }
    
    @objc func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
        })
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("called")
        self.dismiss(animated: true, completion: { () -> Void in
            
            if let bigImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                self.selectedImage = bigImage                
                self.isImageChange = true
                self.selectedProfileImage.setValue(self.selectedImage, forKey: String(picker.view.tag))
                self.profileTableview.reloadData()

            }
        })
    }
    
    
    func getLevelBoardData() {
        
        // print(parameterData);
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.levelBoard) as String
        Alamofire.request(urlPath, method: .post, parameters:nil , encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
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
                            self.levelBoardData = resultParseLoginDictionary
                            self.thePicker.reloadAllComponents()
                        }
                        
                    }
                    else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.getLevelBoardData()
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
                                self.getLevelBoardData()
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
                MBProgressHUD.hide(for: self.view, animated: true)
                print(response.result.error as Any)
            }
        }
    }
    
    func callAddStudentUnderGuardian(parameterData:Dictionary<String, String>, allParameterData:NSMutableArray,index:Int)  {
        
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.addStudent) as String
        // print(parameterData)
        Alamofire.request(urlPath, method: .post, parameters:parameterData , encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
            if response.result.isSuccess
            {
                if let resultDictionary = response.result.value as? NSDictionary
                {
                    print(resultDictionary)
                    
                    if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.StatusOK.rawValue
                    {
                        print(resultDictionary)

                        if self.isEditStudentProfile == true
                        {
                            self.isImageChange = false
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.showAlertController(alertMessage: resultDictionary["message"] as? String)
                        }else
                        {
                            if (allParameterData.count - 1 ) > index
                            {
                                if(self.requestParameterData.count>0)
                                {
                                    self.requestParameterData.removeObject(at: 0)
                                }
                                let newIndex = index + 1
                                let parameterData = allParameterData.object(at: newIndex)
                                self.setAndCallAddStudentData(parameterData: parameterData as! Dictionary<String, String>, andParameterData: allParameterData,index: newIndex)
                            }else
                            {
                                if(self.requestParameterData.count>0)
                                {
                                    self.requestParameterData.removeObject(at: 0)
                                }
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                                self.showAlertController(alertMessage: resultDictionary["message"] as? String)
                            }
                        }
                        
                    }
                    else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.callAddStudentUnderGuardian(parameterData: parameterData,allParameterData: allParameterData,index: index)
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
}
