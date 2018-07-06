//
//  SecondViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 27/5/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
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



class SecondViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, GMSMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var userLatLong = CLLocationCoordinate2D(latitude: -2.162870, longitude: -79.898407)
    
    var placeLatLong = CLLocationCoordinate2D(latitude: -2.162870, longitude: -79.898407)
    
    var places = [
        place.init(name: "Agencia Centro", street: "Coronel y Maldonado", attention: "Lunes a viernes: 07:30 a 17:00 y Sábados: 09:00 a 13:00", coordinate: CLLocationCoordinate2D(latitude: -2.204457, longitude: -79.886952),selected: false),
        place.init(name: "Municipio de Guayaquil", street: "10 de Agosto y Pichincha, entrando por el callejon arosemena", attention: "Lunes a viernes: 08:30 a 16:30", coordinate: CLLocationCoordinate2D(latitude: -2.195159, longitude: -79.880961),selected: false)
    ]
    
    //variables de los detalles
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var blurViewTop: NSLayoutConstraint!
    
    //
    
    //@IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var navigateButton: UIBarButtonItem!
    
    var isInRoute = false;
    
    //para rutas
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    
    var  coordenadas : [CLLocationCoordinate2D] = []
   
    //----------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self

        DispatchQueue.main.async {
            
            self.mapView.camera = GMSCameraPosition(target: self.userLatLong, zoom: 12, bearing: 0, viewingAngle: 0)
            
            self.mapView.settings.compassButton = true;
            
            self.mapView.settings.zoomGestures = true
            self.mapView.settings.myLocationButton = true;
            self.mapView.isMyLocationEnabled = true;
            
            
            
        }
        self.showPins()
        
            self.mapView.addSubview(navigationBar)
        self.mapView.addSubview(blurView)
        
        
    }
    
    
    func showPins(){
        
        for place in places{
            
            let marker = GMSMarker(position: place.coordinate)
            marker.icon = UIImage(named: "place3")
            marker.title = place.name
            marker.map = self.mapView
            
        }
        
        return
    }
    
    //****funciones de mapa****
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     
     if annotation is MKUserLocation{
     return nil
     }
     
     let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
     annotationView.image = UIImage(named:"place2")
     annotationView.canShowCallout = true
     return annotationView
     
     }*/
     
     /*func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
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
        
     }*/
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("seleccionado: \(marker.position)")
        
        var index = 0
        for place in places{
            if place.coordinate.latitude == marker.position.latitude && place.coordinate.longitude == marker.position.longitude{
                
                self.placeLatLong = marker.position
                
                self.titleLabel.text = place.name
                self.addressLabel.text = place.street
                self.attentionLabel.text = place.attention
                self.blurViewTop.constant = -131
                
                places[index].selected = true
                let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16)
                mapView.camera = camera
                
                self.navigateButton.isEnabled = true
                //marker.icon = UIImage(named: "place2")
                
            }else{
                places[index].selected = false
            }
            index = index + 1;
        }
        
        return true
        
    }
    
    
    
    
    
    @IBAction func CloseDetailPin(_ sender: UIButton) {
        self.blurViewTop.constant = 0.0
        
        for index in 0...places.count-1{
            places[index].selected = false
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: self.mapView.camera.target.latitude, longitude: self.mapView.camera.target.longitude, zoom: 12)
        self.mapView.camera = camera
        
        self.navigateButton.isEnabled = false
    }
    
    @IBAction func navigateStart(_ sender: UIBarButtonItem) {

        self.isInRoute = true
        self.obtainCoordinate()
        
        
    }
    
    
    func obtainCoordinate(){
        
            if let start_location = self.mapView.myLocation?.coordinate {
            
                let end_location = placeLatLong
            
                var url_request = baseURLDirections
                
                url_request += "origin=\(start_location.latitude),\(start_location.longitude)&destination=\(end_location.latitude),\(end_location.longitude)"
                
                print(url_request)
                
                DispatchQueue.main.async {
                    
                    let url = URL(string: url_request)
                    
                    URLSession.shared.dataTask(with: url!){ (data , response ,err ) in
                        
                        guard let data = data else {return}

                        do{
                            let dictionary: Dictionary<NSObject, AnyObject> = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<NSObject, AnyObject>
                            
                            var routes: Dictionary<NSObject, AnyObject> = [:]
                            var coord: Dictionary<NSObject, AnyObject> = [:]
                            var ok = false
                            for (key,value) in dictionary {
                                if key as! String == "status" && value as! String == "OK" {
                                    ok = true
                                    print("\(key) = \(value)")
                                }
                                if key as! String == "routes"{
                                    routes = value as! Dictionary<NSObject, AnyObject>
                                }
                            }
                            
                            if ok{
                                for (key,value) in routes {
                                    if key as! String == "legs"{
                                        for (key1,value1) in dictionary {
                                            if key1 as! String == "steps"{
                                                coord = value1 as! Dictionary<NSObject, AnyObject>
                                                
                                            }
                                        }
                                    }
                                }
                                
                                for (key,value) in coord {
                                    if key as! String == "start_location"{
                                        var pos = CLLocationCoordinate2D(latitude: -2.162870, longitude: -79.898407)
                                        
                                        
                                    }
                                }
                                
                                
                                
                            }
                            
                            //print(user.person as Any)
                            /*if((user.status) != nil && user.status! > 0){
                                
                                if(user.status == 1 ){
                                    
                                    //self.txt_alert = "Cuenta no validada mediante correo"
                                }else{
                                    
                                    //self.txt_alert = "usuario:"+user.person!
                                }
                                
                            }else{
                                
                            }*/
                            
                        }catch let errJson {
                            print(errJson);
                            
                            //self.txt_alert = "El usuario no existe"
                        }
                        //sem.signal()
                        
                        }.resume()
                }
                
                self.drawRoute()
            
        }else{
            print("no se pudo obtener rutas")
        }
    }
    
    
    
    func drawRoute() {
        let path = GMSMutablePath()
        
        if let mylocation = self.mapView.myLocation {
            print("User's location: \(mylocation)")
            path.add(mylocation.coordinate)
            path.add(placeLatLong)
            let polyline = GMSPolyline(path: path)
            polyline.map = self.mapView
            polyline.strokeColor = .blue
            polyline.strokeWidth = 2.0
            
        } else {
            print("User's location is unknown")
        }
        
        
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
        //let center = CLLocationCoordinate2D(latitude: placeLatLong.latitude, longitude: placeLatLong.longitude)
        //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //self.map.setRegion(region, animated: true)
        
        CATransaction.commit();
        
    }
    
    private func setMapCameraUser(){
        //CATransaction.begin()
        //CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        //let center = CLLocationCoordinate2D(latitude: userLatLong.latitude, longitude: userLatLong.longitude)
        //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //self.map.setRegion(region, animated: true)
        
        //self.mapViewPrincipal.animate(toLocation: CLLocationCoordinate2D(latitude: userLatLong.latitude, longitude: userLatLong.longitude))
        
        //let target = CLLocationCoordinate2D(latitude: userLatLong.latitude, longitude: userLatLong.longitude)
        //self.mapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 6)
        
        //CATransaction.commit();
        
    }

    @IBAction func findMyLocation(_ sender: Any) {
        self.setMapCameraUser()
    }
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}


