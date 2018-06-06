//
//  EXIF.swift
//  DPG
//
//  Created by Jeff Johnston on 12/3/16.
//  Copyright © 2016 Jeff Johnston. All rights reserved.
//

import Foundation
import ImageIO

public struct EXIF: Metadata {
    public let properties: NSDictionary
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        return formatter
    }()
    
    public var dateTimeOriginal: Date? {
        guard let dateString = valueFor(key: kCGImagePropertyExifDateTimeOriginal) else {
            return nil
        }
        
        return EXIF.dateFormatter.date(from: dateString)
    }
    
    public var dateTimeDigitized: Date? {
        
        guard let dateString = valueFor(key: kCGImagePropertyExifDateTimeDigitized) else {
            return nil
        }
        
        return EXIF.dateFormatter.date(from: dateString)
    }
}
