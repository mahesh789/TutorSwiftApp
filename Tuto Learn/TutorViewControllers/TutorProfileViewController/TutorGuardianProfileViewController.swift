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
    
    var regiterTypeString : String?
    var genderTypeString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayoutAndSetTexts()

        // Do any additional setup after loading the view.
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Your Profile"
        self.view.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.contentView.backgroundColor = UIColor.tutorAppBackgroungColor()
        
        self.regiterTypeString = "guardian"
        self.uploadButton.layer.cornerRadius = self.uploadButton.frame.size.height / 2
        self.uploadButton.layer.borderColor = UIColor.white.cgColor
        self.uploadButton.layer.borderWidth = 1.0
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        
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
        
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.studentRegister) as String
        
        let dictionary = NSMutableDictionary()
        //dictionary.setValue(TutorSharedClass.shared.studentId, forKey: "se_id")
        dictionary.setValue("D2AC2B31D5", forKey: "se_id")

        Alamofire.request(urlPath, method: .post, parameters: (dictionary as! [String:Any]), encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
            if response.result.isSuccess
            {
                if let resultDictionary = response.result.value as? NSDictionary
                {
                    if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.StatusOK.rawValue
                    {
                        print(resultDictionary)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        TutorDefaultAlertController.showAlertController(alertMessage: resultDictionary["message"] as? String, showController: self)
                        
                    }else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenInvalid.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue
                            {
                                self.studentDetailApicall()
                            }else{
                                print(token as Any)
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        })
                    }else{
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
    
    func configureDatePicker() -> Void {
        self.dobTextField.pickerType = .DatePicker
        self.dobTextField.datePicker?.datePickerMode = .date
        self.dobTextField.dateFormatter.dateFormat = "dd/MM/YYYY"
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
