//
//  FacebookViewController.swift
//  E-vade
//
//  Created by Fhict on 23/10/15.
//  Copyright © 2015 Fhict. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

struct FbMe {
    static var ownFbId = ""
}
class FacebookViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad()
    {
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Niet ingelogd");
        }
        else
        {
            print("Al ingelogd");
            FbMe.ownFbId = FBSDKAccessToken.currentAccessToken().userID
            self.performSegueWithIdentifier("loginSuccess", sender:self)
        }
        
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = [ "public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        if(FBSDKAccessToken.currentAccessToken() != nil)
        {
            self.performSegueWithIdentifier("loginSuccess", sender:self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil
        {
            print("Ingelogd")
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Uitgelogd")
    }
}


