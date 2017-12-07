//
//  TutorHomeViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 08/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import AAPickerView

enum FindTutorDataType:Int {
    case FindTutorDataTypeSelectStudent = 1,FindTutorDataTypeEnterTopic,FindTutorDataTypeSelectDate,FindTutorDataTypeTutionType,FindTutorDataTypeNoOfSessions
}

class TutorHomeViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
   
   @IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var findTutorTableView:UITableView!
    @IBOutlet weak var findTutorButton:UIButton!
    var dataArray :NSMutableArray?
    
    //===
    var selectStudentDictionary:NSDictionary!
    var selectSubjectDictionary:NSDictionary!
    var preferedTimeSlotString:String!
    var tutionTypeString:String!
    var groupSizeString:String!
    var numberOfSessionString:String!
    var customeTexfield: UITextField?
    var thePicker = UIPickerView()
    var pickerListArray : NSArray = []
    var selectedRow : Int! = 0
    public var selectedPickerDataType:PickerDataType?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
        self.setupSideMenu()
        self.setFindTutorFieldsArray()
        self.thePicker.delegate = self;
        self.thePicker.dataSource = self;

    }
   
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.rightBarButton.addTarget(self, action: #selector(menuClickAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.leftBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Find a Tutor"
        self.view.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.findTutorTableView.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.findTutorButton.layer.cornerRadius = 2
    }
    
    func setFindTutorFieldsArray() -> Void {
         let findTutorSelectStudent: NSMutableDictionary? = ["leftTitle":"Select Student","rightTitle":"Select Subject","leftValue":"","rightValue":"","type":NSNumber.init(value: FindTutorDataType.FindTutorDataTypeSelectStudent.rawValue) ]
         let findTutorEnterTopic: NSMutableDictionary? = ["leftTitle":"Enter Topic","rightTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: FindTutorDataType.FindTutorDataTypeEnterTopic.rawValue) ]
         let findTutorSelectDate: NSMutableDictionary? = ["leftTitle":"Select Date","rightTitle":"Prefered Time Slot","leftValue":"","rightValue":"","type":NSNumber.init(value: FindTutorDataType.FindTutorDataTypeSelectDate.rawValue) ]
         let findTutorTutionType: NSMutableDictionary? = ["leftTitle":"Tution Type","rightTitle":"Group Size","leftValue":"","rightValue":"","type":NSNumber.init(value: FindTutorDataType.FindTutorDataTypeTutionType.rawValue) ]
         let findTutorNoofSessions: NSMutableDictionary? = ["leftTitle":"No. of Sessions","rightTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: FindTutorDataType.FindTutorDataTypeNoOfSessions.rawValue) ]
        
        dataArray = NSMutableArray()
        dataArray?.add(findTutorSelectStudent ?? NSDictionary.init())
        dataArray?.add(findTutorEnterTopic ?? NSDictionary.init())
        dataArray?.add(findTutorSelectDate ?? NSDictionary.init())
        dataArray?.add(findTutorTutionType ?? NSDictionary.init())
        dataArray?.add(findTutorNoofSessions ?? NSDictionary.init())

        self.findTutorTableView.estimatedRowHeight = 60.0
        self.findTutorTableView.rowHeight = UITableViewAutomaticDimension

    }
    
    //MARK :: Tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "findTutorCell", for: indexPath) as? RegistrationTableViewCell
        cell?.updateLayout(registrationData: self.dataArray?.object(at: indexPath.row) as! NSDictionary, cellType: RegistrationCellType.RegistrationCellTypeFindTutor)
        cell?.leftTextField.delegate = self
        cell?.rightTextField.delegate = self
        cell?.leftTextField.tag = indexPath.row
        cell?.rightTextField.tag = indexPath.row
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65
    }
    //MARK: Textfield Delegate Methods
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        if let textFieldTemp =  textField as? CustomTextField
        {
            customeTexfield = textFieldTemp
            let datadictionary = self.dataArray?.object(at: textField.tag) as? NSMutableDictionary
            if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeSelectStudent.rawValue && textFieldTemp.customTag == 1)
            {
                 textFieldTemp.inputView = self.thePicker
                 self.thePicker.reloadAllComponents()
                MBProgressHUD.showAdded(to: self.view, animated: true)
                 self.getStudentList()
            }
           else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeSelectStudent.rawValue && textFieldTemp.customTag == 2)
            {
                self.thePicker.reloadAllComponents()
                 textFieldTemp.inputView = self.thePicker
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.getSubjectList()
            }
           else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeSelectDate.rawValue && textFieldTemp.customTag == 1)
            {
               self.configureDatePicker(textField: textFieldTemp)
            }
           else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeSelectDate.rawValue && textFieldTemp.customTag == 2)
            {
                self.pickerListArray = ["9:00 AM - 1:00 PM","10:00 AM - 2.00 PM","11:00 AM - 3:00 PM","12:00 PM - 4:00 PM","1:00 PM - 5:00 PM","2:00 PM - 6:00 PM","3:00 PM - 7:00 PM","4:00 PM - 8:00 PM","5:00 PM - 9:00 PM"]
                self.selectedPickerDataType = .TimeSlotType
                 textFieldTemp.inputView = self.thePicker
                self.thePicker.selectRow(0, inComponent: 0, animated: true)
            }
           else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeTutionType.rawValue && textFieldTemp.customTag == 1)
            {
                self.pickerListArray = ["One-on-One","Group"]
                self.selectedPickerDataType = .TutionType
                textFieldTemp.inputView = self.thePicker
                self.thePicker.selectRow(0, inComponent: 0, animated: true)
            }
          else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeTutionType.rawValue && textFieldTemp.customTag == 2)
            {
                self.pickerListArray = ["2","3","4","5"]
                    self.selectedPickerDataType = .GroupSizeType
                    textFieldTemp.inputView = self.thePicker
                self.thePicker.selectRow(0, inComponent: 0, animated: true)
            }
          else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeNoOfSessions.rawValue && textFieldTemp.customTag == 1)
            {
                self.pickerListArray = ["1","2","3","4"]
                self.selectedPickerDataType = .NoofSessionType
                textFieldTemp.inputView = self.thePicker
              self.thePicker.selectRow(0, inComponent: 0, animated: true)
            }
            
        }
        return true
    }
    func getPickerDetails() -> Void {
        if pickerListArray.count>0 {
            var selectedString:String?
            var selectedDictionary:Dictionary<String,Any>?
            if selectedPickerDataType == .SubjectListType
            {
                selectedDictionary = pickerListArray[selectedRow] as? Dictionary<String, Any>
                selectedString = selectedDictionary?["cs_course_name"] as? String
            }else if selectedPickerDataType == .TopicListType
            {
                selectedDictionary = pickerListArray[selectedRow] as? Dictionary<String, Any>
                selectedString = selectedDictionary?["sub_subject_name"] as? String
            }else if selectedPickerDataType == .TimeSlotType || selectedPickerDataType == .TutionType || selectedPickerDataType == .GroupSizeType || selectedPickerDataType == .NoofSessionType
            {
                selectedString = pickerListArray[selectedRow] as? String
            }else if selectedPickerDataType == .SelectStudentType
            {
                selectedDictionary = pickerListArray[selectedRow] as? Dictionary<String, Any>
                selectedString = selectedDictionary?["sm_name"] as? String
            }
            self.doneButtonClickedInPicker(Value: selectedString, InDictionary: selectedDictionary, selectedPickerDataType: selectedPickerDataType)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.getPickerDetails()
        self.pickerListArray = []
        selectedRow = 0
        if let textFieldTemp =  textField as? CustomTextField
        {
            let datadictionary = self.dataArray?.object(at: textField.tag) as? NSMutableDictionary
            if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeSelectStudent.rawValue && textFieldTemp.customTag == 1)
            {
                if (self.selectStudentDictionary != nil)
                {
                    datadictionary?["leftValue"] = self.selectStudentDictionary["sm_name"]
                }
                self.findTutorTableView.reloadData()
            }
             else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeSelectStudent.rawValue && textFieldTemp.customTag == 2)
            {
                if (self.selectSubjectDictionary != nil)
                {
                    datadictionary?["rightValue"] = self.selectSubjectDictionary["cs_course_name"]
                }
                self.findTutorTableView.reloadData()
            }
            else  if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeSelectDate.rawValue && textFieldTemp.customTag == 1)
            {
               datadictionary?["leftValue"] = textFieldTemp.text
            }
           else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeSelectDate.rawValue && textFieldTemp.customTag == 2)
            {
                if self.preferedTimeSlotString != nil
                {
                    datadictionary?["rightValue"] = self.preferedTimeSlotString

                }
                self.findTutorTableView.reloadData()
            }
           else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeTutionType.rawValue && textFieldTemp.customTag == 1)
            {
                if self.tutionTypeString != nil
                {
                    datadictionary?["leftValue"] = self.tutionTypeString
                    if self.tutionTypeString == "One-on-One"
                    {
                         datadictionary?["rightValue"] = ""
                    }
                    
                }
                 self.findTutorTableView.reloadData()
            }
           else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeTutionType.rawValue && textFieldTemp.customTag == 2)
            {
                if self.groupSizeString != nil
                {
                    datadictionary?["rightValue"] = self.groupSizeString
                    
                }
                 self.findTutorTableView.reloadData()
            }
           else if (datadictionary?.value(forKey: "type") as? Int == FindTutorDataType.FindTutorDataTypeNoOfSessions.rawValue && textFieldTemp.customTag == 1)
            {
                if self.numberOfSessionString != nil
                {
                    datadictionary?["leftValue"] = self.numberOfSessionString
                    
                }
                 self.findTutorTableView.reloadData()
            }else if textFieldTemp.customTag == 1
            {
                datadictionary?["leftValue"] = textFieldTemp.text
            }
            
        }
    }
    func configureDatePicker(textField:AAPickerView) -> Void {
        textField.pickerType = .DatePicker
        textField.datePicker?.datePickerMode = .date
        textField.datePicker?.minimumDate = Date()
        textField.dateFormatter.dateFormat = Constants.dateFormatValue
        textField.dateDidChange = { date in
            print("selectedDate ", date )
            textField.text = textField.dateFormatter.string(from: date)
        }
    }
    
    // MARK:Login Api Implementation
    @objc func menuClickAction(sender:UIButton!) {
         present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
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
    

    @IBAction func findTutorButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        var parameterData = [String: String]()
        var isValidate:Bool = true
        for dataDictionary in self.dataArray! {
            if let dataContent = dataDictionary as? NSMutableDictionary
            {
                if dataContent["type"] as? Int == FindTutorDataType.FindTutorDataTypeSelectStudent.rawValue
                {
                    let leftValue = dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please Select Student" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["student_id"] = self.selectStudentDictionary["sm_id"] as? String
                    }
                    let rightValue =  dataContent["rightValue"] as? String
                    if (rightValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please Select Subject" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["sel_sub"] = rightValue
                        
                    }
                }else  if dataContent["type"] as? Int == FindTutorDataType.FindTutorDataTypeEnterTopic.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Topic" , showController: self)
                        isValidate = false
                        break;
                    }else if ((leftValue?.count ?? 0) < 3)
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please Enter Topic Minimum 3 characters" , showController: self)
                        isValidate = false
                        break;
                    }else{
                         parameterData["sel_topic"] = leftValue
                    }
                }else if dataContent["type"] as? Int == FindTutorDataType.FindTutorDataTypeSelectDate.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please Select Date" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["sel_date"] = leftValue
                    }
                    let rightValue =  dataContent["rightValue"] as? String
                    if (rightValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please Select Time Slot" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        let splitArray = rightValue?.split{$0 == "-"}.map(String.init)
                        if ((splitArray?.count) != nil)
                        {
                            parameterData["sel_start_time"] = splitArray?[0]
                            parameterData["sel_end_time"] = splitArray?[1]
                        }
                    }
                }else if dataContent["type"] as? Int == FindTutorDataType.FindTutorDataTypeTutionType.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please Select Tution Type" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["sel_tution_type"] = leftValue
                    }
                    let rightValue =  dataContent["rightValue"] as? String
                    if leftValue != "One-on-One"
                    {
                        if (rightValue?.isEmpty)!
                        {
                            TutorDefaultAlertController.showAlertController(alertMessage: "Please Select Group Size" , showController: self)
                            isValidate = false
                            break;
                        }else
                        {
                            parameterData["sel_group_size"] = rightValue
                        }
                    }
                   
                }else if dataContent["type"] as? Int == FindTutorDataType.FindTutorDataTypeNoOfSessions.rawValue
                {
                    let leftValue =  dataContent["leftValue"] as? String
                    if (leftValue?.isEmpty)!
                    {
                        TutorDefaultAlertController.showAlertController(alertMessage: "Please Select No of Sessions" , showController: self)
                        isValidate = false
                        break;
                    }else
                    {
                        parameterData["no_session"] = leftValue
                    }
                }
            }
        }
        
        if isValidate
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.getSearchTutorList(parametersDict: parameterData as NSDictionary)
        }
        
    }

    
    // MARK:Select Student List Api Implementation
    func getStudentList() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.studentList) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["login_id":(TutorSharedClass.shared.loginTutorLoginObject?.sm_id) ?? "","register_type":(TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type) as Any]) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let pickerArray = resultDictionary["data"] as? Array<Any>
                    {
                        self.pickerListArray = pickerArray as NSArray
                        self.selectedPickerDataType = .SelectStudentType
                        self.thePicker.reloadAllComponents()
                        self.thePicker.selectRow(0, inComponent: 0, animated: true)
                    }
                }
            }
//            else{
//                print(info as Any)
//                if let resultDict = info as? Dictionary<String,Any>
//                {
//                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
//                }
//            }

        }
    }

    // MARK:Subject List Api Implementation
    func getSubjectList() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.subjectList) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: nil) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let pickerArray = resultDictionary["data"] as? Array<Any>
                    {
                        DispatchQueue.main.async {
                            self.pickerListArray = pickerArray as NSArray
                            self.selectedPickerDataType = .SubjectListType
                            self.thePicker.reloadAllComponents()
                            self.thePicker.selectRow(0, inComponent: 0, animated: true)
                        }
                      
                      
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
//
//    // MARK:Topic List Api Implementation
//    func getTopicList() -> Void {
//        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.topicList) as String
//        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["course_id":(self.selectedSubjectDictionary?["cs_cid"] ?? "")]) { (status, info) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            if status == Constants.Status.StatusOK.rawValue
//            {
//                if let resultDictionary = info as? Dictionary<String,Any>
//                {
//                    if let pickerArray = resultDictionary["data"] as? Array<Any>
//                    {
//                        self.openpickerViewController(pickerArray: pickerArray, selectedPickerType: .TopicListType)
//                    }
//                }
//            }else{
//                print(info as Any)
//                if let resultDict = info as? Dictionary<String,Any>
//                {
//                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
//                }
//            }
//        }
//    }
//
    // MARK:Search List Api Implementation
    func getSearchTutorList(parametersDict:NSDictionary?) -> Void {
        TutorSharedClass.shared.findTutorDictionary = parametersDict
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.searchTutor) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary:parametersDict as? Dictionary<String, Any>) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let techaerListArray = resultDictionary["data"] as? Array<Any>
                    {
                        let tutorTeachersList = TutorTeacherModel.modelsFromDictionaryArray(array: techaerListArray as NSArray)
                        self.navigateTeachersViewController(teachersListArray: tutorTeachersList)

                    }
                }
            }else{
                MBProgressHUD.hide(for: self.view, animated: true)
                print(info as Any)
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
            }
        }
    }

    func navigateTeachersViewController(teachersListArray:Array<TutorTeacherModel>) -> Void {
        let tutorTeachersListViewController:TutorTeachersListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TutorTeachersListViewController") as! TutorTeachersListViewController
        tutorTeachersListViewController.teachersListArray = teachersListArray
        self.navigationController?.pushViewController(tutorTeachersListViewController, animated: true)
    }

    func doneButtonClickedInPicker(Value value: String?, InDictionary pickerDictionary: Dictionary<String, Any>?, selectedPickerDataType: PickerDataType?) {
        switch selectedPickerDataType {
        case .SelectStudentType?:
                self.selectStudentDictionary = pickerDictionary! as NSDictionary
           break
        case .SubjectListType?:
            self.selectSubjectDictionary = pickerDictionary! as NSDictionary
            break
        case .TopicListType?:
            break

        case .TimeSlotType?:
            self.preferedTimeSlotString = value
            break

        case .TutionType?:
             self.tutionTypeString = value
            break

        case .GroupSizeType?:
           self.groupSizeString = value
            break
        case .NoofSessionType?:
            self.numberOfSessionString = value
            break

        default:
            break
        }

    }
    
    //MARK:: PickerView Delegate & Datasource
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.pickerListArray.count
        
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if selectedPickerDataType == .SubjectListType
        {
            let subjectListDictionary = pickerListArray[row] as! NSDictionary
            return subjectListDictionary["cs_course_name"] as? String
        }else if selectedPickerDataType == .TopicListType
        {
            let topicListDictionary = pickerListArray[row] as! NSDictionary
            return topicListDictionary["sub_subject_name"] as? String
        }else if selectedPickerDataType == .TimeSlotType || selectedPickerDataType == .TutionType || selectedPickerDataType == .GroupSizeType || selectedPickerDataType == .NoofSessionType
        {
            return pickerListArray[row] as? String
        }else if selectedPickerDataType == .SelectStudentType
        {
            let topicListDictionary = pickerListArray[row] as! NSDictionary
            return topicListDictionary["sm_name"] as? String
        }
        
        return ""
    }
    
    // When user selects an option, this function will set the text of the text field to reflect the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        
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
