//
//  TutorMyAccountCollectionViewCell.swift
//  Tuto Learn

import UIKit
protocol TutorMyAccountCollectionViewCellDelegate: class {
    func editButtonClickedDelegate(type:String,index:Int)
}
class TutorMyAccountCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tutorMyAccountTableView:UITableView!
    var cellDetailsData:NSMutableDictionary?
    var tableViewDetailsArray:NSMutableArray?
    var delegate:TutorMyAccountCollectionViewCellDelegate?

    func updateViewLayout(cellData:NSMutableDictionary, tableViewArray:NSMutableArray)  {
        cellDetailsData = cellData
        tableViewDetailsArray = tableViewArray
        tutorMyAccountTableView.reloadData()
    }
    
    // MARK :: Tableview delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = (Bundle.main.loadNibNamed("TutorMyAccountHeaderView", owner: self, options: nil)![0] as? TutorMyAccountHeaderView)
        if cellDetailsData?.value(forKey: "type") as? String == "3"
        {
            headerView?.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat(40))
        }else
        {
            headerView?.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat(250))

        }
        if cellDetailsData?.value(forKey: "type") as? String == "1" || cellDetailsData?.value(forKey: "type") as? String == "3"
        {
            headerView?.updateheaderView(headerData: self.cellDetailsData!,filterData: NSMutableDictionary.init())

        }else
        {
            headerView?.updateheaderView(headerData: self.cellDetailsData ?? NSMutableDictionary.init(),filterData: self.tableViewDetailsArray?.object(at: section) as? NSMutableDictionary ?? NSMutableDictionary.init())
            headerView?.editButton.tag = section
        }
        headerView?.editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        headerView?.preferenceEditButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)

        //        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TutorMyAccountHeaderView") as! TutorMyAccountHeaderView
        return headerView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if cellDetailsData?.value(forKey: "type") as? String == "2"
        {
            return (self.tableViewDetailsArray?.count)!
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if cellDetailsData?.value(forKey: "type") as? String == "3"
        {
            return 40
        }

        return 255
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellDetailsData?.value(forKey: "type") as? String == "1" || cellDetailsData?.value(forKey: "type") as? String == "3"

        {
            return (tableViewDetailsArray?.count)!
        }else if cellDetailsData?.value(forKey: "type") as? String == "2"
        {
            if let mutableData = tableViewDetailsArray?.object(at: section) as? NSMutableDictionary
            {
                if let sectionArray = mutableData.value(forKey: "studentList") as? NSMutableArray
                {
                    return sectionArray.count
                }
            }
        }else
        {
            return 0
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorMyAccountTableViewCell", for: indexPath) as? TutorMyAccountTableViewCell
        
        cell?.cellTitleLable.textColor = UIColor.init(red: 219, green: 123, blue: 69)
        cell?.cellTitleValueLable.textColor = UIColor.init(red: 119, green: 119, blue: 119)

        if cellDetailsData?.value(forKey: "type") as? String == "1" || cellDetailsData?.value(forKey: "type") as? String == "3"
        {
            let cellData = tableViewDetailsArray?.object(at: indexPath.row) as? NSMutableDictionary
            cell?.cellTitleLable.text = cellData?.value(forKey: "title") as? String
            cell?.cellTitleValueLable.text = cellData?.value(forKey: "value") as? String
        }else if cellDetailsData?.value(forKey: "type") as? String == "2"
        {
            if let mutableData = tableViewDetailsArray?.object(at: indexPath.section) as? NSMutableDictionary
            {
                if let sectionArray = mutableData.value(forKey: "studentList") as? NSMutableArray
                {
                    let cellData = sectionArray.object(at: indexPath.row) as? NSMutableDictionary
                    cell?.cellTitleLable.text = cellData?.value(forKey: "title") as? String
                    cell?.cellTitleValueLable.text = cellData?.value(forKey: "value") as? String
                }
            }
        }
        return cell!
}
   
    @objc func editButtonClicked(sender:UIButton)  {
        
        self.delegate?.editButtonClickedDelegate(type: cellDetailsData?.value(forKey: "type") as? String ?? "", index: sender.tag)
    }
}
