//
//  structures.swift
//  com.altura
//
//  Created by adrian aguilar on 25/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import Foundation
import Alamofire
import GoogleMaps
import CoreLocation


struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

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

struct location{
    var lat: NSNumber?
    var lng: NSNumber?
    
    init(lat: NSNumber, lng: NSNumber) {
        self.lat = lat
        self.lng = lng
    }
}

struct Bill {
    let name : String
    let index : Int
    var enabled : Bool
    
    init(_ name : String, _ enabled : Bool, _ index : Int) {
        self.name = name
        self.enabled = enabled
        self.index = index
    }
}

struct User: Decodable {
    let id_user: Int?
    let document: String?
    let person: String?
    var email: String?
    let phone: String?
    let sync_date: String?
    let adress: String?
    let status: Int?
    let error: String?
    
}

struct UserLogin {
    let id_user: Int?
    let email: String?
}

struct UserDB {
    var id: Int?
    var name: String?
    var email: String?
    var identifier: String?
    var addresss: String?
    var telephone: String?
    var contract: String?
    var pass: String?
}

struct data_pie {
    var name : String
    var y : Double
    
    init(name:String, y:Double) {
        self.name = name
        self.y = y
    }
}

struct Process {
    let title : String
    let subtitle : String
    let code: String
    let status: String
    let date: String
    let img: UIImage
    var enabled : Bool
    
    init(_ title : String, _ subtitle : String, _ code : String,_ status: String,_ date: String,_ img: UIImage,_ enabled: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.code = code
        self.status = status
        self.date = date
        self.img = img
        self.enabled = enabled
        
    }
}
