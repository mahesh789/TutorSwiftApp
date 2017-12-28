//
//  TutorTimeSlotViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 09/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorTimeSlotViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TimeSlotDelegate {
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
        let dateArray = self.getDateArray()
        if dateArray.count > 0 {
             self.tutorTimeSlotHeaderView?.headerFirstLabel.text = self.tableHeaderDateFormat(dateString: dateArray[0])
              self.tutorTimeSlotHeaderView?.headerSecondLabel.text = self.tableHeaderDateFormat(dateString: dateArray[1])
             self.tutorTimeSlotHeaderView?.headerThirdLabel.text = self.tableHeaderDateFormat(dateString: dateArray[2])
        }
        self.teacherNameLabel.text = tutorTeacherObject.teacherNameString ?? "" + " \(tutorTeacherObject.teacherLastNameString ?? "")"
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.getTutorTimeTableSlot()
       
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Find a Tutor"
        timeSlotTableView.estimatedRowHeight = 85.0
        timeSlotTableView.rowHeight = UITableViewAutomaticDimension
        timeSlotTableView.tableFooterView = UIView.init()
         teacherProfileImageView.layer.masksToBounds = false
        teacherProfileImageView.layer.cornerRadius = self.teacherProfileImageView.frame.size.height/2
        teacherProfileImageView.clipsToBounds = true
        let profileImageUrl = String(format:"%@",(tutorTeacherObject.teacherPhotoString ?? ""))
        teacherProfileImageView.kf.setImage(with: URL.init(string:profileImageUrl) , placeholder: UIImage.init(named: "dummyPhoto"), options: nil, progressBlock: nil, completionHandler:{
            (image, error, cacheType, imageUrl) in
            
        })
    }
    
    // MARK:Select Student List Api Implementation
    func getTutorTimeTableSlot() -> Void {
    
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.timeSlotTable) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary: ["tutor_id":tutorTeacherObject.teacherIdString ?? "","tuition_date":(TutorSharedClass.shared.findTutorDictionary.object(forKey: "sel_date") as? String) ?? "","start_time":(TutorSharedClass.shared.findTutorDictionary.object(forKey: "sel_start_time") as? String) ?? "","end_time":(TutorSharedClass.shared.findTutorDictionary.object(forKey: "sel_end_time") as? String) ?? "" as Any]) { (status, info) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == Constants.Status.StatusOK.rawValue
            {
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let timeSlotArray = resultDictionary["data"] as? Array<Any>
                    {
                       print(timeSlotArray as Any)
                        self.timeSlotParsing(slotArray: timeSlotArray as NSArray)
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
    
    func getDateArray() -> Array<String> {
        //TutorSharedClass.shared.findTutorDictionary
        var dateArray:Array<String> = []
        let date = self.convertStringToDate(dateString: (TutorSharedClass.shared.findTutorDictionary.object(forKey: "sel_date") as? String)!)
        dateArray.append((TutorSharedClass.shared.findTutorDictionary.object(forKey: "sel_date") as? String)!)
       for i in 1 ..< 3
       {
        let indexDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: i, to:date, options: [])!
        dateArray.append(self.convertDateToString(date: indexDate))
      }
        return dateArray
    }
    
    func convertStringToDate(dateString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: dateString) //according to date format your date string
        return date!
    }
    
    func convertDateToString(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    func tableHeaderDateFormat(dateString:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let newdate = dateFormatter.date(from: dateString)
         dateFormatter.dateFormat = "dd"
        let dd = dateFormatter.string(from: newdate!)
         dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.string(from: newdate!)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: newdate!)
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: newdate!)
        return "\(dd) " + "\(month)," + year + "\n\(weekDay)"
    }
    
    func timeSlotParsing(slotArray:NSArray) -> Void {
        
        let dateArray = self.getDateArray()
        var timeArray = ["9-10","10-11","11-12","12-13","13-14","14-15","15-16","16-17","17-18","18-19","19-20","20-21"]
        
        if slotArray.count > 0 {
            
            for i in 0 ..< timeArray.count {
                let timeString = timeArray[i] as String
                let splitArray = timeString.split{$0 == "-"}.map(String.init)
                if (splitArray.count > 0)
                {
                   let startTime = splitArray[0]
                   let endTime = splitArray[1]
                    let headerDictionary = NSMutableDictionary()
                    let rowsArray = NSMutableArray()
                    headerDictionary.setObject(TutorSharedClass.shared.setTimeFormat(startTime: startTime, endTime: endTime), forKey: "time" as NSCopying)
                   for i in 0 ..< dateArray.count
                   {
                    let predicate1 = NSPredicate(format: "sd_date == %@",dateArray[i])
                    let predicate2 = NSPredicate(format: "sd_start_time == %@",startTime)
                    let predicate3 = NSPredicate(format: "sd_end_time == %@",endTime)
                    let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate1,predicate2,predicate3])
                    let filteredArray = slotArray.filtered(using: predicateCompound)
                    if filteredArray.count > 0
                    {
                        rowsArray.add(filteredArray.last ?? "")
                    }else{
                        let emptySlotDictionary = ["available":"1","sd_date":"","sd_start_time":"","sd_end_time":""]
                        rowsArray.add(emptySlotDictionary)
                    }
                    
                   }
                    headerDictionary.setObject(rowsArray, forKey: "slotArray" as NSCopying)
                    self.timeSlotTableArray.add(headerDictionary)
                }
                
            }
            
        }
        print(self.timeSlotTableArray)
        self.timeSlotTableView.reloadData()
        
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeSlotTableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorTimeSlotTableViewCell", for: indexPath) as! TutorTimeSlotTableViewCell
        let timeSlotDictionary = self.timeSlotTableArray[indexPath.row] as? NSDictionary
        cell.timeSlotLabel.text = timeSlotDictionary?["time"] as? String
        let slotArray = timeSlotDictionary?["slotArray"] as? NSArray
        if slotArray?.count ?? 0 > 0 {
            cell.timeSlotReloadArray(slotArray:slotArray!)
        }else{
            cell.timeSlotReloadArray(slotArray:[])
        }
        cell.delegate = self
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
     func selectedSlotBookDetails(slotDictionary:Dictionary<String,Any>)
     {
        let availableStatus = slotDictionary["available"] as? Int
        if availableStatus == 0
        {
            let selectedTimeSlotDict = ["sel_start_time":String(format:"%@:00",((slotDictionary["sd_start_time"] as? String) ?? "")),"sel_end_time":String(format:"%@:00",((slotDictionary["sd_end_time"] as? String) ?? "")),"sel_date":String(format:"%@",((slotDictionary["sd_date"] as? String) ?? ""))]
            self.navigateBookNowViewController(tutorTeacherModel: tutorTeacherObject,selectedDict:selectedTimeSlotDict as NSDictionary)
        }
     }
    
    func navigateBookNowViewController(tutorTeacherModel:TutorTeacherModel,selectedDict:NSDictionary) -> Void {
        let tutorBookTutorViewController:TutorBookTutorViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TutorBookTutorViewController") as! TutorBookTutorViewController
             tutorBookTutorViewController.tutorTeacherObject = tutorTeacherModel
        tutorBookTutorViewController.selectedTimeSlotDict = selectedDict
            self.navigationController?.pushViewController(tutorBookTutorViewController, animated: true)
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
