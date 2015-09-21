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
        
        
        let latitude:CLLocationDegrees = 40.7
        let longitude:CLLocationDegrees = -73.9
        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "USA"
        annotation.subtitle = "One random place"
        map.addAnnotation(annotation)
        
        let uilpr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpr.minimumPressDuration = 1
        map.addGestureRecognizer(uilpr)
        
      
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        var userLocation:CLLocation = locations[0] 
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
        labelHeight.text = String(format: "%f", userLocation.altitude)
        labelSpeed.text = String(format: "%f", speed)
        labelCourse.text = String(format: "%f", course)
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks?.first
                print(pm!.locality)
                self.labelAddress.text = String("You are in \(pm!.locality) with Zipcode: \(pm!.postalCode)")
               
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
 
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        print("Gesture Recognize")
        let touchPoint = gestureRecognizer.locationInView(self.map)
        let newCoordinate:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        let annotation = MKPointAnnotation()
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

