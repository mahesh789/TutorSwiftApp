//
//  TutorMyAccountViewController.swift
//  Tuto Learn

import UIKit

class TutorMyAccountViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tutorNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var guardianButton:UIButton!
    @IBOutlet weak var studentButton:UIButton!
    @IBOutlet weak var preferencesButton:UIButton!
    @IBOutlet weak var tutorMyAccountCollectionView:UICollectionView!
    
    var dataArray :NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setPreferencesData()
        self.setHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPreferencesData()
    {
//        let contactDetails: NSMutableDictionary? = ["leftTitle":"Time of Contact","rightTitle":"Mode of Contact","leftValue":"","rightValue":"","type":NSNumber.init(value: PreferencesDataType.PreferencesDataTypeTimeOfContact.rawValue)]
//
//        let tutorDetails: NSMutableDictionary? = ["leftTitle":"Tution Type","rightTitle":"Preferred Tutor Gender","leftValue":"","rightValue":"","type":NSNumber.init(value: PreferencesDataType.PreferencesDataTutorType.rawValue)]
        
        dataArray = NSMutableArray()
//        dataArray?.add(contactDetails ?? NSDictionary.init())
//        dataArray?.add(tutorDetails ?? NSDictionary.init())
        
        self.tutorNavigationBar.leftBarButton.addTarget(self, action: #selector(backButtonAction), for:.touchUpInside)
        self.tutorNavigationBar.leftBarButton.isHidden = false
        self.tutorNavigationBar.rightBarButton.isHidden = false
        self.tutorNavigationBar.navigationTitleLabel.text = "My Account"
    }
    
    func setHeaderView()  {
        
    }
    
    @objc func backButtonAction(sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK :: CollectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.layer.frame.width, height: collectionView.layer.frame.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorMyAccountCollectionViewCell", for: indexPath) as? TutorMyAccountCollectionViewCell
        return collectionViewCell!
    }
    
    // MARK :: Tableview delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = (Bundle.main.loadNibNamed("TutorMyAccountHeaderView", owner: self, options: nil)![0] as? TutorMyAccountHeaderView)
        headerView?.frame.size = CGSize(width: tableView.frame.size.width, height: CGFloat(250))
        headerView?.updateheaderView()
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TutorMyAccountHeaderView") as! TutorMyAccountHeaderView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 221
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorMyAccountTableViewCell", for: indexPath) as? TutorMyAccountTableViewCell
        cell?.cellTitleLable.text = "Gender"
        cell?.cellTitleValueLable.text = "Male"
        return cell!
    }
}
