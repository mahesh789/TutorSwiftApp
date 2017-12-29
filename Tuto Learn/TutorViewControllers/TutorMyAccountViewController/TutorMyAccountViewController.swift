//
//  TutorMyAccountViewController.swift
//  Tuto Learn

import UIKit
import Alamofire
class TutorMyAccountViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,TutorMyAccountCollectionViewCellDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tutorNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var guardianButton:UIButton!
    @IBOutlet weak var studentButton:UIButton!
    @IBOutlet weak var preferencesButton:UIButton!
    @IBOutlet weak var tutorMyAccountCollectionView:UICollectionView!
    @IBOutlet weak var footerView:UIView!
    @IBOutlet weak var footerViewHeight:NSLayoutConstraint!

    var dataArray = NSMutableArray()
    var guardianDetailsArray = NSMutableArray()
    var studentDetailsArray :NSMutableArray?
    var preferenceDetailArray :NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setHeaderView()
        if self.guardianDetailsArray.count<=0
        {
            self.getGuardianDetails()
        }
        self.tutorNavigationBar.leftBarButton.addTarget(self, action: #selector(backButtonAction), for:.touchUpInside)
        self.tutorNavigationBar.leftBarButton.isHidden = false
        self.tutorNavigationBar.rightBarButton.isHidden = true
        self.tutorNavigationBar.navigationTitleLabel.text = "My Account"
        guardianButton.isSelected = true
        studentButton.isSelected = false
        preferencesButton.isSelected = false
        guardianButton.backgroundColor = UIColor.init(red: 62, green: 144, blue: 151)
        studentButton.backgroundColor = UIColor.init(red: 73, green: 167, blue: 169)
        preferencesButton.backgroundColor = UIColor.init(red: 73, green: 167, blue: 169)
        self.footerViewHeight.constant = 0
        self.footerView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewData(profileImageValue:String,userName:String)
    {
        let guardianDetails: NSMutableDictionary? = ["type":"1","profileImage":profileImageValue,"userName":userName]
        //
        let studentDetails: NSMutableDictionary? = ["type":"2"]
        let preferenceDetails: NSMutableDictionary? = ["type":"3"]
        dataArray = NSMutableArray()
        dataArray.add(guardianDetails ?? NSDictionary.init())
        dataArray.add(studentDetails ?? NSDictionary.init())
        dataArray.add(preferenceDetails ?? NSDictionary.init())
        
    
    }
    
    func setHeaderView()  {
        
    }
    
    @objc func backButtonAction(sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK :: CollectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataArray.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.layer.frame.height)
        return CGSize(width: collectionView.layer.frame.width, height: collectionView.layer.frame.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorMyAccountCollectionViewCell", for: indexPath) as? TutorMyAccountCollectionViewCell
        collectionViewCell?.delegate = self
        let cellData = self.dataArray.object(at: indexPath.row) as? NSMutableDictionary
        if cellData?.value(forKey: "type") as? String == "1"
        {
            collectionViewCell?.updateViewLayout(cellData: cellData!, tableViewArray: self.guardianDetailsArray)
            
        }else if cellData?.value(forKey: "type") as? String == "2"
        {
            if studentDetailsArray?.count == nil
            {
                self.getStudentList()
            }else
            {
                collectionViewCell?.updateViewLayout(cellData: cellData!, tableViewArray: self.studentDetailsArray!)
            }
        }else if cellData?.value(forKey: "type") as? String == "3"
        {
            if preferenceDetailArray?.count == nil
            {
                MBProgressHUD.showAdded(to: self.view, animated: true)

                self.getpreferenceData()
            }else
            {
                collectionViewCell?.updateViewLayout(cellData: cellData!, tableViewArray: self.preferenceDetailArray!)
            }
        }
        return collectionViewCell!
    }
    
    
    
    func setGuardianData(gaudianDetails:NSDictionary)  {
        if TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type == "0"
        {
            let guardianGenderDetails: NSMutableDictionary? = ["title":"Gender","value":gaudianDetails.value(forKey: "pm_gender") ?? ""]
            let guardianDOBDetails: NSMutableDictionary? = ["title":"Date of Birth","value":gaudianDetails.value(forKey: "pm_dob") ?? ""]
            let guardianEmailDetails: NSMutableDictionary? = ["title":"EmailID","value":gaudianDetails.value(forKey: "pm_email") ?? ""]
            let guardianMobileDetails: NSMutableDictionary? = ["title":"Mobile","value":gaudianDetails.value(forKey: "pm_phone") ?? ""]
            let guardianOccupationDetails: NSMutableDictionary? = ["title":"Occupation","value":gaudianDetails.value(forKey: "pm_occupation") ?? ""]
            self.guardianDetailsArray.add(guardianGenderDetails ?? NSMutableDictionary.init())
            self.guardianDetailsArray.add(guardianDOBDetails ?? NSMutableDictionary.init())
            self.guardianDetailsArray.add(guardianEmailDetails ?? NSMutableDictionary.init())
            self.guardianDetailsArray.add(guardianMobileDetails ?? NSMutableDictionary.init())
            self.guardianDetailsArray.add(guardianOccupationDetails ?? NSMutableDictionary.init())
            
            let userName = "\(gaudianDetails["pm_first_name"] as? String ?? "") \(gaudianDetails["pm_last_name"] as? String ?? "")"

            self.setViewData(profileImageValue: gaudianDetails .value(forKey: "pm_img") as? String ?? "" ,userName:  userName)

        }else
        {
            let guardianGenderDetails: NSMutableDictionary? = ["title":"Gender","value":gaudianDetails.value(forKey: "sm_gender") ?? ""]
            let guardianDOBDetails: NSMutableDictionary? = ["title":"Date of Birth","value":gaudianDetails.value(forKey: "sm_dob") ?? ""]
            let guardianEmailDetails: NSMutableDictionary? = ["title":"EmailID","value":gaudianDetails.value(forKey: "sm_email") ?? ""]
            let guardianMobileDetails: NSMutableDictionary? = ["title":"Mobile","value":gaudianDetails.value(forKey: "sm_mobile") ?? ""]
            let guardianOccupationDetails: NSMutableDictionary? = ["title":"Occupation","value":gaudianDetails.value(forKey: "sm_occupation") ?? ""]
            self.guardianDetailsArray.add(guardianGenderDetails ?? NSMutableDictionary.init())
            self.guardianDetailsArray.add(guardianDOBDetails ?? NSMutableDictionary.init())
            self.guardianDetailsArray.add(guardianEmailDetails ?? NSMutableDictionary.init())
            self.guardianDetailsArray.add(guardianMobileDetails ?? NSMutableDictionary.init())
            self.guardianDetailsArray.add(guardianOccupationDetails ?? NSMutableDictionary.init())
           
            
            let userName = "\(gaudianDetails["sm_name"] as? String ?? "") \(gaudianDetails["sm_last"] as? String ?? "")"

            self.setViewData(profileImageValue: gaudianDetails .value(forKey: "sm_profile_image") as? String ?? "",userName: userName)

        }

      //  tutorMyAccountCollectionView.reloadData()
    }
    
    
    func getGuardianDetails() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameterData = [String: String]()
       
         print(parameterData);
        var urlPath: String?
        if TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type == "0"
        {
            parameterData["userid"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_id
            parameterData["register_type"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type
            urlPath = String(format: "%@%@",Constants.baseUrl,Constants.getGaurdianDetailForStudent) as String
        }else
        {
            parameterData["user_id"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_id
            parameterData["register_type"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type
            urlPath = String(format: "%@%@",Constants.baseUrl,Constants.profileDetails) as String
        }
        Alamofire.request(urlPath!, method: .post, parameters:parameterData , encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
            if response.result.isSuccess
            {
                if let resultDictionary = response.result.value as? NSDictionary
                {
                    print(resultDictionary)
                    
                    if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.StatusOK.rawValue
                    {
                        print(resultDictionary)
                        if let resultParseLoginDictionary = resultDictionary.object(forKey: "data") as? NSDictionary
                        {
                            self.setGuardianData(gaudianDetails: resultParseLoginDictionary)
                            self.getpreferenceData()
                        }
                        
                    }
                    else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.getGuardianDetails()
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
                                self.getGuardianDetails()
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
    
    func getStudentList() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.studentList) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["login_id":(TutorSharedClass.shared.loginTutorLoginObject?.sm_id) ?? "","register_type":(TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type) as Any]) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let pickerArray = resultDictionary["data"] as? Array<Any>
                    {
                       self.setStudentData(studentArray: pickerArray)
                    }
                }
            }
            
        }
    }
    
    func setStudentData(studentArray:Array<Any>)  {
        
        let mutableArray = NSMutableArray()
        for studentData in studentArray {
            
            if let studentDataTemp = studentData as? NSDictionary
            {
                let mutableData = NSMutableDictionary.init(dictionary: studentDataTemp)
                
                let studentDataArray = NSMutableArray()
                let studentgender = NSMutableDictionary.init(objects: [studentDataTemp["sm_gender"] ?? "","Gender"], forKeys: ["value" as NSCopying,"title" as NSCopying])
                let studentDob = NSMutableDictionary.init(objects: [studentDataTemp["sm_dob"] ?? "","Date of Birth"], forKeys: ["value" as NSCopying,"title" as NSCopying])
                let studentEmail = NSMutableDictionary.init(objects: [studentDataTemp["sm_email"] ?? "","Email"], forKeys: ["value" as NSCopying,"title" as NSCopying])
                let studentmobile = NSMutableDictionary.init(objects: [studentDataTemp["sm_mobile"] ?? "","Mobile"], forKeys: ["value" as NSCopying,"title" as NSCopying])
                let studentSchool = NSMutableDictionary.init(objects: [studentDataTemp["sm_school_name"] ?? "","School"], forKeys: ["value" as NSCopying,"title" as NSCopying])
                let studentBoard = NSMutableDictionary.init(objects: [studentDataTemp["sm_board_name"] ?? "","Board"], forKeys: ["value" as NSCopying,"title" as NSCopying])
                let studentlevel = NSMutableDictionary.init(objects: [studentDataTemp["sm_level_name"] ?? "","Grade"], forKeys: ["value" as NSCopying,"title" as NSCopying])
                studentDataArray.add(studentgender)
                studentDataArray.add(studentDob)
                studentDataArray.add(studentEmail)
                studentDataArray.add(studentmobile)
                studentDataArray.add(studentSchool)
                studentDataArray.add(studentBoard)
                studentDataArray.add(studentlevel)
                mutableData.setValue(studentDataArray, forKey: "studentList")
                mutableArray.add(mutableData)
            }
        }
        
        studentDetailsArray = mutableArray
        self.tutorMyAccountCollectionView.reloadData()
    }
    
    func getpreferenceData() {

        var parameterData = [String: String]()
        parameterData["user_id"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_id
        parameterData["register_type"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type
        
        print(parameterData);
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.preferenceDetails) as String
        Alamofire.request(urlPath, method: .post, parameters:parameterData , encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")]) .responseJSON { response in
            if response.result.isSuccess
            {
                if let resultDictionary = response.result.value as? NSDictionary
                {
                    print(resultDictionary)
                    
                    if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.StatusOK.rawValue
                    {
                        print(resultDictionary)
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        if let resultParseLoginDictionary = resultDictionary.object(forKey: "data") as? NSDictionary
                        {
                            self.setPreferenceData(preferenceDetails: resultParseLoginDictionary)
                        }
                    }
                    else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.getpreferenceData()
                            }
                            else {
                                print(token as Any)
                                DispatchQueue.main.async {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                }
                                
                            }
                        })
                    }else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenNotFound.rawValue
                    {
                        TutorGenerateToken.performGenerateTokenUrl(completionHandler: { (status, token) in
                            if status == Constants.Status.StatusOK.rawValue {
                                self.getpreferenceData()
                            }
                            else {
                                print(token as Any)
                                DispatchQueue.main.async {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                }
                                
                            }
                        })
                    }
                    else{
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        //  TutorDefaultAlertController.showAlertController(alertMessage: resultDictionary["message"] as? String, showController: self)
                    }
                }
            }
            else if response.result.isFailure {
                MBProgressHUD.hide(for: self.view, animated: true)
                print(response.result.error as Any)
            }
        }
    }
    
    func setPreferenceData(preferenceDetails:NSDictionary)  {
        
        self.preferenceDetailArray = NSMutableArray()
        let guardianGenderDetails: NSMutableDictionary? = ["title":"Time of Contact","value":preferenceDetails.value(forKey: "sp_contact_time") ?? ""]
        let guardianDOBDetails: NSMutableDictionary? = ["title":"Mode of Contact","value":preferenceDetails.value(forKey: "sp_contact_mode") ?? ""]
        let guardianEmailDetails: NSMutableDictionary? = ["title":"Tution Type","value":preferenceDetails.value(forKey: "sp_tution_type") ?? ""]
        let guardianMobileDetails: NSMutableDictionary? = ["title":"Preferred Tutor Gender","value":preferenceDetails.value(forKey: "sp_prefer_gender") ?? ""]
        
        self.preferenceDetailArray?.add(guardianGenderDetails ?? NSMutableDictionary.init())
        self.preferenceDetailArray?.add(guardianDOBDetails ?? NSMutableDictionary.init())
        self.preferenceDetailArray?.add(guardianEmailDetails ?? NSMutableDictionary.init())
        self.preferenceDetailArray?.add(guardianMobileDetails ?? NSMutableDictionary.init())
        
        tutorMyAccountCollectionView.reloadData()
    }
    
    
    @IBAction func haederButtonClicked(sender:UIButton)
    {
        if sender.isSelected == true
        {
            return
        }
        
        self.setHeaderViewButton(tag: sender.tag)
    }

    func setHeaderViewButton(tag:Int)  {
        if self.dataArray.count>0
        {
            if tag == 1
            {
                guardianButton.isSelected = true
                studentButton.isSelected = false
                preferencesButton.isSelected = false
                guardianButton.backgroundColor = UIColor.init(red: 62, green: 144, blue: 151)
                studentButton.backgroundColor = UIColor.init(red: 73, green: 167, blue: 169)
                preferencesButton.backgroundColor = UIColor.init(red: 73, green: 167, blue: 169)
                self.footerViewHeight.constant = 0
                self.footerView.isHidden = true
                self.view.updateConstraints()
                self.tutorMyAccountCollectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .left, animated: true)
                self.tutorMyAccountCollectionView.reloadData()
            }else if tag == 2
            {
                guardianButton.isSelected = false
                studentButton.isSelected = true
                preferencesButton.isSelected = false
                studentButton.backgroundColor = UIColor.init(red: 62, green: 144, blue: 151)
                guardianButton.backgroundColor = UIColor.init(red: 73, green: 167, blue: 169)
                preferencesButton.backgroundColor = UIColor.init(red: 73, green: 167, blue: 169)
                self.footerViewHeight.constant = 50
                self.footerView.isHidden = false
                self.view.updateConstraints()
                self.tutorMyAccountCollectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .left, animated: true)
                self.tutorMyAccountCollectionView.reloadData()
            }
            else if tag == 3
            {
                guardianButton.isSelected = false
                studentButton.isSelected = false
                preferencesButton.isSelected = true
                preferencesButton.backgroundColor = UIColor.init(red: 62, green: 144, blue: 151)
                studentButton.backgroundColor = UIColor.init(red: 73, green: 167, blue: 169)
                guardianButton.backgroundColor = UIColor.init(red: 73, green: 167, blue: 169)
                self.footerViewHeight.constant = 0
                self.footerView.isHidden = true
                self.view.updateConstraints()
                self.tutorMyAccountCollectionView.scrollToItem(at: IndexPath.init(item: 2, section: 0), at: .left, animated: true)
                self.tutorMyAccountCollectionView.reloadData()
            }
        }
    }
    func editButtonClickedDelegate(type:String,index:Int)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if type == "1"
        {

            let tutorHomeViewController:TutorProfileViewController = storyboard.instantiateViewController(withIdentifier: "TutorProfileViewController") as! TutorProfileViewController
            tutorHomeViewController.currentProfilType = ProfileType.ProfileTypeGuardian.rawValue
            let navigationController = UINavigationController(rootViewController: tutorHomeViewController)
            navigationController.isNavigationBarHidden = true
            tutorHomeViewController.isFromMyAccount = true
            self.navigationController?.pushViewController(tutorHomeViewController, animated: true)
        }else if type == "2"
        {
            if let mutableData = self.studentDetailsArray?.object(at: index) as? NSMutableDictionary
            {
                let tutorHomeViewController:TutorStudentProfileViewController = storyboard.instantiateViewController(withIdentifier: "TutorStudentProfileViewController") as! TutorStudentProfileViewController
                tutorHomeViewController.isEditStudentProfile = true
                tutorHomeViewController.isFromMyAccount = true
                tutorHomeViewController.selectedStudentInfo = mutableData
                let navigationController = UINavigationController(rootViewController: tutorHomeViewController)
                navigationController.isNavigationBarHidden = true
                self.navigationController?.pushViewController(tutorHomeViewController, animated: true)
            }
            
        }else if type == "3"
        {
            
            let tutorHomeViewController:TutorPreferencesViewController = storyboard.instantiateViewController(withIdentifier: "TutorPreferencesViewController") as! TutorPreferencesViewController
            tutorHomeViewController.isfromMyAccount = true
            let navigationController = UINavigationController(rootViewController: tutorHomeViewController)
            navigationController.isNavigationBarHidden = true
            self.navigationController?.pushViewController(tutorHomeViewController, animated: true)

        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        
        visibleRect.origin = tutorMyAccountCollectionView.contentOffset
        visibleRect.size = tutorMyAccountCollectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = tutorMyAccountCollectionView.indexPathForItem(at: visiblePoint)!
        
        self.setHeaderViewButton(tag: visibleIndexPath.item + 1)
        print(visibleIndexPath)
        
    }

    @IBAction func addStudentButtonClicked(sender:UIButton)
    {
        let tutorHomeViewController:TutorStudentProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "TutorStudentProfileViewController") as! TutorStudentProfileViewController
        tutorHomeViewController.isFromMyAccount = true
        self.navigationController?.pushViewController(tutorHomeViewController, animated: true)
    }
    
}
