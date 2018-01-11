//
//  TutorMyWalletViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 08/01/18.
//  Copyright © 2018 Tuto. All rights reserved.
//

import UIKit

class TutorMyWalletViewController: UIViewController {
@IBOutlet weak var tutorMyWalletNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var tutorWalletBalanceLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
        self.getWalletBalance()
    }
    
    func setLayoutAndSetTexts() -> Void {
         self.tutorMyWalletNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorMyWalletNavigationBar.rightBarButton.isHidden = true
        self.tutorMyWalletNavigationBar.navigationTitleLabel.text = "Tutor Wallet"
        self.view.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.tutorWalletBalanceLabel.text = "0"
    }

    @objc func backBarButtonAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:Search List Api Implementation
    func getWalletBalance() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.check_Wallet_Balance) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary:["user_id":TutorSharedClass.shared.loginTutorLoginObject?.sm_id ?? "","register_type":TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type ?? ""]) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    print(resultDictionary)
                    if let walletDictionary = resultDictionary["data"] as? Dictionary<String,Any>
                    {
                        if let amount = walletDictionary["amount"] as? String
                        {
                            self.tutorWalletBalanceLabel.text = amount
                        }
                    }
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
