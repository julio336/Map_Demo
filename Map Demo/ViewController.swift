//
//  ViewController.swift
//  Map Demo
//
//  Created by Julio Ahuactzin on 10/09/15.
//  Copyright (c) 2015 Julio Ahuactzin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

