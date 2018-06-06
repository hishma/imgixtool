//
//  IPTC.swift
//  DPG
//
//  Created by Jeff Johnston on 12/3/16.
//  Copyright © 2016 Jeff Johnston. All rights reserved.
//

import Foundation
import ImageIO

public struct IPTC: Metadata {
    let properties: NSDictionary
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HHmmss"
        return formatter
    }()
    
    public var byline: [String]? {
        return properties[kCGImagePropertyIPTCByline] as? [String]
    }
    
    public var bylineTitle: String? {
        return valueFor(key: kCGImagePropertyIPTCBylineTitle)
    }
    
    public var captionAbstract: String? {
        return valueFor(key: kCGImagePropertyIPTCCaptionAbstract)
    }
    
    public var headline: String? {
        return valueFor(key: kCGImagePropertyIPTCHeadline)
    }
    
    public var keywords: [String]? {
        return properties[kCGImagePropertyIPTCKeywords] as? [String]
    }
    
    public var objectName: String? {
        return valueFor(key: kCGImagePropertyIPTCObjectName) as String?
    }

    
    public var copyrightNotice: String? {
        return valueFor(key: kCGImagePropertyIPTCCopyrightNotice)
    }
    
    public var rightsUsageTerms: String? {
        return valueFor(key: kCGImagePropertyIPTCRightsUsageTerms)
    }
    
    public var dateTimeCreated: Date? {
        guard
            let date = valueFor(key: kCGImagePropertyIPTCDateCreated),
            let time = valueFor(key: kCGImagePropertyIPTCTimeCreated)
            else {
                return nil
        }
        
        return IPTC.dateFormatter.date(from: "\(date) \(time)")
    }
    
    public var dateTimeDigitized: Date? {
        guard
            let date = valueFor(key: kCGImagePropertyIPTCDigitalCreationDate),
            let time = valueFor(key: kCGImagePropertyIPTCDigitalCreationTime)
            else {
                return nil
        }
        
        return IPTC.dateFormatter.date(from: "\(date) \(time)")
    }
}
