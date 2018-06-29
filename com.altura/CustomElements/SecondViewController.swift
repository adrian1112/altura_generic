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

struct place{
    let name: String!
    let street: String!
    let attention: String!
    let coordinate: CLLocationCoordinate2D
    var selected: Bool
    
    init(name: String, street: String, attention: String, coordinate : CLLocationCoordinate2D, selected: Bool) {
        self.name = name
        self.street = street
        self.attention = attention
        self.coordinate = coordinate
        self.selected = selected
    }
}

class SecondViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UINavigationControllerDelegate {
    
    let locationManager = CLLocationManager()
    var userLatLong = CLLocationCoordinate2D(latitude: -2.162870, longitude: -79.898407)
    
    var placeLatLong = CLLocationCoordinate2D(latitude: -2.162870, longitude: -79.898407)
    
    var places = [
        place.init(name: "Agencia Centro", street: "Coronel y Maldonado", attention: "Lunes a viernes: 07:30 a 17:00 y Sábados: 09:00 a 13:00", coordinate: CLLocationCoordinate2D(latitude: -2.204457, longitude: -79.886952),selected: false),
        place.init(name: "Municipio de Guayaquil", street: "10 de Agosto y Pichincha, entrando por el callejon arosemena", attention: "Lunes a viernes: 08:30 a 16:30", coordinate: CLLocationCoordinate2D(latitude: -2.195159, longitude: -79.880961),selected: false)
    ]
    
    //variables de los detalles
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var blurViewTop: NSLayoutConstraint!
    
    //
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var navigateButton: UIButton!
    
    var isInRoute = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.map.delegate = self
        self.map.setRegion(MKCoordinateRegionMakeWithDistance(userLatLong, 6000, 6000), animated: true)
        self.map.showsUserLocation = true
        
        self.showPins()
        
        self.blurViewTop.constant = 0.0
        
    }
    
    func showPins(){
        
        for place in places{
            
            let pin1 = CustomPinMap(title: place.name, subtitle: place.street, location: place.coordinate)

            map.addAnnotation(pin1)
        }
        
        return
    }
    
    //****funciones de mapa****
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     
     if annotation is MKUserLocation{
     return nil
     }
     
     let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
     annotationView.image = UIImage(named:"place2")
     annotationView.canShowCallout = true
     return annotationView
     
     }
     
     func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("seleccionado: \(view.annotation?.coordinate)")
       
        self.placeLatLong = (view.annotation?.coordinate)!
        self.setMapCamera()
        var index = 0
        for place in places{
            if place.coordinate.latitude == view.annotation?.coordinate.latitude && place.coordinate.longitude == view.annotation?.coordinate.longitude{
                
                self.titleLabel.text = place.name
                self.addressLabel.text = place.street
                self.attentionLabel.text = place.attention
                self.blurViewTop.constant = -131
                
                places[index].selected = true
                
            }else{
                places[index].selected = false
            }
            index = index + 1;
        }
        
        self.navigateButton.setImage(UIImage(named: "navigation_enabled_2"), for: .normal)
        self.navigateButton.isEnabled = true
        
     }
    
    
    @IBAction func CloseDetailPin(_ sender: UIButton) {
        self.blurViewTop.constant = 0.0
        
        for index in 0...places.count-1{
            places[index].selected = false
        }
        
        self.navigateButton.setImage(UIImage(named: "navigation_disabled_2"), for: .normal)
        self.navigateButton.isEnabled = false
    }
    
    @IBAction func navigateStart(_ sender: UIButton) {
        
        
        //self.isInRoute = false
        self.navigateButton.setImage(UIImage(named: "navigation_start_2"), for: .normal)
    
        self.isInRoute = true
        let destinationLocation = placeLatLong
        let startLocation = userLatLong
        
        print("start: \(startLocation)")
        print("end: \(destinationLocation)")
        
        
        let startPlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: nil)
        let start = MKMapItem(placemark: startPlacemark)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let destination = MKMapItem(placemark: destinationPlacemark)
        let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeTransit]
        MKMapItem.openMaps(with: [start, destination], launchOptions: options)
        
        self.navigateButton.setImage(UIImage(named: "navigation_enabled_2"), for: .normal)
        
    }
    
    //*************
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLatLong = locations[0].coordinate
        
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
     
    }
    
    private func setMapCamera(){
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        let center = CLLocationCoordinate2D(latitude: placeLatLong.latitude, longitude: placeLatLong.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        
        CATransaction.commit();
        
    }
    
    private func setMapCameraUser(){
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        let center = CLLocationCoordinate2D(latitude: userLatLong.latitude, longitude: userLatLong.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        
        CATransaction.commit();
        
    }

    @IBAction func findMyLocation(_ sender: Any) {
        self.setMapCameraUser()
    }
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
