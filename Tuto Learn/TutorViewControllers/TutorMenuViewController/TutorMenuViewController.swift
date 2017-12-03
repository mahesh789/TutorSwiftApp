//
//  TutorMenuViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 11/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

enum MenuActionType:Int {
    case MenuActionTypeFindTutor = 1,MenuActionTypeMyAccount,MenuActionTypeHistory,MenuActionTypeHelp,MenuActionTypeContactUs
}

class TutorMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var menuTableView:UITableView!
    let menuArray = [["menuTitle":"Find A Tutor","actionType":MenuActionType.MenuActionTypeFindTutor.rawValue],["menuTitle":"My Account","actionType":MenuActionType.MenuActionTypeMyAccount.rawValue],["menuTitle":"History","actionType":MenuActionType.MenuActionTypeHistory.rawValue],["menuTitle":"Help","actionType":MenuActionType.MenuActionTypeHelp.rawValue],["menuTitle":"Contact Us","actionType":MenuActionType.MenuActionTypeContactUs.rawValue]]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.menuTableView.estimatedRowHeight = 100
        self.menuTableView.rowHeight = UITableViewAutomaticDimension
        self.menuTableView.backgroundColor = UIColor (red: 14.0/255.0, green: 104.0/255.0, blue: 119/255.0, alpha: 1.0)
        self.menuTableView.tableFooterView = UIView()
    }
    
    //MARK: UITableView Delegate & DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorMenuTableViewCell", for: indexPath as IndexPath) as! TutorMenuTableViewCell
        let menuDictionary = menuArray[indexPath.row]
        cell.menuOptionsLabel.text = menuDictionary["menuTitle"] as? String
        cell.menuOptionsLabel.textColor = UIColor.white
        if  let menuImageName = menuDictionary["menuTitle"] as? String {
            cell.iconImageView.image = UIImage.init(named:menuImageName)
        }
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor (red: 14.0/255.0, green: 104.0/255.0, blue: 119/255.0, alpha: 1.0)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let menuDictionary = menuArray[indexPath.row]
        let actionType = menuDictionary["actionType"] as! Int
        
        switch actionType
        {
        case MenuActionType.MenuActionTypeFindTutor.rawValue:
             dismiss(animated: true, completion: nil)
            break
        case MenuActionType.MenuActionTypeMyAccount.rawValue:
            
            break
        case MenuActionType.MenuActionTypeHistory.rawValue:

            break
        case MenuActionType.MenuActionTypeHelp.rawValue:
           
            break
        case MenuActionType.MenuActionTypeContactUs.rawValue:
            
            break
        default: print("Other...")
        }
    }
    
    @IBAction func dismissMenuAction(_sender:Any)
    {
        dismiss(animated: true, completion: nil)
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
