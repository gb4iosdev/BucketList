//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Gavin Butler on 31-08-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown Value"
        }
        
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown Value"
        }
        
        set {
            subtitle = newValue
        }
    }
}
