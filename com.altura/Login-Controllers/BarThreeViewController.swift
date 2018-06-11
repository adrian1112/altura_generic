//
//  BarThreeViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 10/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class BarThreeViewController: UIViewController {

    weak var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.hidesBarsOnSwipe = true
        //navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsWhenKeyboardAppears = false
        
        // Do any additional setup after loading the view.
    }


    @IBAction func Logout(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "initController") as! InitController
        self.present(viewController, animated: true)
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

extension BarThreeViewController: UITextFieldDelegate {
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
            var viewFrameActual = view.frame
            
            // Calcular la altura de la view principal restante al restarle la altura del teclado.
            viewFrameActual.size.height -= keyboardSize.height
            
            // Calcular el punto situado en la esquina izquierda inferior de activeField.
            // (x: x, y: origin.y + height)
            let puntoEsquinaIzquierdaInferiorActiveField = CGPoint(x: activeField.frame.origin.x, y: activeField.frame.origin.y + activeField.frame.height)
            
            // Comprobar si el punto de la esquina izquierda inferior de activeField está contenido
            // en la viewFrameActual visible (lo que se ve encima del teclado).
            if !viewFrameActual.contains(puntoEsquinaIzquierdaInferiorActiveField) {
                
                // El campo está oculto por el teclado.
                
                // Hay que mover la view principal hacia arriba.
                // Calcular el nuevo Y restando el punto inferior del campo Y a la viewFrameActual.
                // Además resto 8 más para darle holgura y no dejarlo pegado al teclado.
                let newViewY = viewFrameActual.height - puntoEsquinaIzquierdaInferiorActiveField.y - 8.0
                
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
                self.view.frame = CGRect(x: 0.0,y: 0.0,width: self.view.frame.width, height: self.view.frame.height)
            }
        }
    }
    
    
    
}
