//
//  Metadata.swift
//  DPG
//
//  Created by Jeff Johnston on 12/3/16.
//  Copyright © 2016 Jeff Johnston. All rights reserved.
//

import Foundation

protocol Metadata {
    var properties: NSDictionary { get }
    var keys: [String] { get }
    func valueFor(key: CFString) -> String?
}


extension Metadata {
    var keys: [String] {
        return properties.allKeys.map({ String(describing: $0) })
    }
    
    func valueFor(key: CFString) -> String? {
        return properties[key] as? String
    }
}

