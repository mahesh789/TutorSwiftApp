//
//  TutorMyAccountCollectionViewCell.swift
//  Tuto Learn

import UIKit

class TutorMyAccountCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tutorMyAccountTableView:UITableView!
    var cellDetailsData:NSMutableDictionary?
    var tableViewDetailsArray:NSMutableArray?

    func updateViewLayout(cellData:NSMutableDictionary, tableViewArray:NSMutableArray)  {
        cellDetailsData = cellData
        tableViewDetailsArray = tableViewArray
        tutorMyAccountTableView.reloadData()
    }
    
    // MARK :: Tableview delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = (Bundle.main.loadNibNamed("TutorMyAccountHeaderView", owner: self, options: nil)![0] as? TutorMyAccountHeaderView)
        headerView?.frame.size = CGSize(width: tableView.frame.size.width, height: CGFloat(250))
        if cellDetailsData?.value(forKey: "type") as? String == "1"
        {
            headerView?.updateheaderView(headerData: self.cellDetailsData)

        }else
        {
            headerView?.updateheaderView(headerData: self.cellDetailsData)
        }
        //        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TutorMyAccountHeaderView") as! TutorMyAccountHeaderView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 255
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellDetailsData?.value(forKey: "type") as? String == "1"
        {
            return (tableViewDetailsArray?.count)!
        }else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorMyAccountTableViewCell", for: indexPath) as? TutorMyAccountTableViewCell
        if cellDetailsData?.value(forKey: "type") as? String == "1"
        {
            let cellData = tableViewDetailsArray?.object(at: indexPath.row) as? NSMutableDictionary
            cell?.cellTitleLable.text = cellData?.value(forKey: "title") as? String
            cell?.cellTitleValueLable.text = cellData?.value(forKey: "value") as? String
        }
       
        return cell!
    }
}
