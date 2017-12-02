//
//  ProfileViewController.swift
//  Tuto Learn
//
//  Created by Reliance Jio on 12/2/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import AAPickerView
enum ProfileType:Int {
    case ProfileTypeGuardian = 1,ProfileTypeStudent
}

enum ProfileDataType:Int {
    case ProfileDataTypeFirstName = 1,ProfileDataTypeGender,ProfileDataTypeEmail,ProfileDataTypeMobile,ProfileDataTypeOccupation
}
class TutorProfileViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    @IBOutlet weak var profileTableview: UITableView!
    var dataArray :NSMutableArray?
    var currentProfilType:ProfileDataType.RawValue = 0
    @IBOutlet weak var tutorNavigationBar: TutorHomeNavigationBar!
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    let thePicker = UIPickerView()
    let genderArray = ["Male","Female"]
    var genderValue: String!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {

        self.thePicker.delegate = self
        self.thePicker.dataSource = self
        super.viewDidLoad()
        self.setGuardianData()
        self.setHeaderView()
        self.setFooterView()
        
        // Do any additional setup after loading the view.
    }

    func setGuardianData()  {
        let profileNameDetails: NSMutableDictionary? = ["leftTitle":"First Name","rightTitle":"Last Name","leftValue":"","rightValue":"","type":NSNumber.init(value: ProfileDataType.ProfileDataTypeFirstName.rawValue)]
        
        let profilegenderDetails: NSMutableDictionary? = ["leftTitle":"Gender","rightTitle":"Date of Birth","leftValue":"","rightValue":"","type":NSNumber.init(value: ProfileDataType.ProfileDataTypeGender.rawValue)]
        
        let profileEmailDetails: NSMutableDictionary? = ["rightTitle":"Email","leftTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: ProfileDataType.ProfileDataTypeEmail.rawValue)]
        
        let profileMobileDetails: NSMutableDictionary? = ["leftTitle":"Mobile","rightTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: ProfileDataType.ProfileDataTypeMobile.rawValue)]
        
        
        let profileOccupationDetail: NSMutableDictionary? = ["rightTitle":"Occupation","leftTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: ProfileDataType.ProfileDataTypeOccupation.rawValue)]
        
        dataArray = NSMutableArray()
        dataArray?.add(profileNameDetails ?? NSDictionary.init())
        dataArray?.add(profilegenderDetails ?? NSDictionary.init())
        dataArray?.add(profileEmailDetails ?? NSDictionary.init())
        dataArray?.add(profileMobileDetails ?? NSDictionary.init())
        dataArray?.add(profileOccupationDetail ?? NSDictionary.init())
        self.profileTableview.estimatedRowHeight = 60.0
        self.profileTableview.rowHeight = UITableViewAutomaticDimension
        
        self.tutorNavigationBar.rightBarButton.isHidden = false
        self.tutorNavigationBar.navigationTitleLabel.text = "Your Profile"
        self.tutorNavigationBar.leftBarButton.isHidden = true

    }
    
    func setHeaderView()  {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        self.profileImageView.layer.masksToBounds = true
        self.uploadButton.layer.cornerRadius = 5.0;
        self.uploadButton.layer.borderColor = UIColor.init(red: 73, green: 167, blue: 169).cgColor
        self.uploadButton.layer.masksToBounds = true
        self.uploadButton.layer.borderWidth = 1.0
        if self.currentProfilType == ProfileType.ProfileTypeGuardian.rawValue
        {
            self.titleLabel.text = "Guardian Details"
        }
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
        cell?.updateLayout(registrationData: self.dataArray?.object(at: indexPath.row) as! NSDictionary, cellType: RegistrationCellType.RegistrationCellTypeGuardianProfile)
        cell?.leftTextField.delegate = self
        cell?.rightTextField.delegate = self
        cell?.leftTextField.tag = indexPath.row
        cell?.rightTextField.tag = indexPath.row
        return cell!
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
            let datadictionary = self.dataArray?.object(at: textField.tag) as? NSMutableDictionary
            if datadictionary?.value(forKey: "type") as? Int == ProfileDataType.ProfileDataTypeGender.rawValue && textFieldTemp.customTag == 2
            {
                self.configureDatePicker(textField: textFieldTemp)
            }
            else if datadictionary?.value(forKey: "type") as? Int == ProfileDataType.ProfileDataTypeGender.rawValue && textFieldTemp.customTag == 1
            {
                self.thePicker.tag = 0
                textFieldTemp.inputView = self.thePicker
                self.thePicker.reloadAllComponents()
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldTemp =  textField as? CustomTextField
        {
            let datadictionary = self.dataArray?.object(at: textField.tag) as? NSMutableDictionary
            
            if datadictionary?.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeGender.rawValue && textFieldTemp.customTag == 1
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
    
    func configureDatePicker(textField:AAPickerView) -> Void {
        textField.pickerType = .DatePicker
        textField.datePicker?.datePickerMode = .date
        textField.dateFormatter.dateFormat = "YYYY-MM-dd"
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
    
    
    //MARK:: Upload Action Photo
    @IBAction func uploadPhotoButtonClick()
    {
        let alertController = UIAlertController(title: "Choose Option", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)

        let somethingAction = UIAlertAction(title: "Photo Library", style: .default, handler: {(alert: UIAlertAction!) in
            self.openPhotoLibrary()

        })

        let somethingActionCamera = UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) in
            self.openCameraLibrary()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})

        alertController.addAction(somethingAction)
        alertController.addAction(somethingActionCamera)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})


    }

    
    func openPhotoLibrary()  {
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    func openCameraLibrary()  {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
   @objc func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            self.profileImageView.image = image
        })
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("called")
        self.dismiss(animated: true, completion: { () -> Void in
            
            if let bigImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                    self.profileImageView.image = bigImage

            }
        })
    }
}
