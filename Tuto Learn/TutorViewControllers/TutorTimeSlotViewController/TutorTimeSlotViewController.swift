//
//  TutorTimeSlotViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 09/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorTimeSlotViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var timeSlotTableView:UITableView!
    @IBOutlet weak var teacherNameLabel:UILabel!
    @IBOutlet weak var timeSlotDescriptionLabel:UILabel!
    @IBOutlet weak var teacherProfileImageView:UIImageView!
    @IBOutlet weak var tableHeaderView:UIView!
   
     var tutorTeacherObject : TutorTeacherModel!
    var tutorTimeSlotHeaderView :TutorTimeSlotHeaderView?
    var timeSlotTableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
         tutorTimeSlotHeaderView = Bundle.main.loadNibNamed("TutorTimeSlotHeaderView", owner: self, options: nil)?.first as? TutorTimeSlotHeaderView
        self.tutorTimeSlotHeaderView?.headerEmptyLabel.backgroundColor = UIColor (red: 27.0/255.0, green: 171.0/255.0, blue: 171/255.0, alpha: 1.0)
      self.tutorTimeSlotHeaderView?.headerFirstLabel.backgroundColor  = self.tutorTimeSlotHeaderView?.headerEmptyLabel.backgroundColor
         self.tutorTimeSlotHeaderView?.headerSecondLabel.backgroundColor  = self.tutorTimeSlotHeaderView?.headerEmptyLabel.backgroundColor
         self.tutorTimeSlotHeaderView?.headerThirdLabel.backgroundColor  = self.tutorTimeSlotHeaderView?.headerEmptyLabel.backgroundColor
        self.tableHeaderView.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
        let when = DispatchTime.now() + 10 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.getTutorTimeTableSlot()
        }
       
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Find a Tutor"
        timeSlotTableView.estimatedRowHeight = 85.0
        timeSlotTableView.rowHeight = UITableViewAutomaticDimension
        timeSlotTableView.tableFooterView = UIView.init()
        teacherProfileImageView.layer.cornerRadius = self.teacherProfileImageView.frame.size.height/2
        teacherProfileImageView.clipsToBounds = true
    }
    
    // MARK:Select Student List Api Implementation
    func getTutorTimeTableSlot() -> Void {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.timeSlotTable) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["tutor_id":"705BF","tuition_date":"14-11-2017","start_time":"11","end_time":"12" as Any]) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let pickerArray = resultDictionary["data"] as? Array<Any>
                    {
                       print(pickerArray as Any)
                    }
                }
            }
            else{
                print(info as Any)
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
            }
            
        }
    }
    
    func timeSlotParsing(slotArray:NSArray) -> Void {
        
        var dateArray = ["14-11-2017","15-11-2017","16-11-2017"]
        
        var timeArray = ["9-10","10-11","11-12","12-13","13-14","14-15","15-16","16-17","17-18","18-19","19-20","20-21"]
        
        if slotArray.count > 0 {
            
            for i in 0 ..< timeArray.count {
                let timeString = timeArray[i] as String
                let splitArray = timeString.split{$0 == "-"}.map(String.init)
                if (splitArray.count > 0)
                {
                   let startTime = splitArray[0]
                   let endTime = splitArray[1]
                   
                   for i in 0 ..< dateArray.count
                   {
                    
                    let searchPredicate = NSPredicate(format: "(sd_date == %@) && (sd_start_time == %@) && (sd_end_time == %@)",dateArray[i],"","")
                   // let filteredArray = accountArray.filtered(using: searchPredicate)
                    
                   }
                    
                }
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorTimeSlotTableViewCell", for: indexPath) as! TutorTimeSlotTableViewCell
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
         return 60
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return self.tutorTimeSlotHeaderView
    }
    
    @objc func backBarButtonAction() -> Void {
        self.navigationController?.popViewController(animated: true)
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