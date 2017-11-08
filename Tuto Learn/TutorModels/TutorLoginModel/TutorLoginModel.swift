

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class TutorLoginModel {
	public var address1 : String?
	public var address2 : String?
	public var cityId : Int?
	public var dOB : String?
	public var email : String?
    public var firstName : String?
	public var gender : String?
	public var lastName : String?
	public var loginKey : String?
	public var mobile : Int?
	public var pincode : Int?
	public var profileImage : String?
	public var schoolNameString : String?

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

		address1 = dictionary["sm_address1"] as? String
		address2 = dictionary["sm_address2"] as? String
		cityId = dictionary["sm_city_id"] as? Int
		dOB = dictionary["sm_dob"] as? String
		email = dictionary["sm_email"] as? String
		firstName = dictionary["sm_first"] as? String
		gender = dictionary["sm_gender"] as? String
		lastName = dictionary["sm_last"] as? String
		loginKey = dictionary["sm_login_key"] as? String
		mobile = dictionary["sm_mobile"] as? Int
		pincode = dictionary["sm_pin"] as? Int
		profileImage = dictionary["sm_profile_img_url"] as? String
		schoolNameString = dictionary["sm_school_name"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {
        
		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.address1, forKey: "sm_address1")
		dictionary.setValue(self.address2, forKey: "sm_address2")
		dictionary.setValue(self.cityId, forKey: "sm_city_id")
		dictionary.setValue(self.dOB, forKey: "sm_dob")
		dictionary.setValue(self.email, forKey: "sm_email")
		dictionary.setValue(self.firstName, forKey: "sm_first")
		dictionary.setValue(self.gender, forKey: "sm_gender")
		dictionary.setValue(self.lastName, forKey: "sm_last")
		dictionary.setValue(self.loginKey, forKey: "sm_login_key")
		dictionary.setValue(self.mobile, forKey: "sm_mobile")
		dictionary.setValue(self.pincode, forKey: "sm_pin")
		dictionary.setValue(self.profileImage, forKey: "sm_profile_img_url")

		return dictionary
	}

}
