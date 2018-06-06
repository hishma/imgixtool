//
//  SrcAttribute.swift
//  ImgixToolKit
//
//  Created by Jeff Johnston on 6/6/18.
//

import Foundation

public struct SrcAttribute: ImgAttribute {
    let url: URL
    let width: Int?
    
    public init(url: URL, width: Int?) {
        self.url = url
        self.width = width
    }

    public var attribute: String? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil}
        
        if let width = width {
            let widthItem = URLQueryItem(name: "w", value: String(width))
            components.appendQueryItem(widthItem)
        }
        
        guard let srcUrl = components.url else { return nil }
        
        return "src=\"" + srcUrl.absoluteString + "\""
        
//        var value = ""
//
//        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false), let width = width {
//            components.appendQueryItem(URLQueryItem(name: "w", value: String(width)))
//            if let url = components.url {
//                value = url.absoluteString
//            }
//        }
//
//        return "src=\"" + value + "\""
    }
}
