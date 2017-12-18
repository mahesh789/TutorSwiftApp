//
//  TutorHistoryCollectionViewCell.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 14/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

enum HistoryType:Int {
    case HistoryTypePast = 0
    case HistoryTypeUpComing = 1
}

class TutorHistoryCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {
  
    @IBOutlet weak var tutorHistoryTableView:UITableView!
    var historyArray:Array<TutorPastHistoryModel> = []
    var selectedIndex:Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tutorHistoryTableView.rowHeight = UITableViewAutomaticDimension
        self.tutorHistoryTableView.estimatedRowHeight = 100
        self.tutorHistoryTableView.tableFooterView = UIView()
        self.tutorHistoryTableView.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
    }
    
    
    func setDataForHistoryTableViewCellArray(historyDataArray:[TutorPastHistoryModel],index:Int) -> Void {
        self.historyArray = historyDataArray
        self.selectedIndex = index
        self.tutorHistoryTableView.reloadData()
    }
    
    //MARK:UITableView Delegate & Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
       return self.historyArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tutorPastHistoryObject = historyArray[section]
        return tutorPastHistoryObject.session?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TutorHistoryTableViewCell!
        if self.selectedIndex == HistoryType.HistoryTypePast.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: "TutorHistoryTableViewCell", for: indexPath) as! TutorHistoryTableViewCell
        }else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "TutorUpComingHistoryTableViewCell", for: indexPath) as! TutorHistoryTableViewCell
        }
        
        let tutorPastHistoryObject = historyArray[indexPath.section]
        let tutorPastHistorySession = tutorPastHistoryObject.session?[indexPath.row]
        cell.subjectValueLabel.text = tutorPastHistorySession?.sd_subject
        cell.topicValueLabel.text = tutorPastHistorySession?.sd_topic
        cell.sessionValueLabel.text = String(format:"%d",(tutorPastHistorySession?.sd_count ?? 0))
        cell.dateValueLabel.text = tutorPastHistorySession?.sd_date
        cell.timeValueLabel.text = String(format:"%d to %d",(tutorPastHistorySession?.sd_start_time ?? 0),(tutorPastHistorySession?.sd_end_time ?? 0))
        if self.selectedIndex == HistoryType.HistoryTypePast.rawValue {
            cell.paymentValueLabel.text = String(format:"$%@",(tutorPastHistorySession?.sd_amt ?? "0"))
        }
        cell.tutorValueLabel.text = tutorPastHistorySession?.tuto_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let tutorPastHistoryHeaderView = Bundle.main.loadNibNamed("TutorPastHistoryHeaderView", owner: self, options: nil)?.first as? TutorPastHistoryHeaderView
         let tutorPastHistoryObject = historyArray[section]
        tutorPastHistoryHeaderView?.studentName.text = (tutorPastHistoryObject.f_name ?? "") + " \(tutorPastHistoryObject.l_name ?? "")"
        tutorPastHistoryHeaderView?.backgroundColor = UIColor (red: 23.0/255.0, green: 147.0/255.0, blue: 153/255.0, alpha: 1.0)
        let profileImageUrl = ""
        tutorPastHistoryHeaderView?.studentProfileImage.kf.setImage(with: URL.init(string:profileImageUrl) , placeholder: UIImage.init(named: "dummyPhoto"), options: nil, progressBlock: nil, completionHandler:{
            (image, error, cacheType, imageUrl) in
            
        })
        return tutorPastHistoryHeaderView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if self.selectedIndex == HistoryType.HistoryTypePast.rawValue {
             return 260
        }else{
             return 220
        }
    }
   
    
}
