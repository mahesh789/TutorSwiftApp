//
//  TutorHistoryViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 13/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorHistoryViewController: UIViewController {

    @IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var tabSelectionView:UIView!
    @IBOutlet weak var pastButton:UIButton!
    @IBOutlet weak var upComingButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "History"
        self.view.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
        pastButton.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
        upComingButton.backgroundColor = UIColor (red: 27.0/255.0, green: 171.0/255.0, blue: 171/255.0, alpha: 1.0)

    }
    
    @objc func backBarButtonAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: IBActions
  @IBAction func pastButtonAction(sender:UIButton) {
    pastButton.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
    upComingButton.backgroundColor = UIColor (red: 27.0/255.0, green: 171.0/255.0, blue: 171/255.0, alpha: 1.0)
    }
  @IBAction func upComingButtonAction(sender:UIButton) {
    upComingButton.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
    pastButton.backgroundColor = UIColor (red: 27.0/255.0, green: 171.0/255.0, blue: 171/255.0, alpha: 1.0)
}
    
//    //MARK: UICollectionView Delgate and DataSource Methods
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorTimeSlotCollectionViewCell", for: indexPath) as! TutorTimeSlotCollectionViewCell
//                
//        return cell
//    }

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
