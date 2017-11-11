//
//  MJioCommonPickerView.swift
//  MyJio
//
//  Copyright © 2017 Reliance Jio. All rights reserved.
//

import UIKit

protocol TutorCommonPickerViewDelegate : class {
    func cancelButtonClickedInPicker ()
    func doneButtonClickedInPicker (Value value: NSString, InArray pickerArray:NSArray, AtRow row: Int, InComponent component: Int, AtOldRow oldRow:Int)
}

class TutorCommonPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var delegate: TutorCommonPickerViewDelegate?
    
    @IBOutlet weak var toolBarDoneButton: UIBarButtonItem!
    @IBOutlet weak var toolBarCancelButton: UIBarButtonItem!
    @IBOutlet weak var commonPickerView: UIPickerView!
    var pickerListArray : NSArray = []
    var selectedComponent : Int! = 0
    var selectedRow : Int! = 0
    var oldSelectedRow : Int! = 0
    
    override func awakeFromNib() {
        self.decignView()
    }
    
    func decignView () {
        self.commonPickerView.dataSource = self
        self.commonPickerView.delegate = self
        self.commonPickerView.showsSelectionIndicator = true
        
        toolBarCancelButton.title = "Cancel"
        toolBarDoneButton.title = "Done"
    }
    
    //MARK:-  UIPickerView DataSource and Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerListArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerListArray.object(at: row) as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedComponent = component
        selectedRow = row
    }
    
    //MARK:-  ToolBar Button Actions
    @IBAction func cancelButtonClicked(_ sender: Any) {
        delegate?.cancelButtonClickedInPicker ()
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        if pickerListArray.count>0 {
            let result = pickerListArray.object(at: selectedRow) as? NSString
            delegate?.doneButtonClickedInPicker(Value: result!,InArray: pickerListArray, AtRow: selectedRow, InComponent: selectedComponent,AtOldRow: oldSelectedRow)
        }
    }
    
    //MARK:-  Default Selection Actions
    func selectedRowInPicker(Row row:Int, InComponent component:Int) {
        selectedRow = row
        oldSelectedRow = row
        selectedComponent = component
        commonPickerView.selectRow(row, inComponent: component, animated: false)
    }
}
