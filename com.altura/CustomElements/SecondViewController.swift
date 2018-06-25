//
//  SecondViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 27/5/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UINavigationControllerDelegate {
    
    let locationManager = CLLocationManager()
    var userLatLong = CLLocationCoordinate2D(latitude: -2.162870, longitude: -79.898407)
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.setRegion(MKCoordinateRegionMakeWithDistance(userLatLong, 1500, 1500), animated: true)
        map.showsUserLocation = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLatLong = locations[0].coordinate
        
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
     
    }
    
    private func setMapCamera(){
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        let center = CLLocationCoordinate2D(latitude: userLatLong.latitude, longitude: userLatLong.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        
        CATransaction.commit();
        
    }

    @IBAction func findMyLocation(_ sender: Any) {
        self.setMapCamera()
    }
}
