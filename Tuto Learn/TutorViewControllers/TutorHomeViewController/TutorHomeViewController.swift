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
     self.openpickerViewController(pickerArray: [])
    }
   
    @IBAction func selectSubjectButtonAction(_ sender: Any) {
    }
    @IBAction func selectTopicButtonAction(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getTopicList()
    }
    @IBAction func selectDateButtonAction(_ sender: Any) {
       
    }
    @IBAction func specifyTimeSlotButtonAction(_ sender: Any) {
        self.openpickerViewController(pickerArray: [])
    }
    @IBAction func tutionTypeButtonAction(_ sender: Any) {
        self.openpickerViewController(pickerArray: [])
    }
    @IBAction func groupSizeButtonAction(_ sender: Any) {
        self.openpickerViewController(pickerArray: [])
    }
    @IBAction func findTutorButtonAction(_ sender: Any) {
        
    }
    
    func openpickerViewController(pickerArray:Array<Any>?) -> Void {
        tutorCommonPickerView = Bundle.main.loadNibNamed("TutorCommonPickerView", owner: self, options: nil)?.first as? TutorCommonPickerView
        tutorCommonPickerView?.pickerListArray = pickerArray! as NSArray
        tutorCommonPickerView?.frame = self.view.bounds
        tutorCommonPickerView?.delegate = self
        //selectedPickerType = pickerType
        tutorCommonPickerView?.selectedRowInPicker(Row:0, InComponent: 0)
        self.view.addSubview(tutorCommonPickerView!)
    }
    
    // MARK:Topic List Api Implementation
    func getTopicList() -> Void {
        TutorSharedClass.shared.token = ""
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.topicList) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: nil) { (status, info) in
            
            if status == Constants.Status.StatusOK.rawValue
            {
              MBProgressHUD.hide(for: self.view, animated: true)
                print(info as Any)
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
    
    //MARK: TutorCommonPickerDelegate
    func cancelButtonClickedInPicker() {
        self.tutorCommonPickerView?.removeFromSuperview()
    }
    func doneButtonClickedInPicker(Value value: NSString, InArray pickerArray: NSArray, AtRow row: Int, InComponent component: Int, AtOldRow oldRow: Int) {
        
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
