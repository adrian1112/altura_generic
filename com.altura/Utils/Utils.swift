//
//  Utils.swift
//  com.altura
//
//  Created by adrian aguilar on 26/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import Foundation

func verificarCedula(cedula: String) -> Bool {
    var cedulaCorrecta = false
    if (cedula.count == 13){
        
    }
    if (cedula.count == 10){
        
        let tercerDigito = Int(cedula.substring(with: 2..<3))!
        if (tercerDigito < 6) {
            // Coeficientes de validación cédula
            // El decimo digito se lo considera dígito verificador
            let coefValCedula = [2,1,2,1,2,1,2,1,2]
            let verificador = Int(cedula.substring(with: 9..<10))
            var suma = 0
            var digito = 0
            var i = 0
            while i <= (cedula.count - 2) {
                digito = Int(cedula.substring(with: i..<(i+1)))! * coefValCedula[i]
                suma += ((digito % 10) + (digito / 10))
                i = i + 1
            }
            
            
            if ((suma % 10 == 0) && (suma % 10 == verificador)) {
                cedulaCorrecta = true
            }else if ((10 - (suma % 10)) == verificador) {
                cedulaCorrecta = true
            } else {
                cedulaCorrecta = false
            }
        } else {
            cedulaCorrecta = false
        }
    } else {
        cedulaCorrecta = false
    }
    
    
    if (!cedulaCorrecta) {
        print("La Cédula ingresada es Incorrecta")
    }
    return cedulaCorrecta
}



extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

func isValidEmail(string: String) -> Bool {
    let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
    return emailTest.evaluate(with: string)
}

extension URLSession {
    func synchronousDataTask(urlrequest: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: urlrequest) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}
