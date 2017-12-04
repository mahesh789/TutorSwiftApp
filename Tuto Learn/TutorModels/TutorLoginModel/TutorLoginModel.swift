/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class TutorLoginModel {
	public var sm_id : String?
	public var sm_name : String?
	public var sm_last : String?
	public var sm_email : String?
	public var sm_mobile : String?
	public var sm_gender : String?
	public var sm_dob : String?
	public var sm_profile_image : String?
	public var sm_register_type : String?
	public var spm_occupation : String?
    public var sm_address1 : String?
    public var sm_address2 : String?
    public var sm_city_id : String?
    public var sm_level : String?
    public var sm_pin : String?
    public var sm_school_name : String?

	public var student : Array<TutorStudent>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [TutorLoginModel]
    {
        print(array)
        var models:[TutorLoginModel] = []
        for item in array
        {
            models.append(TutorLoginModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		sm_id = dictionary["sm_id"] as? String
		sm_name = dictionary["sm_name"] as? String
		sm_last = dictionary["sm_last"] as? String
		sm_email = dictionary["sm_email"] as? String
		sm_mobile = dictionary["sm_mobile"] as? String
		sm_gender = dictionary["sm_gender"] as? String
		sm_dob = dictionary["sm_dob"] as? String
		sm_profile_image = dictionary["sm_profile_image"] as? String
		sm_register_type = dictionary["sm_register_type"] as? String
		spm_occupation = dictionary["spm_occupation"] as? String
        sm_address1 = dictionary["sm_address1"] as? String
        sm_address2 = dictionary["sm_address2"] as? String
        sm_city_id = dictionary["sm_city_id"] as? String
        sm_level = dictionary["sm_level"] as? String
        sm_pin = dictionary["sm_pin"] as? String
        sm_school_name = dictionary["sm_school_name"] as? String

        if (dictionary["student"] as? NSArray) != nil
        {
            if (dictionary["student"] != nil) { student = TutorStudent.modelsFromDictionaryArray(array: dictionary["student"] as! NSArray) }
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.sm_id, forKey: "sm_id")
		dictionary.setValue(self.sm_name, forKey: "sm_name")
		dictionary.setValue(self.sm_last, forKey: "sm_last")
		dictionary.setValue(self.sm_email, forKey: "sm_email")
		dictionary.setValue(self.sm_mobile, forKey: "sm_mobile")
		dictionary.setValue(self.sm_gender, forKey: "sm_gender")
		dictionary.setValue(self.sm_dob, forKey: "sm_dob")
		dictionary.setValue(self.sm_profile_image, forKey: "sm_profile_image")
		dictionary.setValue(self.sm_register_type, forKey: "sm_register_type")
		dictionary.setValue(self.spm_occupation, forKey: "spm_occupation")

        if self.student?.isEmpty == false
        {
            let studentData = NSMutableArray()
            for tutorStudentModel in self.student!
            {
                let dataDictionary = tutorStudentModel.dictionaryRepresentation()
                studentData.add(dataDictionary);
            }
            dictionary.setValue(studentData, forKey: "student");
        }
		return dictionary
	}

}
