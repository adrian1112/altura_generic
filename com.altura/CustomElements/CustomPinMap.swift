//
//  CustomPinMap.swift
//  com.altura
//
//  Created by adrian aguilar on 28/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import Foundation
import MapKit

class CustomPinMap: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init( title: String, subtitle: String, location: CLLocationCoordinate2D) {
        self.coordinate = location
        self.title = title
        self.subtitle = subtitle
    }
}
