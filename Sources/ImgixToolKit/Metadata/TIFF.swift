//
//  TIFF.swift
//  DPG
//
//  Created by Jeff Johnston on 12/3/16.
//  Copyright © 2016 Jeff Johnston. All rights reserved.
//

import Foundation
import ImageIO

public struct TIFF: Metadata {
    public let properties: NSDictionary
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        return formatter
    }()
    
    public var artist: String? {
        return valueFor(key: kCGImagePropertyTIFFArtist)
    }
    
    public var copyright: String? {
        return valueFor(key: kCGImagePropertyTIFFCopyright)
    }
    
    public var dateTime: Date? {
        guard let dateString = valueFor(key: kCGImagePropertyTIFFDateTime) else {
            return nil
        }
        
        return TIFF.dateFormatter.date(from: dateString)
    }
}
