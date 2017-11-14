//
//  MJioCommonPickerView.swift
//  MyJio
//
//  Copyright © 2017 Reliance Jio. All rights reserved.
//

import UIKit

protocol TutorCommonPickerViewDelegate : class {
    func cancelButtonClickedInPicker ()
    func doneButtonClickedInPicker (Value value: String?, InDictionary pickerDictionary:Dictionary<String,Any>?,selectedPickerDataType:PickerDataType?)
}

public enum PickerDataType:Int {
    case SubjectListType,TopicListType,SelectStudentType
}

class TutorCommonPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var delegate: TutorCommonPickerViewDelegate?
    
    @IBOutlet weak var toolBarDoneButton: UIBarButtonItem!
    @IBOutlet weak var toolBarCancelButton: UIBarButtonItem!
    @IBOutlet weak var commonPickerView: UIPickerView!
    public var selectedPickerDataType:PickerDataType?
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
        if selectedPickerDataType == .SubjectListType
        {
            let subjectListDictionary = pickerListArray[row] as! NSDictionary
            return subjectListDictionary["cs_course_name"] as? String
        }else if selectedPickerDataType == .TopicListType
        {
            let topicListDictionary = pickerListArray[row] as! NSDictionary
            return topicListDictionary["sub_subject_name"] as? String
        }else if selectedPickerDataType == .SelectStudentType
        {
            return pickerListArray[row] as? String
        }
        return ""
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
            var selectedString:String?
            var selectedDictionary:Dictionary<String,Any>?
            if selectedPickerDataType == .SubjectListType
            {
                selectedDictionary = pickerListArray[selectedRow] as? Dictionary<String, Any>
                selectedString = selectedDictionary?["cs_course_name"] as? String
            }else if selectedPickerDataType == .TopicListType
            {
                selectedDictionary = pickerListArray[selectedRow] as? Dictionary<String, Any>
                selectedString = selectedDictionary?["sub_subject_name"] as? String
            }else if selectedPickerDataType == .SelectStudentType
            {
                selectedString = pickerListArray[selectedRow] as? String
            }
            delegate?.doneButtonClickedInPicker(Value: selectedString, InDictionary: selectedDictionary, selectedPickerDataType: selectedPickerDataType)
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
