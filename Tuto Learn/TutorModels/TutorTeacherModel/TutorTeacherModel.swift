/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class TutorTeacherModel {
	public var teacherIdString : String?
	public var teacherNameString : String?
	public var teacherLastNameString : String?
	public var teacherGenderString : String?
	public var teacherPhotoString : String?
	public var teacherExperienceString : String?
	public var teacherQualificationString : String?
	public var teacherProfileString : String?
	public var teacherSubjectString : String?
	public var teacherGroupChargesInt : Int?
	public var teacherSoloChargesInt : Int?
	public var teacherAvailableInt : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [TutorTeacherModel]
    {
        var models:[TutorTeacherModel] = []
        for item in array
        {
            models.append(TutorTeacherModel(dictionary: item as! NSDictionary)!)
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

		teacherIdString = dictionary["tm_id"] as? String
		teacherNameString = dictionary["tm_name"] as? String
		teacherLastNameString = dictionary["tm_last_name"] as? String
		teacherGenderString = dictionary["tm_gender"] as? String
		teacherPhotoString = dictionary["tm_photo"] as? String
		teacherExperienceString = dictionary["tm_experience"] as? String
		teacherQualificationString = dictionary["tm_qualification"] as? String
		teacherProfileString = dictionary["tm_profile"] as? String
		teacherSubjectString = dictionary["tm_subject"] as? String
		teacherGroupChargesInt = dictionary["tm_group_charges"] as? Int
		teacherSoloChargesInt = dictionary["tm_solo_charges"] as? Int
		teacherAvailableInt = dictionary["available"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.teacherIdString, forKey: "tm_id")
		dictionary.setValue(self.teacherNameString, forKey: "tm_name")
		dictionary.setValue(self.teacherLastNameString, forKey: "tm_last_name")
		dictionary.setValue(self.teacherGenderString, forKey: "tm_gender")
		dictionary.setValue(self.teacherPhotoString, forKey: "tm_photo")
		dictionary.setValue(self.teacherExperienceString, forKey: "tm_experience")
		dictionary.setValue(self.teacherQualificationString, forKey: "tm_qualification")
		dictionary.setValue(self.teacherProfileString, forKey: "tm_profile")
		dictionary.setValue(self.teacherSubjectString, forKey: "tm_subject")
		dictionary.setValue(self.teacherGroupChargesInt, forKey: "tm_group_charges")
		dictionary.setValue(self.teacherSoloChargesInt, forKey: "tm_solo_charges")
		dictionary.setValue(self.teacherAvailableInt, forKey: "available")

		return dictionary
	}

}
