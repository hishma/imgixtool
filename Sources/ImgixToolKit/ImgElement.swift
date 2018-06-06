//
//  ImgElement.swift
//  ImgixToolKit
//
//  Created by Jeff Johnston on 6/6/18.
//

import Foundation

public enum ImgElementType {
    case src, srcset
}

public struct ImgElement {
    let sourceUrl: URL
    let width: Int?
    let type: ImgElementType
    let fileUrl: URL
    let imageFile: ImageFile
    
    public init(sourceUrl: URL, path: String, type: ImgElementType = .src, width: Int?) throws {
        self.sourceUrl = sourceUrl
        self.fileUrl = URL(fileURLWithPath: path)
        self.type = type
        self.width = width
        self.imageFile = try ImageFile(path: path)
    }
    
    public var filename: String {
        return fileUrl.lastPathComponent
    }
    
    public var element: String? {
        var attributes = [ImgAttribute]()
        
        let title = TitleAttribute(imageFile: imageFile)
        attributes.append(title)
        
        let alt = AltAttribute(imageFile: imageFile)
        attributes.append(alt)
        
        let url = sourceUrl.appendingPathComponent(filename)

        if type == .srcset {
            let srcSet = SrcSetAttribute(url: url, width: width)
            attributes.append(srcSet)
        }
        
        let src = SrcAttribute(url: url, width: width)
        attributes.append(src)
        
        let attr = attributes.compactMap({ $0.attribute })
        if attr.isEmpty { return nil }
        
        return "<img \(attr.joined(separator: " "))>"
    }
}
