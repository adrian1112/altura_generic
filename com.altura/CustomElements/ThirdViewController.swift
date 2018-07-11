//
//  ThirdViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 7/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ThirdViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var select: UITextField!
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var footViewController: UIView!
    
    weak var activeField: UITextField?
    
    let options=["","Opcion1","Opcion2","Opcion3","Opcion4","Opcion5"]
    var pickerView = UIPickerView()
    
    let locationManager = CLLocationManager()
    var userLatLong = CLLocationCoordinate2D(latitude: -2.162870, longitude: -79.898407)
    
    var pins = [PinMap]()
    
    let myBackgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = true
        //navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsWhenKeyboardAppears = false
        
        locationManager.delegate = self
        self.map.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureReconizer:)))
        gesture.minimumPressDuration = 0.3
        gesture.delaysTouchesBegan = true
        gesture.delegate = self
        self.map.addGestureRecognizer(gesture)
        let camera = GMSCameraPosition.camera(withLatitude: userLatLong.latitude,
                                              longitude: userLatLong.longitude,
                                              zoom: 18)
        self.map.camera = camera
        map.settings.zoomGestures = true
        map.settings.myLocationButton = true
        map.isMyLocationEnabled = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = myBackgroundColor
        select.inputView = pickerView
        
    }
    
    //****funciones de mapa****
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        //annotationView.image = UIImage(named:"user-2")
        annotationView.canShowCallout = true
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("seleccionado: \(view.annotation?.coordinate)")
    }*/
    
    //*************
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            let touchLocation = gestureReconizer.location(in: map)
            //let locationCoordinate = map.convert(touchLocation,toCoordinateFrom: map)
            //print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            //let pin1 = PinMap(title: "Reporte", subtitle: "Ubicacion del problema", coordinate: locationCoordinate)
            
            //map.removeAnnotations(pins as [MKAnnotation])
            //pins = []
            //pins.append(pin1)
            //map.addAnnotation(pin1)
            
            
            return
        }
        
        if gestureReconizer.state != UIGestureRecognizerState.began {
            return
        }
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Origen de la foto", message: "Escoja una opción", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("camara no disponible")
                self.showAlert(txt_alert: "Cámara no disponible")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { (action: UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLatLong = locations[0].coordinate
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLatLong.latitude,
                                              longitude: userLatLong.longitude,
                                              zoom: 18)
        self.map.camera = camera
        
    }
    
    /*private func setMapCamera(){
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        let center = CLLocationCoordinate2D(latitude: userLatLong.latitude, longitude: userLatLong.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        
        CATransaction.commit();
        
    }*/
    
    /*@IBAction func myUbication(_ sender: Any) {
        
        self.setMapCamera()
    }*/
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 12)
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.textColor = UIColor.blue
        pickerLabel?.text = self.options[row]
 
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.options[row]
    }
 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.select.text = self.options[row]
        self.select.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.picture.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(txt_alert: String){
        print("entra a alerta")
        let alert = UIAlertController(title: nil, message: txt_alert, preferredStyle: .alert);
        let btn_alert = UIAlertAction(title: "Cerrar", style: .cancel)
        alert.addAction(btn_alert);
        self.present(alert, animated: true, completion: nil);
    }
    
    //HABILITA LA OPCION DE OCULTAR EL TECLADO CUANDO SE LE DA EN CUALQUIER PARTE DE LA PANTALLA Y PARA MOVER LA VIEW SI EL TECLADO OCULTA EL TEXTFIELD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1. Escuchar las notificaciones del teclado.
        registerForKeyboardNotifications()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Siempre hay que dejar de escuchar las notificaciones.
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func startTextFieldEditing(_ sender: UITextField) {
        activeField = sender
        print("entra")
        
    }
    
    @IBAction func endTextFieldEditing(_ sender: UITextField) {
        activeField = nil
    }
 

}

extension ThirdViewController: UITextFieldDelegate {
    // FUNCIONES PARA ESCUCHAR NOTIFICACIONES O EN ESTE CASO EVENTOS DEL TECLADO
    
    // Registro notificaciones teclado.
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(BarTwoViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BarTwoViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Cuando el teclado se va a mostrar.
    @objc func keyboardWillShow(notification: NSNotification) {
        print("entra2")
        guard let activeField = self.activeField else {
            // Si activeField es nil, no se hace nada.
            print("activeField es nil")
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            // Resetear el frame por si acaso.
            view.frame = CGRect(x:0.0,y:0.0, width: view.frame.width, height: view.frame.height)
            
            // Recuperar el frame actual de la view principal.
            var footviewFrameActual = footViewController.frame
            
            // Calcular la altura de la view principal restante al restarle la altura del teclado.
            footviewFrameActual.size.height -= keyboardSize.height
            
            // Calcular el punto situado en la esquina izquierda inferior de activeField.
            // (x: x, y: origin.y + height)
            let puntoEsquinaIzquierdaInferiorActiveField = CGPoint(x: activeField.frame.origin.x, y: activeField.frame.origin.y + activeField.frame.height)
            
            // Comprobar si el punto de la esquina izquierda inferior de activeField está contenido
            // en la viewFrameActual visible (lo que se ve encima del teclado).
            if !footviewFrameActual.contains(puntoEsquinaIzquierdaInferiorActiveField) {
                print("esta en frame")
                
                // El campo está oculto por el teclado.
                
                // Hay que mover la view principal hacia arriba.
                // Calcular el nuevo Y restando el punto inferior del campo Y a la viewFrameActual.
                // Además resto 8 más para darle holgura y no dejarlo pegado al teclado.
                let newViewY = self.view.frame.origin.y - puntoEsquinaIzquierdaInferiorActiveField.y - 8.0
                
                
                // Crear nuevo frame con la nueva Y. El resto de datos seguirá sin cambiar.
                let newViewFrame = CGRect(x: view.frame.origin.x, y: newViewY, width: view.frame.width,height: view.frame.height)
                
                // En conjunción con la duración de la animación del teclado.
                if let seconds = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                    UIView.animate(withDuration: seconds) {
                        self.view.frame = newViewFrame
                    }
                }
            }
            
        }
        
    }
    
    // Cuando el teclado se va a ocultar.
    @objc func keyboardWillHide(notification: NSNotification) {
        if let seconds = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            UIView.animate(withDuration: seconds) {
                print("entra  a ocultar")
                //self.footViewController.frame = CGRect(x: 0.0,y: self.footViewController.frame.origin.y,width: self.footViewController.frame.width, height: self.footViewController.frame.height)
                self.view.frame = CGRect(x: 0.0,y: 0.0,width: self.view.frame.width, height: self.view.frame.height)
            }
        }
    }
    
    
    
}
