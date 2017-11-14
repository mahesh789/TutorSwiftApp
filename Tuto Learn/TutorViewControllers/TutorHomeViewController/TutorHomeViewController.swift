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
        picker.datePicker?.datePickerMode = .date
        picker.dateFormatter.dateFormat = "dd/MM/YYYY"
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
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getTopicList()
    }
    @IBAction func selectDateButtonAction(_ sender: Any) {
       
    }
    @IBAction func specifyTimeSlotButtonAction(_ sender: Any) {
        //self.openpickerViewController(pickerArray: [])
    }
    @IBAction func tutionTypeButtonAction(_ sender: Any) {
        //self.openpickerViewController(pickerArray: [])
    }
    @IBAction func groupSizeButtonAction(_ sender: Any) {
       // self.openpickerViewController(pickerArray: [])
    }
    @IBAction func findTutorButtonAction(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getSearchTutorList()
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
        //(TutorSharedClass.shared.loginTutorLoginObject?.loginId) ?? ""
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.studentList) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["login_id":"46DA9D2D56"]) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let pickerArray = resultDictionary["Data"] as? Array<Any>
                    {
                        self.openpickerViewController(pickerArray: pickerArray, selectedPickerType: .SelectStudentType)
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
   
    // MARK:Subject List Api Implementation
    func getSubjectList() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.subjectList) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: nil) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let pickerArray = resultDictionary["Data"] as? Array<Any>
                    {
                        self.openpickerViewController(pickerArray: pickerArray, selectedPickerType: .SubjectListType)
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
    
    // MARK:Topic List Api Implementation
    func getTopicList() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.topicList) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["course_id":"59e4960a0b739"]) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let pickerArray = resultDictionary["Data"] as? Array<Any>
                    {
                        self.openpickerViewController(pickerArray: pickerArray, selectedPickerType: .TopicListType)
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
    
    // MARK:Topic List Api Implementation
    func getSearchTutorList() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.searchTutor) as String
        let parametersDict = ["student_id":"0595D56345","sel_sub":"IT","sel_topic":"html","sel_date":"11-11-2017","sel_start_time":"12","sel_end_time":"13","sel_tution_type":"solo"]
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: parametersDict) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let techaerListArray = resultDictionary["Data"] as? Array<Any>
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
        if selectedPickerDataType == .SelectStudentType
        {
            selectStudentString = value
            self.selectStudentButton.setTitle(selectStudentString, for: .normal)
            
        }else if selectedPickerDataType == .SubjectListType
        {
           selectedSubjectDictionary = pickerDictionary
           self.selectSubjectButton.setTitle(value, for: .normal)
            
        }else if selectedPickerDataType == .TopicListType
        {
             selectedTopicDictionary = pickerDictionary
             self.selectTopicButton.setTitle(value, for: .normal)
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
