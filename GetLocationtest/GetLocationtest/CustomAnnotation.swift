//
//  CustomMapView.swift
//  E-vade
//
//  Created by Fhict on 15/10/15.
//  Copyright © 2015 Fhict. All rights reserved.
//

import MapKit
import UIKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    private var distance: Double?
    private var fbUserId: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, fbUserId: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
        self.fbUserId = fbUserId
    }
    
    func calculateDistance(sourceCoordinate: CLLocationCoordinate2D){
        let source = CLLocation(latitude: sourceCoordinate.latitude, longitude: sourceCoordinate.longitude)
        let destination = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        self.distance = destination.distanceFromLocation(source)
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Location")
        query.whereKey("FbID", equalTo: self.fbUserId!)
        query.limit = 1
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if(error == nil){
                print("Succes objects \(objects?.count)")
                if let objects = objects {
                    for object in objects{
                        let location = object["Coordinate"] as! PFGeoPoint
                        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                    }
                }
            }
        }
        
    }
    
    func getDistance() -> Double{
        return self.distance!
    }
    func getFbUserId() -> String{
        return self.fbUserId!
    }
}