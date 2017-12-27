//
//  TutorViewProfileViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 12/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorViewProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var profileTableView:UITableView!
    @IBOutlet weak var teacherNameLabel:UILabel!
    @IBOutlet weak var teacherRatingValueLabel:UILabel!
    @IBOutlet weak var teacherExpValueLabel:UILabel!
    @IBOutlet weak var teacherProfileImageView:UIImageView!
     @IBOutlet weak var bookNowButton:UIButton!
    var viewProfileArray:NSArray = []
    var tutorTeacherObject : TutorTeacherModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
        self.getArrayOfViewProfile()
        self.profileTableView.reloadData()
    }
    func getArrayOfViewProfile() -> Void {
        viewProfileArray = [["title":"Rate per Session","TitleValue":"One-on-One $ \(tutorTeacherObject.teacherSoloChargesInt ?? "0") \nGroup $ \(tutorTeacherObject.teacherGroupChargesInt ?? "0")"],["title":"Educational Qualifications","TitleValue":"\(tutorTeacherObject.teacherQualificationString ?? "")"],["title":"Subjects Taught","TitleValue":"\(tutorTeacherObject.teacherSubjectString ?? "")"],["title":"Bio","TitleValue":tutorTeacherObject.teacherProfileString]]
        self.teacherNameLabel.text = String(format:"%@ %@",(tutorTeacherObject.teacherNameString ?? ""), (tutorTeacherObject.teacherLastNameString ?? ""))
        self.teacherRatingValueLabel.text = tutorTeacherObject.teacherRatingString
        self.teacherExpValueLabel.text = tutorTeacherObject.teacherExperienceString
        let profileImageUrl = String(format:"%@",(tutorTeacherObject.teacherPhotoString ?? ""))
        teacherProfileImageView.kf.setImage(with: URL.init(string:profileImageUrl) , placeholder: UIImage.init(named: "dummyPhoto"), options: nil, progressBlock: nil, completionHandler:{
            (image, error, cacheType, imageUrl) in
            
        })
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Find a Tutor"
        profileTableView.estimatedRowHeight = 85.0
        profileTableView.rowHeight = UITableViewAutomaticDimension
        profileTableView.tableFooterView = UIView.init()
        teacherProfileImageView.layer.cornerRadius = self.teacherProfileImageView.frame.size.height/2
        teacherProfileImageView.clipsToBounds = true
        self.bookNowButton.layer.cornerRadius = 2.0
    }
    @objc func backBarButtonAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITableView Delegate & Datasource Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewProfileArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorViewProfileTableViewCell", for: indexPath) as! TutorViewProfileTableViewCell
        let profileDict = viewProfileArray[indexPath.row] as? NSDictionary
        cell.profileTitleLabel.text = profileDict?["title"] as? String
        cell.profileValueLabel.text = profileDict?["TitleValue"] as? String
        return cell
    }
    
    @IBAction func bookNowButtonAction(sender:Any)
    {
        self.navigateBookTutorViewController(tutorTeacherModel: tutorTeacherObject)
    }
    
    func navigateBookTutorViewController(tutorTeacherModel:TutorTeacherModel) -> Void {
        let selectedTimeSlotDict = ["sel_start_time":String(format:"%@",((TutorSharedClass.shared.findTutorDictionary["sel_start_time"] as? String) ?? "")),"sel_end_time":String(format:"%@",((TutorSharedClass.shared.findTutorDictionary["sel_end_time"] as? String) ?? "")),"sel_date":String(format:"%@",((TutorSharedClass.shared.findTutorDictionary["sel_date"] as? String) ?? ""))]
        let tutorBookTutorViewController:TutorBookTutorViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TutorBookTutorViewController") as! TutorBookTutorViewController
        tutorBookTutorViewController.tutorTeacherObject = tutorTeacherModel
        tutorBookTutorViewController.selectedTimeSlotDict = selectedTimeSlotDict as NSDictionary
        self.navigationController?.pushViewController(tutorBookTutorViewController, animated: true)
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
