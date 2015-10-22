//
//  ViewController.swift
//  E-vade
//
//  Created by JN Schouten on 08/10/15.
//  Copyright © 2015 JN Schouten. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate{
    @IBOutlet weak var mkvLocations: MKMapView!
    
    private var timer: NSTimer!
    private var followpointer = false
    private let regionRadius: CLLocationDistance = 50
    private var locationManager = CLLocationManager()
    
    private var lastCheckPoint = CLLocationCoordinate2D(
        latitude: 51.4365957,
        longitude: 5.4780014)
    private var initialLocation = CLLocation(
        latitude: 51.4365957,
        longitude: 5.4780014)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mkvLocations.showsUserLocation = true
        timer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: "createNotification", userInfo: nil, repeats: true)
        initLocationManager()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action:"handleLongPress:")

        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mkvLocations.addGestureRecognizer(lpgr)
        mkvLocations.delegate = self
    }
    
    func initLocationManager(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            if(locationManager.location != nil){
                initialLocation = CLLocation(
                    latitude: locationManager.location!.coordinate.latitude,
                    longitude: locationManager.location!.coordinate.longitude
                )
            }
            
        }
        centerMapOnLocation(initialLocation)
    }
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        initialLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        if(self.followpointer){
            centerMapOnLocation(initialLocation)
        }
        let annotation: CustomAnnotation = CustomAnnotation(coordinate: lastCheckPoint, title: "Check", subtitle: "Check", fbUserId: "")
        annotation.calculateDistance(coord)
        if(annotation.getDistance() > 5){
            lastCheckPoint = CLLocationCoordinate2D(
                latitude: locationManager.location!.coordinate.latitude,
                longitude: locationManager.location!.coordinate.longitude
            )
            createNotification()
        }
        
    }
    
    
    func getCurrentTime() -> String{
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        return DateInFormat
    }
    
    func addAnnotation(title: String, subtitle: String, location: CLLocationCoordinate2D, fbUserID: String){
        if(title != ""){
        let annotation = CustomAnnotation(coordinate: location, title: title, subtitle: subtitle, fbUserId: fbUserID)
        annotation.calculateDistance(self.mkvLocations.userLocation.coordinate)
        mkvLocations.addAnnotation(annotation)
        }else{
            let alertController = UIAlertController(title: "Error", message:
                "Please enter a name!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btResetView(sender: AnyObject) {
        initLocationManager()
    }
    
    @IBAction func swFollow(sender: UISwitch) {
        if(sender.on){
            self.followpointer = true
        }else{
            self.followpointer = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mkvLocations.setRegion(coordinateRegion, animated: true)
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let touchLocation = gestureReconizer.locationInView(self.mkvLocations)
        let locationCoordinate = self.mkvLocations.convertPoint(touchLocation,toCoordinateFromView: self.mkvLocations)
        
        if gestureReconizer.state != UIGestureRecognizerState.Ended {

            let alert = UIAlertController(title: "Spot a friend", message: "", preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.attributedPlaceholder = NSAttributedString(string:"Name")
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                let annotationsToRemove = self.mkvLocations.annotations.filter { $0.title! == textField.text }
                self.mkvLocations.removeAnnotations( annotationsToRemove )
                self.addAnnotation(textField.text!, subtitle: self.getCurrentTime(), location: locationCoordinate, fbUserID: "")

            }))
            
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if gestureReconizer.state != UIGestureRecognizerState.Began {
            return
        }
    }
    
    func mapView(MapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "CustomAnnotation"
        
        if annotation.isKindOfClass(CustomAnnotation.self) {
            var annotationView = MapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView!.canShowCallout = true

                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
                
            } else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        return nil
    }
    
    
    func mapView(MapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let ca: CustomAnnotation = view.annotation as! CustomAnnotation
        ca.calculateDistance(self.mkvLocations.userLocation.coordinate)
        let placeName: String = ca.title!
        let distance: Double = ca.getDistance()
        let placeInfo: String
        if(distance >= 1000){
             placeInfo = "Time spotted: " + ca.subtitle! + "\r\nDistance: " + String(format:"%1.1f", (distance / 1000)) + " KM"
        }else{
             placeInfo = "Time spotted: " + ca.subtitle! + "\r\nDistance: " + String(format:"%1.f", distance) + " Meter"
        }
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        ac.addAction(UIAlertAction(title: "Unfollow", style: .Destructive, handler: {(alert: UIAlertAction) in
            if let annotation = view.annotation as? CustomAnnotation {
                self.mkvLocations.removeAnnotation(annotation)
            }
        }))
        presentViewController(ac, animated: true, completion: nil)
    }

    func createNotification(){
        var distanceAnnotationShort: [String] = [String]()
        var distanceAnnotationLong: [String] = [String]()
        
        for item in self.mkvLocations.annotations{
            if let ca = item as? CustomAnnotation {
                if ca.getFbUserId() != ""{
                    ca.getDataFromParse()
                }
                
                ca.calculateDistance(self.mkvLocations.userLocation.coordinate)
                if(ca.getDistance() < 10){
                    distanceAnnotationShort.append(ca.title!)
                }
                else if (ca.getDistance() > 10 && ca.getDistance() <= 20){
                    distanceAnnotationLong.append(ca.title!)
                }
            }
        }
        
        
        if(distanceAnnotationShort.count > 0 || distanceAnnotationLong.count > 0){
            let date:NSDate = NSDate()
            let calendar:NSCalendar = NSCalendar.currentCalendar()
            
            let dateComp:NSDateComponents = NSDateComponents()
            dateComp.year = calendar.component(.Year, fromDate: date)
            dateComp.month = calendar.component(.Month, fromDate: date)
            dateComp.day = calendar.component(.Day, fromDate: date)
            dateComp.hour = calendar.component(.Hour, fromDate: date)
            dateComp.minute = calendar.component(.Minute, fromDate: date) + 1
            
            if(distanceAnnotationShort.count > 0){
                setNotification(dateComp, message: createNotificationString(distanceAnnotationShort, distance: 10))
            }
            if(distanceAnnotationLong.count > 0){
                setNotification(dateComp, message: createNotificationString(distanceAnnotationLong, distance: 20))
            }
            distanceAnnotationShort.removeAll()
            distanceAnnotationLong.removeAll()
            
        }
    }
    func createNotificationString(strArr: [String], distance: Int) -> String{
        var message: String = ""
        var i: Int = 1
        for item in strArr{
            message += item
            if(i >= strArr.count){
                if(strArr.count == 1){
                    message += " is "
                }else{
                    message += " are "
                }
            }else{
                message += ", "
            }
            i++
        }
        message += "less then \(distance) meters away from you!"
        
        return message
        
    }
    
    func setNotification(dateComp: NSDateComponents, message: String){
        dateComp.timeZone = NSTimeZone.systemTimeZone()
        
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let date:NSDate = calender.dateFromComponents(dateComp)!
        
        let notification:UILocalNotification = UILocalNotification()
        notification.category = "CATEGORY_INSIGHT"
        notification.alertBody = message
        notification.fireDate = date
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
}

