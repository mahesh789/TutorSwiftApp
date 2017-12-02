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
    var viewProfileArray:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
        self.getArrayOfViewProfile()
        self.profileTableView.reloadData()
    }
    func getArrayOfViewProfile() -> Void {
        viewProfileArray = [["title":"Rate per Session","TitleValue":"One-on-One $ 20 \nGroup $ 15"],["title":"Educational Qualifications","TitleValue":"Bachelore Of Science"],["title":"Subjectes Taught","TitleValue":"Chemistry, Physics"],["title":"Bio","TitleValue":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse quam nibh, ullamcorper eget velit ut, convallis luctus nibh. Integer vel nunc tempor, suscipit tellus vel, suscipit velit."]]
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