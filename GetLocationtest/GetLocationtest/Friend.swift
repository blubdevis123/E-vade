//
//  Friend.swift
//  E-Vade
//
//  Created by Fhict on 21/10/15.
//  Copyright © 2015 Robin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class Friend
{
    private let id:String
    private let name:String
    private let profilePicture:UIImage
    private var evaded:Bool
    
    init(id:String, name:String)
    {
        self.id = id
        self.name = name
        self.evaded = false
        
        
        let userID = id
        let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(userID)/picture?width=150&length=150")
        
        if let data = NSData(contentsOfURL: facebookProfileUrl!)
        {
            self.profilePicture = UIImage(data: data)!
        }
        else
        {
            self.profilePicture = UIImage()
        }
    }
    
    func Evade()
    {
        evaded = true
    }
    
    func UnEvade()
    {
        evaded = false;
    }
    
    func getId() -> String{
        return self.id
    }
    
    func getName() -> String{
        return self.name
    }
    
    func getProfilePicture() -> UIImage{
        return self.profilePicture
    }
    
    func getEvaded() ->Bool{
        return self.evaded
    }
}