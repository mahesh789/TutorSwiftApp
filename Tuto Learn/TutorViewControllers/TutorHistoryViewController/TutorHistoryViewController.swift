//
//  TutorHistoryViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 13/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorHistoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var tabSelectionView:UIView!
    @IBOutlet weak var pastButton:UIButton!
    @IBOutlet weak var upComingButton:UIButton!
    @IBOutlet weak var tutorHistoryCollectionView:UICollectionView!
    var selectedIndex = 0
    var pastHistoryArray:[TutorPastHistoryModel] = []
    var upComingHistoryArray:[TutorPastHistoryModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setLayoutAndSetTexts()
        //self.pastHistoryDataMapping()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getPastHistoryList()
    }
    
    // MARK:PAST_History Api Implementation
    func getPastHistoryList() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.past_History) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary:["user_id":(TutorSharedClass.shared.loginTutorLoginObject?.sm_id ?? ""),"register_type":TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type ?? ""]) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let pastHistoryListArray = resultDictionary["data"] as? Array<Any>
                    {
                        print(pastHistoryListArray)
                        self.pastHistoryArray = TutorPastHistoryModel.modelsFromDictionaryArray(array: pastHistoryListArray as NSArray)
                        self.tutorHistoryCollectionView.reloadData()
                    }
                }
            }else{
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
            }
        }
    }
    
    // MARK:UPCOMING_History Api Implementation
    func getUpcomingHistoryList() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.upcoming_history) as String
        TutorNetworkManager.performRequestWithUrl(baseUrl: urlPath, parametersDictionary:["user_id":(TutorSharedClass.shared.loginTutorLoginObject?.sm_id ?? ""),"register_type":TutorSharedClass.shared.loginTutorLoginObject?.sm_register_type ?? ""]) { (status, info) in
            if status == Constants.Status.StatusOK.rawValue
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDictionary = info as? Dictionary<String,Any>
                {
                    if let upComingHistoryListArray = resultDictionary["data"] as? Array<Any>
                    {
                        print(upComingHistoryListArray)
                        self.upComingHistoryArray = TutorPastHistoryModel.modelsFromDictionaryArray(array: upComingHistoryListArray as NSArray)
                        self.tutorHistoryCollectionView.reloadData()
                    }
                }
            }else{
                MBProgressHUD.hide(for: self.view, animated: true)
                if let resultDict = info as? Dictionary<String,Any>
                {
                    TutorDefaultAlertController.showAlertController(alertMessage: resultDict["message"] as? String, showController: self)
                }
            }
        }
    }
    
    func pastHistoryDataMapping() -> Void {
        
        let mainArray = NSMutableArray()

        let objectDictionary = NSMutableDictionary()
        objectDictionary.setValue("0595D56345", forKey: "sm_id")
        objectDictionary.setValue("SONU", forKey: "f_name")
        objectDictionary.setValue("GHARAT", forKey: "l_name")
        let childArray = [["sd_date":"06-12-2017","sd_start_time":11,"sd_end_time":12,"sd_subject":"","sd_topic":"","sd_tution_type":"solo","sd_grp_size":"2","tuto_name":"Angha  Gharat","rate":"3","sd_amt":"30"],["sd_date":"06-12-2017","sd_start_time":11,"sd_end_time":12,"sd_subject":"","sd_topic":"","sd_tution_type":"solo","sd_grp_size":"2","tuto_name":"Angha  Gharat","rate":"3","sd_amt":"30"]]
        objectDictionary.setValue(childArray, forKey: "session")

        mainArray.add(objectDictionary)
        pastHistoryArray = TutorPastHistoryModel.modelsFromDictionaryArray(array: mainArray)
        upComingHistoryArray = TutorPastHistoryModel.modelsFromDictionaryArray(array: mainArray)
        self.tutorHistoryCollectionView.reloadData()

    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "History"
        self.view.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
        pastButton.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
        upComingButton.backgroundColor = UIColor (red: 27.0/255.0, green: 171.0/255.0, blue: 171/255.0, alpha: 1.0)
        pastButton.tag = 0
        upComingButton.tag = 1
        tutorHistoryCollectionView?.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)

    }
    
    @objc func backBarButtonAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: IBActions
  @IBAction func pastButtonAction(sender:UIButton) {
    pastButton.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
    upComingButton.backgroundColor = UIColor (red: 27.0/255.0, green: 171.0/255.0, blue: 171/255.0, alpha: 1.0)
    self.tutorHistoryCollectionView.scrollToItem(at: NSIndexPath.init(row: 0, section: 0) as IndexPath, at: .centeredHorizontally, animated: true)
    
    if self.pastHistoryArray.count == 0
    {
        self.getPastHistoryList()
    }
}
  @IBAction func upComingButtonAction(sender:UIButton) {
    upComingButton.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
    pastButton.backgroundColor = UIColor (red: 27.0/255.0, green: 171.0/255.0, blue: 171/255.0, alpha: 1.0)
     self.tutorHistoryCollectionView.scrollToItem(at: NSIndexPath.init(row: 1, section: 0) as IndexPath, at: .centeredHorizontally, animated: true)
    if self.upComingHistoryArray.count == 0
    {
         self.getUpcomingHistoryList()
    }
}
    
    //MARK: UICollectionView Delgate and DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorHistoryCollectionViewCell", for: indexPath) as! TutorHistoryCollectionViewCell
        if indexPath.row == HistoryType.HistoryTypePast.rawValue {
             cell.setDataForHistoryTableViewCellArray(historyDataArray:pastHistoryArray as [TutorPastHistoryModel], index: indexPath.row)
        }else{
             cell.setDataForHistoryTableViewCellArray(historyDataArray:self.upComingHistoryArray as [TutorPastHistoryModel], index: indexPath.row)
        }
       
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width:collectionView.frame.size.width, height:collectionView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.tutorHistoryCollectionView.contentOffset, size: self.tutorHistoryCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.tutorHistoryCollectionView.indexPathForItem(at: visiblePoint)
        if pastButton.tag == indexPath?.row
        {
            pastButton.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
            upComingButton.backgroundColor = UIColor (red: 27.0/255.0, green: 171.0/255.0, blue: 171/255.0, alpha: 1.0)
            if self.pastHistoryArray.count == 0
            {
                self.getPastHistoryList()
            }
            
        }else if upComingButton.tag == indexPath?.row
        {
            upComingButton.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
            pastButton.backgroundColor = UIColor (red: 27.0/255.0, green: 171.0/255.0, blue: 171/255.0, alpha: 1.0)
            if self.upComingHistoryArray.count == 0
            {
                self.getUpcomingHistoryList()
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
