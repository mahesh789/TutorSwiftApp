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

class TutorHomeViewController: UIViewController,TutorCommonPickerViewDelegate {
   
   @IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var selectStudentButton: UIButton!
    @IBOutlet weak var selectSubjectButton: UIButton!
    @IBOutlet weak var selectTopicButton: UIButton!
    @IBOutlet weak var specifyTimeSlotButton: UIButton!
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var tutionTypeButton: UIButton!
    @IBOutlet weak var groupSizeButton: UIButton!
    @IBOutlet weak var findTutorButton: UIButton!
    var  tutorCommonPickerView:TutorCommonPickerView?
    //Variables For Find Tutor
    var selectStudentString:String?
    var selectedSubjectDictionary:Dictionary<String,Any>?
    var selectedTopicDictionary:Dictionary<String,Any>?
    var selectedTimeSlotString:String?
    var selectedTutionTypeString:String?
    var selectedGroupSizeString:String?
    @IBOutlet weak var picker: AAPickerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         configureDatePicker()
        self.setLayoutAndSetTexts()
        self.setupSideMenu()
      
    }
    func configureDatePicker() -> Void {
        picker.pickerType = .DatePicker
        picker.datePicker?.minimumDate = Date()
        picker.datePicker?.datePickerMode = .date
        picker.dateFormatter.dateFormat = "dd-MM-YYYY"
        picker.dateDidChange = { date in
            print("selectedDate ", date )
        }
    }
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.rightBarButton.addTarget(self, action: #selector(menuClickAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.leftBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Find a Tutor"
        self.findTutorButton.setTitle("Find a Tutor", for: .normal)
        self.view.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.contentView.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.groupSizeButton.isHidden = true
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
    
    //MARK: IBACTIONS

    @IBAction func selectStudentButtonAction(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getStudentList()
    }
   
    @IBAction func selectSubjectButtonAction(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getSubjectList()
    }
    @IBAction func selectTopicButtonAction(_ sender: Any) {
        guard  (self.selectedSubjectDictionary != nil)  else {
            TutorDefaultAlertController.showAlertController(alertMessage:"Please select subject" , showController: self)
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getTopicList()
    }
    @IBAction func selectDateButtonAction(_ sender: Any) {
       
    }
    @IBAction func specifyTimeSlotButtonAction(_ sender: Any) {
        self.openpickerViewController(pickerArray: ["1 PM : 2 PM","3 PM : 4 PM"], selectedPickerType: .TimeSlotType)
    }
    @IBAction func tutionTypeButtonAction(_ sender: Any) {
       self.openpickerViewController(pickerArray: ["solo","group"], selectedPickerType: .TutionType)
    }
    @IBAction func groupSizeButtonAction(_ sender: Any) {
       self.openpickerViewController(pickerArray: ["2","3","4"], selectedPickerType: .GroupSizeType)
    }
    @IBAction func findTutorButtonAction(_ sender: Any) {
        guard (self.selectStudentString != nil)  else {
            TutorDefaultAlertController.showAlertController(alertMessage:"Please select student" , showController: self)
            return
        }
        guard  (self.selectedSubjectDictionary != nil)  else {
            TutorDefaultAlertController.showAlertController(alertMessage:"Please select subject" , showController: self)
            return
        }
        guard  (self.selectedTopicDictionary != nil)  else {
            TutorDefaultAlertController.showAlertController(alertMessage:"Please select topic" , showController: self)
            return
        }
        guard  !(self.picker.text?.isEmpty)!  else {
            TutorDefaultAlertController.showAlertController(alertMessage:"Please select date" , showController: self)
            return
        }
        guard (self.selectedTimeSlotString != nil)  else {
            TutorDefaultAlertController.showAlertController(alertMessage:"Please select Time Slot" , showController: self)
            return
        }
        guard (self.selectedTutionTypeString != nil)  else {
            TutorDefaultAlertController.showAlertController(alertMessage:"Please select Tution Type" , showController: self)
            return
        }
        if self.groupSizeButton.titleLabel?.text == "group"
        {
            guard (self.selectedGroupSizeString != nil)  else {
                TutorDefaultAlertController.showAlertController(alertMessage:"Please select Group Size" , showController: self)
                return
            }
        }
        let parametersDict = ["student_id":"0595D56345","sel_sub":self.selectedSubjectDictionary?["cs_course_name"],"sel_topic":self.selectedTopicDictionary?["sub_subject_name"],"sel_date":picker.text!,"sel_start_time":"12","sel_end_time":"13","sel_tution_type":selectedTutionTypeString,"sel_group_size":selectedGroupSizeString]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getSearchTutorList(parametersDict: parametersDict as NSDictionary)
    }
    
    func openpickerViewController(pickerArray:Array<Any>?,selectedPickerType:PickerDataType) -> Void {
        tutorCommonPickerView = Bundle.main.loadNibNamed("TutorCommonPickerView", owner: self, options: nil)?.first as? TutorCommonPickerView
        tutorCommonPickerView?.pickerListArray = pickerArray! as NSArray
        tutorCommonPickerView?.frame = self.view.bounds
        tutorCommonPickerView?.delegate = self
        tutorCommonPickerView?.selectedPickerDataType = selectedPickerType
        tutorCommonPickerView?.selectedRowInPicker(Row:0, InComponent: 0)
        self.view.addSubview(tutorCommonPickerView!)
    }
   
    // MARK:Select Student List Api Implementation
    func getStudentList() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.studentList) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["login_id":(TutorSharedClass.shared.loginTutorLoginObject?.sm_id) ?? ""]) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let pickerArray = resultDictionary["data"] as? Array<Any>
                    {
                        self.openpickerViewController(pickerArray: pickerArray, selectedPickerType: .SelectStudentType)
                    }
                }
            }else{
                print(info as Any)
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
            }
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
                        self.openpickerViewController(pickerArray: pickerArray, selectedPickerType: .SubjectListType)
                    }
                }
            }else{
                print(info as Any)
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
            }
        }
    }
    
    // MARK:Topic List Api Implementation
    func getTopicList() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.topicList) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["course_id":(self.selectedSubjectDictionary?["cs_cid"] ?? "")]) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let pickerArray = resultDictionary["data"] as? Array<Any>
                    {
                        self.openpickerViewController(pickerArray: pickerArray, selectedPickerType: .TopicListType)
                    }
                }
            }else{
                print(info as Any)
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
            }
        }
    }
    
    // MARK:Topic List Api Implementation
    func getSearchTutorList(parametersDict:NSDictionary?) -> Void {
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
    
    
    //MARK: TutorCommonPickerDelegate
    func cancelButtonClickedInPicker() {
        self.tutorCommonPickerView?.removeFromSuperview()
    }
    func doneButtonClickedInPicker(Value value: String?, InDictionary pickerDictionary: Dictionary<String, Any>?, selectedPickerDataType: PickerDataType?) {
        
        switch selectedPickerDataType {
        case .SelectStudentType?:
            selectStudentString = value
            self.selectStudentButton.setTitle(selectStudentString, for: .normal)
           break
            
        case .SubjectListType?:
            selectedTopicDictionary = nil
            self.selectTopicButton.setTitle("Select Topic", for: .normal)
            selectedSubjectDictionary = pickerDictionary
            self.selectSubjectButton.setTitle(value, for: .normal)
            break
        case .TopicListType?:
            selectedTopicDictionary = pickerDictionary
            self.selectTopicButton.setTitle(value, for: .normal)
            break
            
        case .TimeSlotType?:
          self.selectedTimeSlotString = value
          self.specifyTimeSlotButton.setTitle(value, for: .normal)
            break
            
        case .TutionType?:
            self.selectedTutionTypeString = value
            if value == "solo"
            {
                self.groupSizeButton.isHidden = true
            }else{
                 self.groupSizeButton.isHidden = false
            }
            self.tutionTypeButton.setTitle(value, for: .normal)
            break
            
        case .GroupSizeType?:
            self.selectedGroupSizeString = value
            self.groupSizeButton.setTitle(value, for: .normal)
            break
            
        default:
            break
        }
        
        self.tutorCommonPickerView?.removeFromSuperview()
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
