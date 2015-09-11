//
//  ViewController.swift
//  Map Demo
//
//  Created by Julio Ahuactzin on 10/09/15.
//  Copyright (c) 2015 Julio Ahuactzin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var labelLatitude: UILabel!
    
    @IBOutlet var labelLongitude: UILabel!
    
    @IBOutlet var labelHeight: UILabel!
    
    @IBOutlet var labelSpeed: UILabel!
    
    @IBOutlet var labelCourse: UILabel!
    
    @IBOutlet var labelAddress: UILabel!
    
    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        var latitude:CLLocationDegrees = 40.7
        var longitude:CLLocationDegrees = -73.9
        var latDelta:CLLocationDegrees = 0.01
        var lonDelta:CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "USA"
        annotation.subtitle = "One random place"
        map.addAnnotation(annotation)
        
        var uilpr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpr.minimumPressDuration = 1
        map.addGestureRecognizer(uilpr)
        
      
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println(locations)
        var userLocation:CLLocation = locations[0] as! CLLocation
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        var latDelta:CLLocationDegrees = 0.01
        var lonDelta:CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.map.setRegion(region, animated: true)
        
        var speed = userLocation.speed
        var course = userLocation.course
        
        labelLatitude.text = String(stringInterpolationSegment: latitude)
        labelLongitude.text = String(stringInterpolationSegment: longitude)
        labelHeight.text = String(format: "%f", userLocation.verticalAccuracy)
        labelSpeed.text = String(format: "%f", speed)
        labelCourse.text = String(format: "%f", course)
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error) -> Void in
            println(location)
            
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                println(pm.locality)
                self.labelAddress.text = String("You are in  \(pm.locality) with Zipcode: \(pm.postalCode)")
               
            }
            else {
                println("Problem with the data received from geocoder")
            }
        })
 
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        println("Gesture Recognize")
        var touchPoint = gestureRecognizer.locationInView(self.map)
        var newCoordinate:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        var annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = "New place"
        annotation.subtitle = "One new random place"
        map.addAnnotation(annotation)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

