//
//  TutorTeachersListViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 11/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
enum TeacherAvailabLeType:Int {
    case TeacherAvailable = 0
}
class TutorTeachersListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var teachersListCollectionView:UICollectionView!
    @IBOutlet weak var modifySearchButton:UIButton!
    
    var teachersListArray:Array<TutorTeacherModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLayoutAndSetTexts()
}
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Find a Tutor"
        self.view.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.teachersListCollectionView.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.modifySearchButton.layer.cornerRadius = 3
        self.modifySearchButton.layer.borderWidth = 1
        self.modifySearchButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc func backBarButtonAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UICollectionView Delegate & Data Source Methods
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return teachersListArray.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorTeachersListCollectionViewCell", for: indexPath) as! TutorTeachersListCollectionViewCell
        self.setLayoutForTeachersCollectionCell(teacherCollectionCell: cell, atIndex: indexPath)
        return cell
    }
    
    func setLayoutForTeachersCollectionCell(teacherCollectionCell:TutorTeachersListCollectionViewCell,atIndex indexPath:IndexPath) -> Void {
        teacherCollectionCell.profileImageView.layer.cornerRadius = teacherCollectionCell.profileImageView.frame.size.height/2
        teacherCollectionCell.profileImageView.clipsToBounds = true
        teacherCollectionCell.layer.cornerRadius = 5.0
       teacherCollectionCell.clipsToBounds = true
        teacherCollectionCell.backgroundColor = UIColor (red: 27.0/255.0, green: 171.0/255.0, blue: 171/255.0, alpha: 1.0)
        teacherCollectionCell.viewProfieButton.layer.cornerRadius = 3
        teacherCollectionCell.viewProfieButton.layer.borderWidth = 1
        teacherCollectionCell.viewProfieButton.layer.borderColor = UIColor.white.cgColor
        teacherCollectionCell.bookNowButton.layer.cornerRadius = 2
       //Set for Label And Texts
        let tutorTeacherObject = teachersListArray[indexPath.row] as TutorTeacherModel
        teacherCollectionCell.teacherNameLabel.text = tutorTeacherObject.teacherNameString
        teacherCollectionCell.experianceValueLabel.text = tutorTeacherObject.teacherExperienceString
        teacherCollectionCell.ratingValueLabel.text = tutorTeacherObject.teacherRatingString
         teacherCollectionCell.oneOnOneValueLabel.text = String(format:"$ %@",tutorTeacherObject.teacherSoloChargesInt ?? "0")
         teacherCollectionCell.groupValueLabel.text = String(format:"$ %@",tutorTeacherObject.teacherGroupChargesInt ?? "0")
         teacherCollectionCell.viewProfieButton.addTarget(self, action: #selector(viewProfileButtonAction), for:.touchUpInside)
         teacherCollectionCell.bookNowButton.addTarget(self, action: #selector(bookNowButtonAction), for:.touchUpInside)
        teacherCollectionCell.viewProfieButton.tag = indexPath.row
        if tutorTeacherObject.teacherAvailableInt == TeacherAvailabLeType.TeacherAvailable.rawValue
        {
            teacherCollectionCell.unavailableMsgLabel.isHidden = true
            teacherCollectionCell.bookNowButton.setTitle("Book Now", for: .normal)
            teacherCollectionCell.bookNowButton.tag = indexPath.row

        }else{
            teacherCollectionCell.unavailableMsgLabel.isHidden = false
            teacherCollectionCell.unavailableMsgLabel.text = "Tutor unavailable for time slot entered."
             teacherCollectionCell.viewProfieButton.isHidden = true
            teacherCollectionCell.bookNowButton.setTitle("View Availability", for: .normal)
            teacherCollectionCell.bookNowButton.tag = indexPath.row
        }
        teacherCollectionCell.bookNowButton.layer.cornerRadius = 2
        let profileImageUrl = String(format:"%@",(tutorTeacherObject.teacherProfileString ?? ""))
         teacherCollectionCell.profileImageView.kf.setImage(with: URL.init(string:profileImageUrl) , placeholder: UIImage.init(named: "dummyPhoto"), options: nil, progressBlock: nil, completionHandler:{
            (image, error, cacheType, imageUrl) in
            
        })
        
    }
    
    @IBAction func viewProfileButtonAction(sender:UIButton)
    {
        let tutorTeacherObject = teachersListArray[sender.tag] as TutorTeacherModel
        self.navigateViewProfileViewController(tutorTeacherModel: tutorTeacherObject)
    }
    @IBAction func bookNowButtonAction(sender:UIButton)
    {
        if sender.titleLabel?.text == "Book Now"
        {
            let tutorTeacherObject = teachersListArray[sender.tag] as TutorTeacherModel
            self.navigateBookNowViewController(tutorTeacherModel: tutorTeacherObject)
        }else{
            let tutorTeacherObject = teachersListArray[sender.tag] as TutorTeacherModel
            self.navigateTimeSlotViewController(tutorTeacherModel: tutorTeacherObject)
        }
    }
    
    func navigateViewProfileViewController(tutorTeacherModel:TutorTeacherModel) -> Void {
        let tutorViewProfileViewController:TutorViewProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TutorViewProfileViewController") as! TutorViewProfileViewController
        tutorViewProfileViewController.tutorTeacherObject = tutorTeacherModel
        self.navigationController?.pushViewController(tutorViewProfileViewController, animated: true)
    }
    
    func navigateBookNowViewController(tutorTeacherModel:TutorTeacherModel) -> Void {
        let tutorBookTutorViewController:TutorBookTutorViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TutorBookTutorViewController") as! TutorBookTutorViewController
        tutorBookTutorViewController.tutorTeacherObject = tutorTeacherModel
        self.navigationController?.pushViewController(tutorBookTutorViewController, animated: true)
    }
    func navigateTimeSlotViewController(tutorTeacherModel:TutorTeacherModel) -> Void {
        let tutorTimeSlotViewController:TutorTimeSlotViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TutorTimeSlotViewController") as! TutorTimeSlotViewController
        tutorTimeSlotViewController.tutorTeacherObject = tutorTeacherModel
        self.navigationController?.pushViewController(tutorTimeSlotViewController, animated: true)
    }
    
   public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width:((collectionView.frame.size.width)/2)-10, height:406)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    //MARK: IBACTIONS
    @IBAction func modifySearch(sender:Any)
    {
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
