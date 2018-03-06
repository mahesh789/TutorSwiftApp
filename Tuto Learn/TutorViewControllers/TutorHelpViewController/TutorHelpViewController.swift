//
//  TutorHelpViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 11/02/18.
//  Copyright © 2018 Tuto. All rights reserved.
//

import UIKit
enum TutorScreenType: Int {
    case TutorScreenTypeHelp = 1, TutorScreenTypeContactus
}

class TutorHelpViewController: UIViewController {
    @IBOutlet weak var tutorHelpNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var tutorDescriptionLabel:UILabel!
  public var tutorScreenType:TutorScreenType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
    }
    func setLayoutAndSetTexts() -> Void {
        self.tutorHelpNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHelpNavigationBar.rightBarButton.isHidden = true
        if tutorScreenType == .TutorScreenTypeHelp {
            self.tutorHelpNavigationBar.navigationTitleLabel.text = "Help"
        }else{
            self.tutorHelpNavigationBar.navigationTitleLabel.text = "Contact Us"
        }
        self.view.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.tutorDescriptionLabel.text = "Please send us email on info@tutoeducation.com"
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
