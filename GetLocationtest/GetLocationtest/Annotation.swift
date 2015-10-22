//
//  Annotation.swift
//  GetLocationtest
//
//  Created by Fhict on 08/10/15.
//  Copyright © 2015 Fhict. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var custom_image: Bool = true
    var color: MKPinAnnotationColor = MKPinAnnotationColor.Purple
}

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self;
        
        let annotation = Annotation.new()
        mapView.addAnnotation(annotation)
        
        let annotation2 = Annotation.new()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 1.0)
        annotation2.custom_image = false
        mapView.addAnnotation(annotation2)
        
        let annotation3 = Annotation.new()
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 1.0, longitude:  0.0)
        annotation3.custom_image = false
        annotation3.color = MKPinAnnotationColor.Green
        mapView.addAnnotation(annotation3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}