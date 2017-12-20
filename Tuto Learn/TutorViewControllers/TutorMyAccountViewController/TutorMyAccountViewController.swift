//
//  TutorMyAccountViewController.swift
//  Tuto Learn

import UIKit
import Alamofire
class TutorMyAccountViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var tutorNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var guardianButton:UIButton!
    @IBOutlet weak var studentButton:UIButton!
    @IBOutlet weak var preferencesButton:UIButton!
    @IBOutlet weak var tutorMyAccountCollectionView:UICollectionView!
    
    var dataArray :NSMutableArray?
    var guardianDetailsArray = NSMutableArray()
    var studentDetailsArray :NSMutableArray?
    var preferenceDetailArray :NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setPreferencesData()
        self.setHeaderView()
        if self.guardianDetailsArray.count<=0
        {
            self.getGuardianDetails()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPreferencesData()
    {
        let guardianDetails: NSMutableDictionary? = ["type":"1"]
        //
        let studentDetails: NSMutableDictionary? = ["type":"2"]
        let preferenceDetails: NSMutableDictionary? = ["type":"3"]
        dataArray = NSMutableArray()
        dataArray?.add(guardianDetails ?? NSDictionary.init())
        dataArray?.add(studentDetails ?? NSDictionary.init())
        dataArray?.add(preferenceDetails ?? NSDictionary.init())
        
        self.tutorNavigationBar.leftBarButton.addTarget(self, action: #selector(backButtonAction), for:.touchUpInside)
        self.tutorNavigationBar.leftBarButton.isHidden = false
        self.tutorNavigationBar.rightBarButton.isHidden = false
        self.tutorNavigationBar.navigationTitleLabel.text = "My Account"
    }
    
    func setHeaderView()  {
        
    }
    
    @objc func backButtonAction(sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK :: CollectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.layer.frame.width, height: collectionView.layer.frame.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorMyAccountCollectionViewCell", for: indexPath) as? TutorMyAccountCollectionViewCell
        let cellData = self.dataArray?.object(at: indexPath.row) as? NSMutableDictionary
        if cellData?.value(forKey: "type") as? String == "1"
        {
            collectionViewCell?.updateViewLayout(cellData: cellData!, tableViewArray: self.guardianDetailsArray)
            
        }else if cellData?.value(forKey: "type") as? String == "2"
        {
            
        }else if cellData?.value(forKey: "type") as? String == "3"
        {
            
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
        }
        tutorMyAccountCollectionView.reloadData()
    }
    
    
    func getGuardianDetails() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameterData = [String: String]()
        parameterData["user_id"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_id
        parameterData["register_type"] = TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type
        // print(parameterData);
        var urlPath: String?
        if TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type == "0"
        {
            urlPath = String(format: "%@%@",Constants.baseUrl,Constants.getGaurdianDetailForStudent) as String
        }else
        {
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
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if let resultParseLoginDictionary = resultDictionary.object(forKey: "data") as? NSDictionary
                        {
                            self.setGuardianData(gaudianDetails: resultParseLoginDictionary)
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
}
