//
//  TutorPreferencesViewController.swift
//  Tuto Learn

import UIKit

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
    
    let thePicker = UIPickerView()
    let genderArray = ["Male","Female"]
    var genderValue: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.thePicker.delegate = self
        self.thePicker.dataSource = self
        self.setPreferencesData()
        self.setHeaderView()
        self.setFooterView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPreferencesData()
    {
        let contactDetails: NSMutableDictionary? = ["leftTitle":"Time of Contact","rightTitle":"Mode of Contact","leftValue":"","rightValue":"","type":NSNumber.init(value: PreferencesDataType.PreferencesDataTypeTimeOfContact.rawValue)]
        
        let tutorDetails: NSMutableDictionary? = ["leftTitle":"Tution Type","rightTitle":"Preferred Tutor Gender","leftValue":"","rightValue":"","type":NSNumber.init(value: PreferencesDataType.PreferencesDataTypeTimeOfContact.rawValue)]
        
        dataArray = NSMutableArray()
        dataArray?.add(contactDetails ?? NSDictionary.init())
        dataArray?.add(tutorDetails ?? NSDictionary.init())
        
        self.preferencesTableview.estimatedRowHeight = 60.0
        self.preferencesTableview.rowHeight = UITableViewAutomaticDimension
        
        self.tutorNavigationBar.rightBarButton.isHidden = false
        self.tutorNavigationBar.navigationTitleLabel.text = "Your Profile"
        self.tutorNavigationBar.leftBarButton.isHidden = true
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
        cell?.updateLayout(registrationData: self.dataArray?.object(at: indexPath.row) as! NSDictionary, cellType: RegistrationCellType.RegistrationCellTypeGuardianProfile)
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
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
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
    
    //Mark:: Save Button Click
    @IBAction func submitButtonClicked(sender: AnyObject)
    {
        print("Submit Button Clicked....")
    }
    
}
