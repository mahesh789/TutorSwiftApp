//
//  TutorBookTutorViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 03/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorBookTutorViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var bookTutorTableView:UITableView!
    @IBOutlet weak var teacherNameLabel:UILabel!
    @IBOutlet weak var bookTutorDescriptionLabel:UILabel!
    @IBOutlet weak var teacherProfileImageView:UIImageView!
    @IBOutlet weak var makePaymentButton:UIButton!
     var bookTutorArray:NSArray = []
     var tutorTeacherObject : TutorTeacherModel!
    var selectedTimeSlotDict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
        self.getArrayOfBookTutor()
    }
    func getArrayOfBookTutor() -> Void {
       self.teacherNameLabel.text = tutorTeacherObject.teacherNameString ?? "" + " \(tutorTeacherObject.teacherLastNameString ?? "")"
        var groupSize:String?
        var totalCost:String? = "0"
        
           // sel_group_size
            groupSize = (selectedTimeSlotDict.object(forKey: "tuition_size") ?? "") as? String
           totalCost  = (selectedTimeSlotDict.object(forKey: "total_amt") ?? "") as? String
        
        bookTutorArray = [["leftTitleLabel":"Date","leftValueLabel":"\(selectedTimeSlotDict.object(forKey: "date") ?? "")","middleTitleLabel":"Time","middleValueLabel":"\(selectedTimeSlotDict.object(forKey: "start_time") ?? "") to \(selectedTimeSlotDict.object(forKey: "end_time") ?? "") ","rightTitleLabel":"","rightValueLabel":""],["leftTitleLabel":"No. of Sessions","leftValueLabel":"\(selectedTimeSlotDict.object(forKey: "session_no") ?? "")","middleTitleLabel":"Session Type","middleValueLabel":"\(selectedTimeSlotDict.object(forKey: "tuition_type") ?? "")","rightTitleLabel":"Group Size","rightValueLabel":"\(groupSize ?? "")"],["leftTitleLabel":"Subject","leftValueLabel":"\(tutorTeacherObject.teacherSubjectString ?? "")","middleTitleLabel":"Topic","middleValueLabel":"\(selectedTimeSlotDict.object(forKey: "topic") ?? "")","rightTitleLabel":"","rightValueLabel":""],["leftTitleLabel":"Total Cost","leftValueLabel":"$\(totalCost ?? "")","middleTitleLabel":"","middleValueLabel":"","rightTitleLabel":"","rightValueLabel":""]]
        
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Book a Tutor"
        bookTutorTableView.estimatedRowHeight = 85.0
        bookTutorTableView.rowHeight = UITableViewAutomaticDimension
        bookTutorTableView.tableFooterView = UIView.init()
         teacherProfileImageView.layer.masksToBounds = false
        teacherProfileImageView.layer.cornerRadius = self.teacherProfileImageView.frame.size.height/2
        teacherProfileImageView.clipsToBounds = true
        makePaymentButton.layer.cornerRadius = 2
        let profileImageUrl = String(format:"%@",(tutorTeacherObject.teacherPhotoString ?? ""))
        teacherProfileImageView.kf.setImage(with: URL.init(string:profileImageUrl) , placeholder: UIImage.init(named: "dummyPhoto"), options: nil, progressBlock: nil, completionHandler:{
            (image, error, cacheType, imageUrl) in
            
        })
    }
    @objc func backBarButtonAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: UITableView Delegate & Datasource Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.bookTutorArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorBookTutorTableViewCell", for: indexPath) as! TutorBookTutorTableViewCell
        let booktutorDictionary = bookTutorArray[indexPath.row] as? NSDictionary
        cell.leftTitleLabel.text = booktutorDictionary?["leftTitleLabel"] as? String
        cell.leftValueLabel.text = booktutorDictionary?["leftValueLabel"] as? String
        cell.middleTitleLabel.text = booktutorDictionary?["middleTitleLabel"] as? String
        cell.middleValueLabel.text = booktutorDictionary?["middleValueLabel"] as? String
        cell.rightTitleLabel.text = booktutorDictionary?["rightTitleLabel"] as? String
        cell.rightValueLabel.text = booktutorDictionary?["rightValueLabel"] as? String
        return cell
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Session Details"
    }
    @IBAction func makePaymentAction(sender:Any)
    {
        self.tutorMakePaymentApiCalling()
    }

    // MARK:MakePayment Api Implementation
    func tutorMakePaymentApiCalling() -> Void {
        let totalAmount = ((selectedTimeSlotDict.object(forKey: "total_amt") ?? "0") as? String)!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.make_payment) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary:["user_id":TutorSharedClass.shared.loginTutorLoginObject?.sm_id ?? "","register_type":TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type ?? "","total_amt":totalAmount,"slot_id":(selectedTimeSlotDict.object(forKey: "slot_id") ?? "")]) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    print(resultDictionary)
                   self.showAlertController(alertMessage: resultDictionary["message"] as? String)
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
    
    func showAlertController(alertMessage:String?) -> Void {
        let alert = UIAlertController(title: "", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ action -> Void in
                self.navigationController?.popToRootViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
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
