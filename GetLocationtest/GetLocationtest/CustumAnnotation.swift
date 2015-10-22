//
//  CustumAnnotation.swift
//  GetLocationtest
//
//  Created by Fhict on 15/10/15.
//  Copyright © 2015 Fhict. All rights reserved.
//

import MapKit
import UIKit

class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}