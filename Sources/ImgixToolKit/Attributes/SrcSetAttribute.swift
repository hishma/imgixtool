//
//  SrcSetAttribute.swift
//  ImgixToolKit
//
//  Created by Jeff Johnston on 6/6/18.
//

import Foundation

public struct SrcSetAttribute: ImgAttribute {
    let url: URL
    let width: Int?
    
    public init(url: URL, width: Int?) {
        self.url = url
        self.width = width
    }
    
    public var attribute: String? {
        var sources = [SrcSetComponent]()
        sources.append(SrcSetComponent(url: url, dpr: .one, width: width))
        sources.append(SrcSetComponent(url: url, dpr: .two, width: width))
        sources.append(SrcSetComponent(url: url, dpr: .three, width: width))
        
        let srcSet = sources.compactMap({ $0.stringValue })
        guard srcSet.count == 3 else { return nil }
        
//        let foo = sources.compactMap({ $0.stringValue }).joined(separator: ", ")
        return "srcset=\"" + srcSet.joined(separator: ", ") + "\""
    }
}

enum SrcSetResolution: Int {
    case one = 1, two, three
    
    var queryItem: URLQueryItem {
        return URLQueryItem(name: "dpr", value: String(self.rawValue))
    }
    
    var suffix: String {
        return String(self.rawValue) + "x"
    }
}

struct SrcSetComponent {
    let dpr: SrcSetResolution
    let url: URL
    let width: Int?
    
    init(url: URL, dpr: SrcSetResolution, width: Int?) {
        self.url = url
        self.dpr = dpr
        self.width = width
    }
    
    var stringValue: String? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        
        if let width = width {
            components.appendQueryItem(URLQueryItem(name: "w", value: String(width)))
        }
        
        components.appendQueryItem(dpr.queryItem)
        
        guard let url = components.url else { return nil }
        
        return [url.absoluteString, dpr.suffix].joined(separator: " ")
    }
}
