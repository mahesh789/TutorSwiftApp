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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
        self.getArrayOfBookTutor()
    }
    func getArrayOfBookTutor() -> Void {
        bookTutorArray = [["leftTitleLabel":"Date","leftValueLabel":"Nov 30, 2017","middleTitleLabel":"Time","middleValueLabel":"14:00 to 16:00","rightTitleLabel":"","rightValueLabel":""],["leftTitleLabel":"No. of Sessions","leftValueLabel":"2","middleTitleLabel":"Session Type","middleValueLabel":"Group","rightTitleLabel":"Group Size","rightValueLabel":"4"],["leftTitleLabel":"Subject","leftValueLabel":"Chemistry","middleTitleLabel":"Topic","middleValueLabel":"Hydrocarbons","rightTitleLabel":"Total Cost","rightValueLabel":"$120"]]
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Find a Tutor"
        bookTutorTableView.estimatedRowHeight = 85.0
        bookTutorTableView.rowHeight = UITableViewAutomaticDimension
        bookTutorTableView.tableFooterView = UIView.init()
        teacherProfileImageView.layer.cornerRadius = self.teacherProfileImageView.frame.size.height/2
        teacherProfileImageView.clipsToBounds = true
        makePaymentButton.layer.cornerRadius = 2
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
