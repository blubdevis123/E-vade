//
//  FriendsTableTableViewController.swift
//  fbLoginTest
//
//  Created by Fhict on 15/10/15.
//  Copyright © 2015 Robin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Foundation

struct friends {
    static var fbFriends = [Friend]()
}

class FriendsTableTableViewController: UITableViewController
{    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = FBSDKGraphRequest(graphPath:"me/friends", parameters: ["fields":"id,name"]);
        
        request.startWithCompletionHandler
            { (connection, result, error) -> Void in
                if error == nil
                {
                    let resultDict = result as! NSDictionary
                    let data : NSArray = resultDict.objectForKey("data") as! NSArray
                    
                    for i in 0...data.count-1
                    {
                        let valueDict : NSDictionary = data[i] as! NSDictionary
                        friends.fbFriends.append(
                            Friend(id: valueDict.objectForKey("id") as! String,
                                name: valueDict.objectForKey("name") as! String))
                    }
                    self.tableView.reloadData()
                }
                else
                {
                    print("Error Getting Friends \(error)");
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.fbFriends.count
        //return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! fbFriendCell
        
        let currentName = indexPath.row
        cell.fbProfile.image = friends.fbFriends[currentName].getProfilePicture()
        cell.fbName.text = "\(currentName). \(friends.fbFriends[currentName].getName())"
        cell.setFriend(friends.fbFriends[currentName])
        
        //print("Cell with friend: \(self.friendNames[currentName])")
        return cell
    }
}


