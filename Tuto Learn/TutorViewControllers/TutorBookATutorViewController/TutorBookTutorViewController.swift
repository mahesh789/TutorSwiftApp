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
        var groupSize:String = ""
        var totalCost:String = "0"
        
        if (TutorSharedClass.shared.findTutorDictionary.object(forKey: "sel_tution_type") as? String) == "One-on-One" {
            groupSize = "1"
            totalCost = (tutorTeacherObject.teacherSoloChargesInt ?? "0")
        }else
        {
           // sel_group_size
            groupSize = ((TutorSharedClass.shared.findTutorDictionary.object(forKey: "group_size") ?? "") as? String)!
            totalCost = (tutorTeacherObject.teacherGroupChargesInt ?? "0")
        }
        
        bookTutorArray = [["leftTitleLabel":"Date","leftValueLabel":"\(selectedTimeSlotDict.object(forKey: "sel_date") ?? "")","middleTitleLabel":"Time","middleValueLabel":"\(selectedTimeSlotDict.object(forKey: "sel_start_time") ?? "") to \(selectedTimeSlotDict.object(forKey: "sel_end_time") ?? "") ","rightTitleLabel":"","rightValueLabel":""],["leftTitleLabel":"No. of Sessions","leftValueLabel":"\(TutorSharedClass.shared.findTutorDictionary.object(forKey: "no_session") ?? "")","middleTitleLabel":"Session Type","middleValueLabel":"\(TutorSharedClass.shared.findTutorDictionary.object(forKey: "sel_tution_type") ?? "")","rightTitleLabel":"Group Size","rightValueLabel":"\(groupSize)"],["leftTitleLabel":"Subject","leftValueLabel":"\(tutorTeacherObject.teacherSubjectString ?? "")","middleTitleLabel":"Topic","middleValueLabel":"\(TutorSharedClass.shared.findTutorDictionary.object(forKey: "sel_topic") ?? "")","rightTitleLabel":"","rightValueLabel":""],["leftTitleLabel":"Total Cost","leftValueLabel":"$\(totalCost)","middleTitleLabel":"","middleValueLabel":"","rightTitleLabel":"","rightValueLabel":""]]
        
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
