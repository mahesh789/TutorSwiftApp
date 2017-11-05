

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class TutorLoginModel {
	public var address1 : String?
	public var address2 : String?
	public var cityId : Int?
	public var dOB : String?
	public var email : String?
	public var experience : Int?
    public var firstName : String?
	public var gender : String?
	public var lastName : String?
	public var loginKey : String?
	public var mobile : Int?
	public var nIRCNo : String?
	public var nRICImage : String?
	public var pincode : Int?
	public var profileImage : String?
	public var qualification : String?
	public var subjects : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [TutorLoginModel]
    {
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

		address1 = dictionary["Address 1"] as? String
		address2 = dictionary["Address 2"] as? String
		cityId = dictionary["City Id"] as? Int
		dOB = dictionary["DOB"] as? String
		email = dictionary["Email"] as? String
		experience = dictionary["Experience"] as? Int
		firstName = dictionary["First Name"] as? String
		gender = dictionary["Gender"] as? String
		lastName = dictionary["Last Name"] as? String
		loginKey = dictionary["Login Key"] as? String
		mobile = dictionary["Mobile"] as? Int
		nIRCNo = dictionary["NIRC No"] as? String
		nRICImage = dictionary["NRIC Image"] as? String
		pincode = dictionary["Pincode"] as? Int
		profileImage = dictionary["Profile Image"] as? String
		qualification = dictionary["Qualification"] as? String
		subjects = dictionary["Subjects"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.address1, forKey: "Address 1")
		dictionary.setValue(self.address2, forKey: "Address 2")
		dictionary.setValue(self.cityId, forKey: "City Id")
		dictionary.setValue(self.dOB, forKey: "DOB")
		dictionary.setValue(self.email, forKey: "Email")
		dictionary.setValue(self.experience, forKey: "Experience")
		dictionary.setValue(self.firstName, forKey: "First Name")
		dictionary.setValue(self.gender, forKey: "Gender")
		dictionary.setValue(self.lastName, forKey: "Last Name")
		dictionary.setValue(self.loginKey, forKey: "Login Key")
		dictionary.setValue(self.mobile, forKey: "Mobile")
		dictionary.setValue(self.nIRCNo, forKey: "NIRC No")
		dictionary.setValue(self.nRICImage, forKey: "NRIC Image")
		dictionary.setValue(self.pincode, forKey: "Pincode")
		dictionary.setValue(self.profileImage, forKey: "Profile Image")
		dictionary.setValue(self.qualification, forKey: "Qualification")
		dictionary.setValue(self.subjects, forKey: "Subjects")

		return dictionary
	}

}
