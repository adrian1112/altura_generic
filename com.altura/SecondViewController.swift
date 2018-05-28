//
//  SecondViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 27/5/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate {
    var mapView: GMSMapView?
    let locationManager = CLLocationManager()
    var userLatLong: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-2.162870,-79.898407)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        GMSServices.provideAPIKey("AIzaSyD9zVbkyxSGE0swMdmBeQ2-8G9fz1zghZQ");
        
        let camera = GMSCameraPosition.camera(withLatitude: -2.162870, longitude: -79.898407, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -2.162870, longitude: -79.898407)
        marker.title = "Altura S.A."
        marker.snippet = "Altura Services"
        marker.map = mapView
        
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Buscar", style: .plain, target: self, action: Selector("search"))
        
    }
    
    func search(){
            print("Buscandooo...")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLatLong = locations[0].coordinate
        
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
        
        self.setMapCamera()
     
    }
    
    private func setMapCamera(){
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        mapView?.animate(toLocation: userLatLong)
        
        CATransaction.commit();
        
    }

}
