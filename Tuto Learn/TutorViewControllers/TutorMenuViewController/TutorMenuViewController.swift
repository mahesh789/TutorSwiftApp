//
//  TutorMenuViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 11/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var menuTableView:UITableView!
    let menuArray:Array<String> = ["Profile","Student Profile","Preference Settings","Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.menuTableView.estimatedRowHeight = 100
        self.menuTableView.rowHeight = UITableViewAutomaticDimension
        self.menuTableView.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.menuTableView.tableFooterView = UIView()
    }
    
    //MARK: UITableView Delegate & DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorMenuTableViewCell", for: indexPath as IndexPath) as! TutorMenuTableViewCell
        cell.menuOptionsLabel.text = menuArray[indexPath.row]
        cell.menuOptionsLabel.textColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.tutorAppBackgroungColor()
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:      //when profie is clicked...
            let profilControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "TutorGuardianProfileViewController") as? TutorGuardianProfileViewController
            self.navigationController?.pushViewController(profilControllerObj!, animated: true)
            break
        case 1:      //when  is clicked...
            
            break
        case 2:      //when  is clicked...

            break
        case 3:      //when logout is clicked...
           
            TutorSharedClass.removeLoginCredentialsAndSetRootViewControllerLogin()
            break
        default: print("Other...")
        }
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
