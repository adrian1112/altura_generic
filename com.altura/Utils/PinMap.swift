//
//  PinMap.swift
//  com.altura
//
//  Created by adrian aguilar on 7/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import MapKit

class PinMap: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}
