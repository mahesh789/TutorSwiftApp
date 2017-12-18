//
//  TutorProfileViewController.swift
//  Tuto Learn
//
//  Created by Prashant Pandey on 11/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import Alamofire
import AAPickerView

class TutorGuardianProfileViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dobTextField: AAPickerView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    
    @IBOutlet weak var saveProceedButton: UIButton!
    
    var regiterTypeString : String?
    var genderTypeString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayoutAndSetTexts()

        // Do any additional setup after loading the view.
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = false
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Your Profile"
        self.view.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.contentView.backgroundColor = UIColor.tutorAppBackgroungColor()
        
        self.regiterTypeString = "guardian"
        self.uploadButton.layer.cornerRadius = self.uploadButton.frame.size.height / 2
        self.uploadButton.layer.borderColor = UIColor.white.cgColor
        self.uploadButton.layer.borderWidth = 1.0
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2
        
        self.saveProceedButton.layer.cornerRadius = 4.0
        
        self.studentDetailApicall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func backBarButtonAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveProceedButtonClicked(_ sender: Any) {
        
    }
    

    func studentDetailApicall() -> Void {
        
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.editStudent) as String
        
//        let dictionary = NSMutableDictionary()
//        //dictionary.setValue(TutorSharedClass.shared.studentId, forKey: "se_id")
//        dictionary.setValue("D2AC2B31D5", forKey: "se_id")

        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["se_id":(TutorSharedClass.shared.studentId) ?? "D2AC2B31D5"]) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let profileDetailArray = resultDictionary["Data"] as? Array<Any> {
                        print(profileDetailArray as Any)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        TutorDefaultAlertController.showAlertController(alertMessage: resultDictionary["message"] as? String, showController: self)
                    }
                }
            }
            else {
                print(info as Any)
                if let resultDict = info as? Dictionary<String,Any> {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
            }
        }
    }
    
    func updateUI(dictionary:Dictionary<String,Any>?) -> Void {
    }
    
    func configureDatePicker() -> Void {
        self.dobTextField.pickerType = .DatePicker
        self.dobTextField.datePicker?.datePickerMode = .date
        self.dobTextField.datePicker?.maximumDate = Date.init()
        self.dobTextField.dateFormatter.dateFormat = Constants.dateFormatValue
        self.dobTextField.dateDidChange = { date in
            print("selectedDate ", date )
            self.dobTextField.text = self.dobTextField.dateFormatter.string(from: date)
        }
    }
    
    //MARK:: TextField Delegate & Datasource
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        if textField == self.dobTextField {
            return false; //do not show keyboard nor cursor
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.dobTextField {
            self.configureDatePicker()
        }
        return true
    }

}
