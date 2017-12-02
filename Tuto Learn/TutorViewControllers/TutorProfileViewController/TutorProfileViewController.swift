//
//  ProfileViewController.swift
//  Tuto Learn
//
//  Created by Reliance Jio on 12/2/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
enum ProfileType:Int {
    case ProfileTypeGuardian = 1,ProfileTypeStudent
}

enum ProfileDataType:Int {
    case ProfileDataTypeFirstName = 1,ProfileDataTypeGender,ProfileDataTypeEmail,ProfileDataTypeMobile,ProfileDataTypeOccupation
}
class TutorProfileViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var profileTableview: UITableView!
    var dataArray :NSMutableArray?
    var currentProfilType:ProfileDataType.RawValue = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGuardianData()

        // Do any additional setup after loading the view.
    }

    func setGuardianData()  {
        let profileNameDetails: NSMutableDictionary? = ["leftTitle":"First Name","rightTitle":"Last Name","leftValue":"","rightValue":"","type":NSNumber.init(value: ProfileDataType.ProfileDataTypeFirstName.rawValue)]
        
        let profilegenderDetails: NSMutableDictionary? = ["leftTitle":"Gender","rightTitle":"Date of Birth","leftValue":"","rightValue":"","type":NSNumber.init(value: ProfileDataType.ProfileDataTypeGender.rawValue)]
        
        let profileEmailDetails: NSMutableDictionary? = ["leftTitle":"Email","rightTitle":"","leftValue":"","rightValue":"","type":NSNumber.init(value: ProfileDataType.ProfileDataTypeEmail.rawValue)]
        
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

}
